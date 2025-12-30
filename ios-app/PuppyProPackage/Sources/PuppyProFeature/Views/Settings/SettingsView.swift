import SwiftUI
import SwiftData

struct SettingsView: View {
    @Query private var dogs: [Dog]
    @Query private var sessions: [TrainingSession]

    @State private var trainingRemindersEnabled = true
    @State private var hapticEnabled = true
    @State private var showingEditDog = false

    private var currentDog: Dog? {
        dogs.first
    }

    private var currentStreak: Int {
        var streak = 0
        let calendar = Calendar.current
        var checkDate = calendar.startOfDay(for: Date())

        while true {
            let hasSessionOnDate = sessions.contains { session in
                calendar.isDate(session.startTime, inSameDayAs: checkDate)
            }

            if hasSessionOnDate {
                streak += 1
                guard let previousDay = calendar.date(byAdding: .day, value: -1, to: checkDate) else { break }
                checkDate = previousDay
            } else if streak == 0 {
                guard let yesterday = calendar.date(byAdding: .day, value: -1, to: checkDate) else { break }
                checkDate = yesterday
            } else {
                break
            }
        }

        return streak
    }

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.lg) {
                // Dog profile card
                if let dog = currentDog {
                    profileCard(dog)
                }

                // Training settings
                settingsSection(title: "Training") {
                    toggleRow(
                        icon: "bell.fill",
                        iconColor: AppColors.primary,
                        title: "Training Reminders",
                        subtitle: "Get notified when reviews are due",
                        isOn: $trainingRemindersEnabled
                    )

                    navigationRow(
                        icon: "clock.fill",
                        iconColor: AppColors.warning,
                        title: "Reminder Time",
                        value: "9:00 AM"
                    )

                    navigationRow(
                        icon: "target",
                        iconColor: AppColors.success,
                        title: "Daily Goal",
                        value: "3 sessions"
                    )
                }

                // Clicker settings
                settingsSection(title: "Clicker") {
                    navigationRow(
                        icon: "speaker.wave.2.fill",
                        iconColor: Color.purple,
                        title: "Clicker Sound",
                        value: "Classic"
                    )

                    toggleRow(
                        icon: "waveform",
                        iconColor: Color.purple,
                        title: "Haptic Feedback",
                        subtitle: nil,
                        isOn: $hapticEnabled
                    )
                }

                // Data & Privacy
                settingsSection(title: "Data & Privacy") {
                    navigationRow(
                        icon: "arrow.down.doc.fill",
                        iconColor: AppColors.textSecondary,
                        title: "Export Training Data",
                        value: nil
                    )

                    navigationRow(
                        icon: "arrow.clockwise",
                        iconColor: AppColors.textSecondary,
                        title: "Restore Purchase",
                        value: nil
                    )

                    navigationRow(
                        icon: "trash.fill",
                        iconColor: AppColors.error,
                        title: "Reset All Progress",
                        value: nil,
                        titleColor: AppColors.error
                    )
                }

                // Support
                settingsSection(title: "Support") {
                    navigationRow(
                        icon: "questionmark.circle.fill",
                        iconColor: AppColors.textSecondary,
                        title: "Help & FAQ",
                        value: nil
                    )

                    navigationRow(
                        icon: "envelope.fill",
                        iconColor: AppColors.textSecondary,
                        title: "Contact Us",
                        value: nil
                    )

                    navigationRow(
                        icon: "star.fill",
                        iconColor: AppColors.textSecondary,
                        title: "Rate Puppy PRO",
                        value: nil
                    )
                }

                // Version info
                versionInfo
            }
            .padding(.horizontal, AppSpacing.lg)
            .padding(.bottom, 100)
        }
        .background(AppColors.background)
        .navigationTitle("Settings")
    }

    @ViewBuilder
    private func profileCard(_ dog: Dog) -> some View {
        VStack(spacing: AppSpacing.lg) {
            // Profile header
            HStack(spacing: AppSpacing.lg) {
                DogAvatar(
                    name: dog.name,
                    imageData: dog.photoData,
                    size: 80,
                    showEditButton: true
                ) {
                    showingEditDog = true
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(dog.name)
                        .font(.title2.weight(.bold))
                        .foregroundStyle(AppColors.textPrimary)

                    if let breed = dog.breed {
                        Text("\(breed) • \(dog.ageDescription)")
                            .font(AppFonts.subheadline())
                            .foregroundStyle(AppColors.textSecondary)
                    }
                }

                Spacer()
            }

            // Profile stats
            HStack(spacing: AppSpacing.sm) {
                profileStat(value: "\(currentStreak)", label: "Day Streak")
                profileStat(value: "\(sessions.count)", label: "Sessions")
                profileStat(value: "\(dog.masteredCommandsCount)", label: "Commands")
            }
        }
        .padding(AppSpacing.xl)
        .background(.white)
        .clipShape(.rect(cornerRadius: AppRadius.lg))
        .shadow(color: .black.opacity(0.04), radius: 8, y: 2)
    }

    @ViewBuilder
    private func profileStat(value: String, label: String) -> some View {
        VStack(spacing: AppSpacing.xxs) {
            Text(value)
                .font(.title2.weight(.bold))
                .foregroundStyle(AppColors.primary)

            Text(label.uppercased())
                .font(.caption2)
                .fontWeight(.semibold)
                .foregroundStyle(AppColors.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, AppSpacing.sm)
        .background(AppColors.background)
        .clipShape(.rect(cornerRadius: AppRadius.md))
    }

    @ViewBuilder
    private func settingsSection(title: String, @ViewBuilder content: () -> some View) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            Text(title.uppercased())
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(AppColors.textSecondary)
                .tracking(0.5)
                .padding(.leading, AppSpacing.xxs)

            VStack(spacing: 0) {
                content()
            }
            .background(.white)
            .clipShape(.rect(cornerRadius: AppRadius.lg))
            .shadow(color: .black.opacity(0.03), radius: 6, y: 2)
        }
    }

    @ViewBuilder
    private func toggleRow(
        icon: String,
        iconColor: Color,
        title: String,
        subtitle: String?,
        isOn: Binding<Bool>
    ) -> some View {
        HStack(spacing: AppSpacing.sm) {
            ZStack {
                iconColor.opacity(0.12)
                Image(systemName: icon)
                    .font(.body)
                    .foregroundStyle(iconColor)
            }
            .frame(width: 36, height: 36)
            .clipShape(.rect(cornerRadius: AppRadius.sm))

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(AppFonts.body())
                    .foregroundStyle(AppColors.textPrimary)

                if let subtitle {
                    Text(subtitle)
                        .font(AppFonts.caption())
                        .foregroundStyle(AppColors.textSecondary)
                }
            }

            Spacer()

            Toggle("", isOn: isOn)
                .labelsHidden()
                .tint(AppColors.primary)
        }
        .padding(AppSpacing.md)
    }

    @ViewBuilder
    private func navigationRow(
        icon: String,
        iconColor: Color,
        title: String,
        value: String?,
        titleColor: Color = AppColors.textPrimary
    ) -> some View {
        Button {
            // Navigation action
        } label: {
            HStack(spacing: AppSpacing.sm) {
                ZStack {
                    iconColor.opacity(0.12)
                    Image(systemName: icon)
                        .font(.body)
                        .foregroundStyle(iconColor)
                }
                .frame(width: 36, height: 36)
                .clipShape(.rect(cornerRadius: AppRadius.sm))

                Text(title)
                    .font(AppFonts.body())
                    .foregroundStyle(titleColor)

                Spacer()

                if let value {
                    Text(value)
                        .font(AppFonts.subheadline())
                        .foregroundStyle(AppColors.textSecondary)
                }

                Image(systemName: "chevron.right")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(AppColors.textTertiary)
            }
            .padding(AppSpacing.md)
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder
    private var versionInfo: some View {
        VStack(spacing: AppSpacing.xxs) {
            Text("Puppy PRO v1.0.0")
                .font(AppFonts.caption())
                .foregroundStyle(AppColors.textTertiary)

            HStack(spacing: 4) {
                Text("Made with")
                    .font(AppFonts.caption())
                    .foregroundStyle(AppColors.textTertiary)

                Image(systemName: "heart.fill")
                    .font(.caption)
                    .foregroundStyle(AppColors.error)

                Text("for dog lovers")
                    .font(AppFonts.caption())
                    .foregroundStyle(AppColors.textTertiary)
            }
        }
        .padding(.vertical, AppSpacing.lg)
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
    .modelContainer(for: [Dog.self, TrainingSession.self], inMemory: true)
}
