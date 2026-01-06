import SwiftUI
import SwiftData
import StoreKit

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.requestReview) private var requestReview
    @Environment(SubscriptionManager.self) private var subscriptionManager
    @Query private var dogs: [Dog]
    @Query private var sessions: [TrainingSession]

    @State private var showingPaywall = false

    private var currentDog: Dog? {
        dogs.first
    }

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.lg) {
                // Premium Card (only show for non-premium users)
                if subscriptionManager.currentTier == .free {
                    premiumCard
                } else {
                    subscriptionStatusCard
                }

                // Profile Card
                profileCard

                // Settings Sections
                settingsSections

                // Legal Section
                legalSection

                // Debug Section (QA Testing)
                #if DEBUG
                debugSection
                #endif

                // App Version
                appVersionFooter
            }
            .padding(AppSpacing.lg)
        }
        .background(AppColors.background)
        .navigationTitle("Settings")
        .sheet(isPresented: $showingPaywall) {
            SubscriptionView()
        }
    }

    // MARK: - Premium Card

    @ViewBuilder
    private var premiumCard: some View {
        Button {
            showingPaywall = true
        } label: {
            HStack(spacing: AppSpacing.md) {
                ZStack {
                    Circle()
                        .fill(AppColors.warning.opacity(0.15))
                        .frame(width: 56, height: 56)

                    PiAPIIcon(name: PiAPIIcons.trophy, size: 40)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text("Upgrade to Premium")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundStyle(AppColors.textPrimary)

                    Text("Unlock all commands & features")
                        .font(.system(size: 13))
                        .foregroundStyle(AppColors.textSecondary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(AppColors.warning)
            }
            .padding(AppSpacing.lg)
            .background(
                LinearGradient(
                    colors: [AppColors.warning.opacity(0.08), AppColors.warning.opacity(0.02)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: AppRadius.lg))
            .overlay(
                RoundedRectangle(cornerRadius: AppRadius.lg)
                    .stroke(AppColors.warning.opacity(0.3), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Upgrade to Premium")
        .accessibilityHint("Double-tap to view subscription options")
    }

    // MARK: - Subscription Status Card

    @ViewBuilder
    private var subscriptionStatusCard: some View {
        HStack(spacing: AppSpacing.md) {
            ZStack {
                Circle()
                    .fill(subscriptionManager.currentTier.color.opacity(0.15))
                    .frame(width: 56, height: 56)

                PiAPIIcon(name: subscriptionManager.currentTier.iconName, size: 40)
            }

            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 6) {
                    Text(subscriptionManager.currentTier.displayName)
                        .font(.system(size: 17, weight: .bold))
                        .foregroundStyle(AppColors.textPrimary)

                    Image(systemName: "checkmark.seal.fill")
                        .font(.system(size: 14))
                        .foregroundStyle(subscriptionManager.currentTier.color)
                }

                Text("Premium member")
                    .font(.system(size: 13))
                    .foregroundStyle(AppColors.textSecondary)
            }

            Spacer()
        }
        .padding(AppSpacing.lg)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.lg))
        .shadow(color: .black.opacity(0.05), radius: 8, y: 2)
    }

    @ViewBuilder
    private var profileCard: some View {
        VStack(spacing: AppSpacing.md) {
            if let dog = currentDog {
                DogAvatar(
                    name: dog.name,
                    breed: dog.breed,
                    imageData: dog.photoData,
                    size: 80
                )

                Text(dog.name)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(AppColors.textPrimary)

                if let breed = dog.breed {
                    Text(breed)
                        .font(.system(size: 14))
                        .foregroundStyle(AppColors.textSecondary)
                }

                Text("\(sessions.count) training sessions")
                    .font(.system(size: 13))
                    .foregroundStyle(AppColors.textTertiary)
            } else {
                Text("No dog added yet")
                    .font(.system(size: 16))
                    .foregroundStyle(AppColors.textSecondary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(AppSpacing.xl)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.lg))
        .shadow(color: .black.opacity(0.05), radius: 8, y: 2)
    }

    @ViewBuilder
    private var settingsSections: some View {
        VStack(spacing: AppSpacing.md) {
            NavigationLink {
                NotificationsView()
            } label: {
                SettingsRow(
                    iconName: PiAPIIcons.bell,
                    title: "Notifications",
                    subtitle: "Reminders & alerts"
                )
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Notifications Settings")
            .accessibilityHint("Double-tap to configure reminders and alerts")

            NavigationLink {
                TrainingGoalsView()
            } label: {
                SettingsRow(
                    iconName: PiAPIIcons.target,
                    title: "Training Goals",
                    subtitle: "Daily session targets"
                )
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Training Goals")
            .accessibilityHint("Double-tap to set your daily session targets")

            Button {
                requestReview()
            } label: {
                SettingsRow(
                    iconName: PiAPIIcons.star,
                    title: "Rate App",
                    subtitle: "Share your feedback"
                )
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Rate App")
            .accessibilityHint("Double-tap to rate PuppyPro on the App Store")
        }
        .padding(AppSpacing.md)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.lg))
        .shadow(color: .black.opacity(0.05), radius: 8, y: 2)
    }

    // MARK: - Legal Section

    @ViewBuilder
    private var legalSection: some View {
        VStack(spacing: AppSpacing.md) {
            Link(destination: URL(string: "https://dog-training-tracker-landing.vercel.app/privacy")!) {
                SettingsRow(
                    iconName: PiAPIIcons.shieldCheck,
                    title: "Privacy Policy",
                    subtitle: "How we protect your data"
                )
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Privacy Policy")
            .accessibilityHint("Double-tap to view our privacy policy")

            Link(destination: URL(string: "https://dog-training-tracker-landing.vercel.app/terms")!) {
                SettingsRow(
                    iconName: PiAPIIcons.help,
                    title: "Terms of Use",
                    subtitle: "App usage terms"
                )
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Terms of Use")
            .accessibilityHint("Double-tap to view terms of use")
        }
        .padding(AppSpacing.md)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.lg))
        .shadow(color: .black.opacity(0.05), radius: 8, y: 2)
    }

    // MARK: - Debug Section

    #if DEBUG
    @ViewBuilder
    private var debugSection: some View {
        VStack(spacing: AppSpacing.md) {
            NavigationLink {
                CelebrationAnimationsQAView()
            } label: {
                SettingsRow(
                    iconName: PiAPIIcons.trophy,
                    title: "QA: All Celebrations",
                    subtitle: "View all 20 animations"
                )
            }
            .buttonStyle(.plain)
            .accessibilityLabel("QA All Celebrations")
            .accessibilityHint("Double-tap to view all celebration animations")
        }
        .padding(AppSpacing.md)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.lg))
        .shadow(color: .black.opacity(0.05), radius: 8, y: 2)
    }
    #endif

    // MARK: - App Version Footer

    @ViewBuilder
    private var appVersionFooter: some View {
        VStack(spacing: 4) {
            Text("Puppy PRO")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(AppColors.textSecondary)

            Text("Version \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0") (\(Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"))")
                .font(.system(size: 12))
                .foregroundStyle(AppColors.textTertiary)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, AppSpacing.lg)
        .padding(.bottom, 80)
    }
}

// MARK: - Settings Row

struct SettingsRow: View {
    let iconName: String
    let title: String
    let subtitle: String

    var body: some View {
        HStack(spacing: AppSpacing.md) {
            // PiAPI 3D icons already have a white background baked in
            PiAPIIcon(name: iconName, size: 40)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(AppColors.textPrimary)

                Text(subtitle)
                    .font(.system(size: 13))
                    .foregroundStyle(AppColors.textSecondary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(AppColors.textTertiary)
        }
        .padding(.vertical, AppSpacing.sm)
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
    .environment(SubscriptionManager())
}
