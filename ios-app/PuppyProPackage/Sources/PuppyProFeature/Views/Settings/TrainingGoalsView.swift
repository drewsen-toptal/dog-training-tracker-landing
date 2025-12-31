import SwiftUI
import SwiftData

struct TrainingGoalsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var userSettings: [UserSettings]

    private var settings: UserSettings? {
        userSettings.first
    }

    @State private var selectedGoal: Int = 3

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xl) {
                // Header illustration
                headerSection

                // Goal selector
                goalSelector

                // Benefits info
                benefitsSection
            }
            .padding(AppSpacing.lg)
            .padding(.bottom, 100) // Extra bottom padding for full scroll visibility (accounts for tab bar)
        }
        .background(AppColors.background)
        .navigationTitle("Training Goals")
        .navigationBarTitleDisplayMode(.large)
        .onAppear {
            if let settings = settings {
                selectedGoal = settings.dailyGoal
            }
        }
        .onChange(of: selectedGoal) { _, newValue in
            updateGoal(newValue)
        }
    }

    @ViewBuilder
    private var headerSection: some View {
        VStack(spacing: AppSpacing.md) {
            ZStack {
                Circle()
                    .fill(AppColors.primary.opacity(0.1))
                    .frame(width: 100, height: 100)

                PiAPIIcon(name: PiAPIIcons.target, size: 56)
            }

            Text("Daily Session Goal")
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(AppColors.textPrimary)

            Text("Set how many training sessions you want to complete each day")
                .font(.system(size: 15))
                .foregroundStyle(AppColors.textSecondary)
                .multilineTextAlignment(.center)
        }
        .padding(.top, AppSpacing.lg)
    }

    @ViewBuilder
    private var goalSelector: some View {
        VStack(spacing: AppSpacing.lg) {
            // Current goal display
            Text("\(selectedGoal)")
                .font(.system(size: 72, weight: .bold))
                .foregroundStyle(AppColors.primary)

            Text(selectedGoal == 1 ? "session per day" : "sessions per day")
                .font(.system(size: 17, weight: .medium))
                .foregroundStyle(AppColors.textSecondary)

            // Slider
            VStack(spacing: AppSpacing.sm) {
                Slider(
                    value: Binding(
                        get: { Double(selectedGoal) },
                        set: { selectedGoal = Int($0) }
                    ),
                    in: 1...10,
                    step: 1
                )
                .tint(AppColors.primary)

                HStack {
                    Text("1")
                        .font(.system(size: 13))
                        .foregroundStyle(AppColors.textTertiary)
                    Spacer()
                    Text("10")
                        .font(.system(size: 13))
                        .foregroundStyle(AppColors.textTertiary)
                }
            }
            .padding(.horizontal, AppSpacing.md)
        }
        .padding(AppSpacing.xl)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.lg))
        .shadow(color: .black.opacity(0.05), radius: 10, y: 2)
    }

    @ViewBuilder
    private var benefitsSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text("Tips for Success")
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(AppColors.textPrimary)

            benefitRow(
                icon: "clock.fill",
                title: "Keep sessions short",
                description: "5-10 minutes is ideal for most dogs"
            )

            benefitRow(
                icon: "arrow.triangle.2.circlepath",
                title: "Be consistent",
                description: "Daily practice builds lasting habits"
            )

            benefitRow(
                icon: "star.fill",
                title: "End on success",
                description: "Always finish with a command your dog knows"
            )
        }
        .padding(AppSpacing.lg)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.lg))
        .shadow(color: .black.opacity(0.05), radius: 10, y: 2)
    }

    @ViewBuilder
    private func benefitRow(icon: String, title: String, description: String) -> some View {
        HStack(alignment: .top, spacing: AppSpacing.md) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundStyle(AppColors.primary)
                .frame(width: 32, height: 32)
                .background(AppColors.primary.opacity(0.1))
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(AppColors.textPrimary)

                Text(description)
                    .font(.system(size: 13))
                    .foregroundStyle(AppColors.textSecondary)
            }
        }
    }

    private func updateGoal(_ newGoal: Int) {
        if let settings = settings {
            settings.dailyGoal = newGoal
        } else {
            let newSettings = UserSettings()
            newSettings.dailyGoal = newGoal
            modelContext.insert(newSettings)
        }
    }
}

#Preview {
    NavigationStack {
        TrainingGoalsView()
    }
    .modelContainer(for: UserSettings.self, inMemory: true)
}
