import SwiftUI
import SwiftData
import StoreKit

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.requestReview) private var requestReview
    @Query private var dogs: [Dog]
    @Query private var sessions: [TrainingSession]

    private var currentDog: Dog? {
        dogs.first
    }

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.lg) {
                // Profile Card
                profileCard

                // Settings Sections
                settingsSections
            }
            .padding(AppSpacing.lg)
        }
        .background(AppColors.background)
        .navigationTitle("Settings")
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
}
