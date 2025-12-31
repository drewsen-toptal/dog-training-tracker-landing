import SwiftUI
import StoreKit

struct SubscriptionView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(SubscriptionManager.self) private var subscriptionManager

    @State private var selectedProduct: Product?
    @State private var showingError = false
    @State private var isPurchasing = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    // Hero Section
                    heroSection

                    // Product Cards
                    productCardsSection

                    // Features Comparison
                    featuresSection

                    // Restore Purchases
                    restoreSection
                }
            }
            .background(AppColors.background)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 28))
                            .foregroundStyle(AppColors.textTertiary)
                    }
                    .accessibilityLabel("Close")
                }
            }
            .alert("Error", isPresented: $showingError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(subscriptionManager.errorMessage ?? "An error occurred")
            }
            .onChange(of: subscriptionManager.errorMessage) { _, newValue in
                if newValue != nil {
                    showingError = true
                }
            }
        }
    }

    // MARK: - Hero Section

    @ViewBuilder
    private var heroSection: some View {
        VStack(spacing: AppSpacing.lg) {
            PiAPIIcon(name: PiAPIIcons.trophy, size: 80)

            VStack(spacing: AppSpacing.xs) {
                Text("Unlock Your Dog's")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(AppColors.textPrimary)

                Text("Full Potential")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(AppColors.primary)
            }

            Text("Get access to all training commands, detailed progress tracking, and personalized training plans.")
                .font(.system(size: 15))
                .foregroundStyle(AppColors.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, AppSpacing.xl)
        }
        .padding(.vertical, AppSpacing.xl)
        .frame(maxWidth: .infinity)
        .background(
            LinearGradient(
                colors: [.white, AppColors.primary.opacity(0.05)],
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }

    // MARK: - Product Cards

    @ViewBuilder
    private var productCardsSection: some View {
        VStack(spacing: AppSpacing.md) {
            if subscriptionManager.isLoading && subscriptionManager.products.isEmpty {
                ProgressView()
                    .padding(AppSpacing.xl)
            } else {
                ForEach(subscriptionManager.products, id: \.id) { product in
                    ProductCard(
                        product: product,
                        isSelected: selectedProduct?.id == product.id,
                        isPopular: product.id == PuppyProProduct.bestFriend.rawValue,
                        isPurchased: subscriptionManager.purchasedProductIDs.contains(product.id)
                    ) {
                        selectedProduct = product
                    }
                }
            }

            // Purchase Button
            if let product = selectedProduct,
               !subscriptionManager.purchasedProductIDs.contains(product.id) {
                Button {
                    Task {
                        isPurchasing = true
                        do {
                            try await subscriptionManager.purchase(product)
                        } catch {
                            // Error handled by manager
                        }
                        isPurchasing = false
                    }
                } label: {
                    HStack {
                        if isPurchasing {
                            ProgressView()
                                .tint(.white)
                        } else {
                            Text("Continue with \(product.displayName)")
                                .font(.system(size: 17, weight: .semibold))
                        }
                    }
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(AppColors.primaryGradient)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .disabled(isPurchasing)
                .padding(.top, AppSpacing.sm)
            }
        }
        .padding(AppSpacing.lg)
    }

    // MARK: - Features Section

    @ViewBuilder
    private var featuresSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text("What You Get")
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(AppColors.textPrimary)

            VStack(spacing: AppSpacing.sm) {
                FeatureRow(icon: PiAPIIcons.target, text: "50+ professional training commands")
                FeatureRow(icon: PiAPIIcons.tabProgress, text: "Detailed progress analytics")
                FeatureRow(icon: PiAPIIcons.lightbulb, text: "Spaced repetition algorithm")
                FeatureRow(icon: PiAPIIcons.bell, text: "Smart training reminders")
                FeatureRow(icon: PiAPIIcons.star, text: "Achievement badges")
            }
        }
        .padding(AppSpacing.lg)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.lg))
        .shadow(color: .black.opacity(0.05), radius: 8, y: 2)
        .padding(.horizontal, AppSpacing.lg)
    }

    // MARK: - Restore Section

    @ViewBuilder
    private var restoreSection: some View {
        VStack(spacing: AppSpacing.md) {
            Button {
                Task {
                    await subscriptionManager.restorePurchases()
                }
            } label: {
                Text("Restore Purchases")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(AppColors.primary)
            }

            Text("One-time purchase. No subscription.")
                .font(.system(size: 12))
                .foregroundStyle(AppColors.textTertiary)
        }
        .padding(.vertical, AppSpacing.xl)
        .padding(.bottom, 40)
    }
}

// MARK: - Product Card

struct ProductCard: View {
    let product: Product
    let isSelected: Bool
    let isPopular: Bool
    let isPurchased: Bool
    let onSelect: () -> Void

    private var puppyProProduct: PuppyProProduct? {
        PuppyProProduct(rawValue: product.id)
    }

    var body: some View {
        Button(action: onSelect) {
            VStack(alignment: .leading, spacing: AppSpacing.md) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack(spacing: 8) {
                            Text(product.displayName)
                                .font(.system(size: 18, weight: .bold))
                                .foregroundStyle(AppColors.textPrimary)

                            if isPopular {
                                Text("POPULAR")
                                    .font(.system(size: 10, weight: .bold))
                                    .foregroundStyle(.white)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(AppColors.primary)
                                    .clipShape(Capsule())
                            }

                            if isPurchased {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(AppColors.success)
                            }
                        }

                        Text(product.description)
                            .font(.system(size: 13))
                            .foregroundStyle(AppColors.textSecondary)
                    }

                    Spacer()

                    VStack(alignment: .trailing, spacing: 2) {
                        Text(product.displayPrice)
                            .font(.system(size: 22, weight: .bold))
                            .foregroundStyle(isSelected ? AppColors.primary : AppColors.textPrimary)

                        Text("Lifetime")
                            .font(.system(size: 11))
                            .foregroundStyle(AppColors.textTertiary)
                    }
                }

                // Feature list
                if let features = puppyProProduct?.features {
                    VStack(alignment: .leading, spacing: 6) {
                        ForEach(features, id: \.self) { feature in
                            HStack(spacing: 8) {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 11, weight: .bold))
                                    .foregroundStyle(AppColors.success)

                                Text(feature)
                                    .font(.system(size: 13))
                                    .foregroundStyle(AppColors.textSecondary)
                            }
                        }
                    }
                }
            }
            .padding(AppSpacing.lg)
            .background(isPurchased ? AppColors.success.opacity(0.08) : .white)
            .clipShape(RoundedRectangle(cornerRadius: AppRadius.lg))
            .overlay {
                RoundedRectangle(cornerRadius: AppRadius.lg)
                    .stroke(
                        isSelected ? AppColors.primary : (isPopular ? AppColors.primary.opacity(0.3) : Color.clear),
                        lineWidth: isSelected ? 2.5 : 1.5
                    )
            }
            .shadow(color: .black.opacity(0.05), radius: 8, y: 2)
        }
        .buttonStyle(.plain)
        .disabled(isPurchased)
    }
}

// MARK: - Feature Row

struct FeatureRow: View {
    let icon: String
    let text: String

    var body: some View {
        HStack(spacing: AppSpacing.sm) {
            PiAPIIcon(name: icon, size: 28)

            Text(text)
                .font(.system(size: 14))
                .foregroundStyle(AppColors.textPrimary)

            Spacer()
        }
    }
}

#Preview {
    SubscriptionView()
        .environment(SubscriptionManager())
}
