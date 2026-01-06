import SwiftUI
import StoreKit

struct SubscriptionView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(SubscriptionManager.self) private var subscriptionManager

    @State private var selectedTier: PuppyProProduct = .bestFriend
    @State private var showingError = false
    @State private var isPurchasing = false
    @State private var animateIn = false
    @State private var localErrorMessage: String?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    // Hero Section
                    heroSection

                    // Tier Cards
                    tierCardsSection

                    // Features Comparison
                    featuresSection

                    // Purchase Button
                    purchaseButton

                    // Restore & Legal
                    footerSection
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
                Text(localErrorMessage ?? subscriptionManager.errorMessage ?? "An error occurred")
            }
            .onChange(of: subscriptionManager.errorMessage) { _, newValue in
                if newValue != nil {
                    showingError = true
                }
            }
            .onChange(of: localErrorMessage) { _, newValue in
                if newValue != nil {
                    showingError = true
                }
            }
            .onAppear {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.1)) {
                    animateIn = true
                }
            }
        }
    }

    // MARK: - Hero Section

    @ViewBuilder
    private var heroSection: some View {
        VStack(spacing: AppSpacing.lg) {
            // Animated mascot with glow
            ZStack {
                Circle()
                    .fill(AppColors.primary.opacity(0.1))
                    .frame(width: 100, height: 100)
                    .blur(radius: 20)

                PiAPIIcon(name: PiAPIIcons.puppyMascot, size: 80)
                    .scaleEffect(animateIn ? 1 : 0.5)
                    .opacity(animateIn ? 1 : 0)
            }

            VStack(spacing: AppSpacing.xs) {
                Text("Unlock Your Dog's")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(AppColors.textPrimary)

                Text("Full Potential")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(AppColors.primary)
            }
            .opacity(animateIn ? 1 : 0)
            .offset(y: animateIn ? 0 : 20)

            Text("Choose the plan that's right for you and your pup")
                .font(.system(size: 15))
                .foregroundStyle(AppColors.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, AppSpacing.xl)
                .opacity(animateIn ? 1 : 0)
        }
        .padding(.vertical, AppSpacing.xl)
        .frame(maxWidth: .infinity)
        .background(
            LinearGradient(
                colors: [.white, AppColors.primary.opacity(0.03)],
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }

    // MARK: - Tier Cards

    @ViewBuilder
    private var tierCardsSection: some View {
        VStack(spacing: AppSpacing.md) {
            ForEach(PuppyProProduct.allCases, id: \.rawValue) { tier in
                TierCard(
                    tier: tier,
                    product: productFor(tier: tier),
                    isSelected: selectedTier == tier,
                    isPopular: tier == .bestFriend,
                    isPurchased: subscriptionManager.purchasedProductIDs.contains(tier.rawValue)
                ) {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedTier = tier
                    }
                }
                .opacity(animateIn ? 1 : 0)
                .offset(y: animateIn ? 0 : 30)
                .animation(
                    .spring(response: 0.6, dampingFraction: 0.8)
                        .delay(Double(tier.tier) * 0.1),
                    value: animateIn
                )
            }
        }
        .padding(AppSpacing.lg)
    }

    // MARK: - Features Section

    @ViewBuilder
    private var featuresSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text("All Plans Include")
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(AppColors.textPrimary)

            VStack(spacing: AppSpacing.sm) {
                FeatureRow(icon: PiAPIIcons.clicker, text: "Professional clicker training tool")
                FeatureRow(icon: PiAPIIcons.tabProgress, text: "Progress tracking dashboard")
                FeatureRow(icon: PiAPIIcons.lightbulb, text: "Science-backed training methods")
                FeatureRow(icon: PiAPIIcons.bell, text: "Training reminders")
            }
        }
        .padding(AppSpacing.lg)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.lg))
        .shadow(color: .black.opacity(0.05), radius: 8, y: 2)
        .padding(.horizontal, AppSpacing.lg)
    }

    // MARK: - Purchase Button

    @ViewBuilder
    private var purchaseButton: some View {
        let isPurchased = subscriptionManager.purchasedProductIDs.contains(selectedTier.rawValue)

        if !isPurchased {
            Button {
                Task {
                    await purchaseSelectedTier()
                }
            } label: {
                HStack(spacing: 8) {
                    if isPurchasing {
                        ProgressView()
                            .tint(.white)
                    } else {
                        Text("Get \(selectedTier.displayName)")
                            .font(.system(size: 17, weight: .bold))

                        Text("•")
                            .font(.system(size: 14))
                            .opacity(0.7)

                        Text(priceFor(tier: selectedTier))
                            .font(.system(size: 17, weight: .semibold))
                    }
                }
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(
                    LinearGradient(
                        colors: [selectedTier.subscriptionTier.color, selectedTier.subscriptionTier.color.opacity(0.8)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(color: selectedTier.subscriptionTier.color.opacity(0.3), radius: 12, y: 6)
            }
            .disabled(isPurchasing)
            .padding(.horizontal, AppSpacing.lg)
            .padding(.top, AppSpacing.lg)
        }
    }

    // MARK: - Footer Section

    @ViewBuilder
    private var footerSection: some View {
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

            VStack(spacing: 4) {
                Text("One-time purchase. No subscription.")
                    .font(.system(size: 12))
                    .foregroundStyle(AppColors.textTertiary)

                Text("Lifetime access on all your devices")
                    .font(.system(size: 12))
                    .foregroundStyle(AppColors.textTertiary)
            }
        }
        .padding(.vertical, AppSpacing.xl)
        .padding(.bottom, 40)
    }

    // MARK: - Helpers

    private func productFor(tier: PuppyProProduct) -> Product? {
        subscriptionManager.products.first { $0.id == tier.rawValue }
    }

    private func priceFor(tier: PuppyProProduct) -> String {
        if let product = productFor(tier: tier) {
            return product.displayPrice
        }
        return tier.fallbackPrice
    }

    private func purchaseSelectedTier() async {
        // If products haven't loaded yet, try loading them
        if subscriptionManager.products.isEmpty {
            await subscriptionManager.loadProducts()
        }

        guard let product = productFor(tier: selectedTier) else {
            // Products failed to load - provide helpful error
            if subscriptionManager.products.isEmpty {
                localErrorMessage = "Unable to connect to the App Store. Please check your internet connection and try again."
            } else {
                localErrorMessage = "This product is temporarily unavailable. Please try again later."
            }
            return
        }

        isPurchasing = true
        do {
            try await subscriptionManager.purchase(product)
            // Auto-dismiss on successful purchase
            if subscriptionManager.purchasedProductIDs.contains(product.id) {
                dismiss()
            }
        } catch {
            // Error handled by manager
        }
        isPurchasing = false
    }
}

// MARK: - Tier Card

struct TierCard: View {
    let tier: PuppyProProduct
    let product: Product?
    let isSelected: Bool
    let isPopular: Bool
    let isPurchased: Bool
    let onSelect: () -> Void

    private var displayPrice: String {
        product?.displayPrice ?? tier.fallbackPrice
    }

    private var tierColor: Color {
        tier.subscriptionTier.color
    }

    var body: some View {
        Button(action: onSelect) {
            HStack(spacing: 14) {
                // Icon with tier color background
                ZStack {
                    Circle()
                        .fill(tierColor.opacity(0.15))
                        .frame(width: 56, height: 56)

                    PiAPIIcon(name: tier.iconName, size: 36)
                }

                // Content
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 8) {
                        Text(tier.displayName)
                            .font(.system(size: 17, weight: .bold))
                            .foregroundStyle(AppColors.textPrimary)

                        if isPopular {
                            Text("BEST VALUE")
                                .font(.system(size: 9, weight: .bold))
                                .foregroundStyle(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 3)
                                .background(tierColor)
                                .clipShape(Capsule())
                        }

                        if isPurchased {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 16))
                                .foregroundStyle(AppColors.success)
                        }
                    }

                    Text(tier.tagline)
                        .font(.system(size: 13))
                        .foregroundStyle(AppColors.textSecondary)
                }

                Spacer()

                // Price
                VStack(alignment: .trailing, spacing: 2) {
                    Text(displayPrice)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(isSelected ? tierColor : AppColors.textPrimary)

                    Text("Lifetime")
                        .font(.system(size: 11))
                        .foregroundStyle(AppColors.textTertiary)
                }
            }
            .padding(16)
            .background(isPurchased ? AppColors.success.opacity(0.08) : .white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        isSelected ? tierColor : (isPopular ? tierColor.opacity(0.3) : Color.clear),
                        lineWidth: isSelected ? 2.5 : 1.5
                    )
            }
            .shadow(
                color: isSelected ? tierColor.opacity(0.15) : .black.opacity(0.05),
                radius: isSelected ? 12 : 6,
                y: isSelected ? 4 : 2
            )
        }
        .buttonStyle(.plain)
        .disabled(isPurchased)
        .accessibilityLabel("\(tier.displayName) tier, \(displayPrice), \(tier.tagline)")
        .accessibilityAddTraits(isSelected ? [.isSelected] : [])
        .accessibilityAddTraits(isPurchased ? [] : [.isButton])
        .accessibilityHint(isPurchased ? "Already purchased" : "Double-tap to select this tier")
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
