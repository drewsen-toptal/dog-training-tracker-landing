import Foundation
import StoreKit
import SwiftUI

// MARK: - Subscription Tiers

enum SubscriptionTier: Int, Comparable {
    case free = 0
    case goodBoy = 1
    case bestFriend = 2
    case packLeader = 3

    var level: Int { rawValue }

    static func < (lhs: SubscriptionTier, rhs: SubscriptionTier) -> Bool {
        lhs.rawValue < rhs.rawValue
    }

    var displayName: String {
        switch self {
        case .free: return "Free"
        case .goodBoy: return "Good Boy"
        case .bestFriend: return "Best Friend"
        case .packLeader: return "Pack Leader"
        }
    }

    var color: Color {
        switch self {
        case .free: return AppColors.textSecondary
        case .goodBoy: return AppColors.primary
        case .bestFriend: return AppColors.warning
        case .packLeader: return AppColors.success
        }
    }

    var iconName: String {
        switch self {
        case .free: return PiAPIIcons.star
        case .goodBoy: return PiAPIIcons.star
        case .bestFriend: return PiAPIIcons.trophy
        case .packLeader: return PiAPIIcons.trophy
        }
    }
}

// MARK: - Product IDs

enum PuppyProProduct: String, CaseIterable {
    case goodBoy = "puppypro.goodboy.lifetime"
    case bestFriend = "puppypro.bestfriend.lifetime"
    case packLeader = "puppypro.packleader.lifetime"

    var tier: Int {
        switch self {
        case .goodBoy: return 1
        case .bestFriend: return 2
        case .packLeader: return 3
        }
    }

    var subscriptionTier: SubscriptionTier {
        switch self {
        case .goodBoy: return .goodBoy
        case .bestFriend: return .bestFriend
        case .packLeader: return .packLeader
        }
    }

    var displayName: String {
        switch self {
        case .goodBoy: return "Good Boy"
        case .bestFriend: return "Best Friend"
        case .packLeader: return "Pack Leader"
        }
    }

    var tagline: String {
        switch self {
        case .goodBoy: return "Start your training journey"
        case .bestFriend: return "Most popular choice"
        case .packLeader: return "For the serious trainer"
        }
    }

    var fallbackPrice: String {
        switch self {
        case .goodBoy: return "$2.99"
        case .bestFriend: return "$5.99"
        case .packLeader: return "$39.99"
        }
    }

    var iconName: String {
        switch self {
        case .goodBoy: return PiAPIIcons.star
        case .bestFriend: return PiAPIIcons.trophy
        case .packLeader: return PiAPIIcons.fireStreak
        }
    }

    var features: [String] {
        switch self {
        case .goodBoy:
            return [
                "6 training commands",
                "Basic progress tracking",
                "Training reminders"
            ]
        case .bestFriend:
            return [
                "All 12 training commands",
                "Detailed analytics & insights",
                "Personalized training plans",
                "Export training data"
            ]
        case .packLeader:
            return [
                "Everything in Best Friend",
                "Unlimited dogs",
                "Family sharing",
                "Priority support",
                "Early access to new features"
            ]
        }
    }
}

// MARK: - Subscription Manager

@MainActor
@Observable
final class SubscriptionManager {
    private(set) var products: [Product] = []
    private(set) var purchasedProductIDs: Set<String> = []
    private(set) var isLoading = false
    private(set) var errorMessage: String?

    // nonisolated(unsafe) to allow cancellation in deinit
    private nonisolated(unsafe) var transactionListener: Task<Void, Error>?

    var currentTier: SubscriptionTier {
        if purchasedProductIDs.contains(PuppyProProduct.packLeader.rawValue) {
            return .packLeader
        } else if purchasedProductIDs.contains(PuppyProProduct.bestFriend.rawValue) {
            return .bestFriend
        } else if purchasedProductIDs.contains(PuppyProProduct.goodBoy.rawValue) {
            return .goodBoy
        }
        return .free
    }

    var hasProAccess: Bool {
        currentTier >= .goodBoy
    }

    var hasPremiumAccess: Bool {
        currentTier >= .bestFriend
    }

    var hasUnlimitedAccess: Bool {
        currentTier >= .packLeader
    }

    init() {
        transactionListener = listenForTransactions()

        Task {
            await loadProducts()
            await updatePurchasedProducts()
        }
    }

    deinit {
        transactionListener?.cancel()
    }

    // MARK: - Load Products

    func loadProducts() async {
        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil

        do {
            let productIDs = PuppyProProduct.allCases.map { $0.rawValue }
            let fetchedProducts = try await Product.products(for: productIDs)

            // Sort by price (ascending)
            products = fetchedProducts.sorted {
                ($0.price as NSDecimalNumber).doubleValue < ($1.price as NSDecimalNumber).doubleValue
            }

            // Log for debugging (only in debug builds)
            #if DEBUG
            print("[StoreKit] Loaded \(products.count) products: \(products.map { $0.id })")
            if products.count < productIDs.count {
                let loadedIDs = Set(products.map { $0.id })
                let missingIDs = Set(productIDs).subtracting(loadedIDs)
                print("[StoreKit] Missing products: \(missingIDs)")
            }
            #endif
        } catch {
            #if DEBUG
            print("[StoreKit] Failed to load products: \(error)")
            #endif
            errorMessage = "Unable to load products. Please check your connection and try again."
        }

        isLoading = false
    }

    // MARK: - Purchase

    func purchase(_ product: Product) async throws {
        isLoading = true
        errorMessage = nil

        defer { isLoading = false }

        let result = try await product.purchase()

        switch result {
        case .success(let verification):
            let transaction = try checkVerified(verification)
            await updatePurchasedProducts()
            await transaction.finish()

        case .userCancelled:
            break

        case .pending:
            errorMessage = "Purchase is pending approval"

        @unknown default:
            errorMessage = "Unknown purchase result"
        }
    }

    // MARK: - Restore Purchases

    func restorePurchases() async {
        isLoading = true
        errorMessage = nil

        defer { isLoading = false }

        do {
            try await AppStore.sync()
            await updatePurchasedProducts()
        } catch {
            errorMessage = "Failed to restore purchases: \(error.localizedDescription)"
        }
    }

    // MARK: - Update Purchased Products

    func updatePurchasedProducts() async {
        var purchasedIDs: Set<String> = []

        for await result in Transaction.currentEntitlements {
            do {
                let transaction = try checkVerified(result)
                purchasedIDs.insert(transaction.productID)
            } catch {
                continue
            }
        }

        purchasedProductIDs = purchasedIDs
    }

    // MARK: - Transaction Listener

    private func listenForTransactions() -> Task<Void, Error> {
        Task.detached { [weak self] in
            for await result in Transaction.updates {
                do {
                    let transaction = try self?.checkVerified(result)
                    await self?.updatePurchasedProducts()
                    await transaction?.finish()
                } catch {
                    continue
                }
            }
        }
    }

    // MARK: - Verification

    // nonisolated since this is a pure function with no actor-isolated state access
    private nonisolated func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw StoreError.failedVerification
        case .verified(let safe):
            return safe
        }
    }
}

// MARK: - Store Error

enum StoreError: LocalizedError {
    case failedVerification

    var errorDescription: String? {
        switch self {
        case .failedVerification:
            return "Transaction verification failed"
        }
    }
}
