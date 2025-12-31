import SwiftUI
import SwiftData

struct ProgressDashboardView: View {
    @Query private var dogs: [Dog]
    @Query(sort: \TrainingSession.startTime, order: .reverse) private var sessions: [TrainingSession]

    private var currentDog: Dog? {
        dogs.first
    }

    private var weeklyData: [DayActivity] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        // Get start of week (Monday)
        let weekday = calendar.component(.weekday, from: today)
        let daysFromMonday = (weekday + 5) % 7 // Convert to Monday = 0
        guard let startOfWeek = calendar.date(byAdding: .day, value: -daysFromMonday, to: today) else {
            return []
        }

        return (0..<7).compactMap { dayOffset -> DayActivity? in
            guard let date = calendar.date(byAdding: .day, value: dayOffset, to: startOfWeek) else {
                return nil
            }

            let dayFormatter = DateFormatter()
            dayFormatter.dateFormat = "EEE"
            let dayName = dayFormatter.string(from: date)

            let daySessions = sessions.filter { session in
                calendar.isDate(session.startTime, inSameDayAs: date)
            }

            let totalReps = daySessions.reduce(0) { $0 + $1.totalReps }
            let percentage = min(Double(totalReps) / 30.0, 1.0) // 30 reps = 100%

            return DayActivity(day: dayName, percentage: percentage)
        }
    }

    private var successRate: Int {
        let totalReps = sessions.reduce(0) { $0 + $1.totalReps }
        let successReps = sessions.reduce(0) { $0 + $1.successCount }
        guard totalReps > 0 else { return 0 }
        return Int(Double(successReps) / Double(totalReps) * 100)
    }

    private var currentStreak: Int {
        guard !sessions.isEmpty else { return 0 }

        var streak = 0
        let calendar = Calendar.current
        var checkDate = calendar.startOfDay(for: Date())
        var checkedYesterday = false

        while true {
            let hasSessionOnDate = sessions.contains { session in
                calendar.isDate(session.startTime, inSameDayAs: checkDate)
            }

            if hasSessionOnDate {
                streak += 1
                guard let previousDay = calendar.date(byAdding: .day, value: -1, to: checkDate) else { break }
                checkDate = previousDay
            } else if streak == 0 && !checkedYesterday {
                checkedYesterday = true
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
            VStack(spacing: 0) {
                // Dog profile header or empty state
                if let dog = currentDog {
                    dogHeader(dog)

                    // Stats cards
                    HStack(spacing: 16) {
                        StatCard(
                            title: "Success Rate",
                            value: "\(successRate)%",
                            iconName: PiAPIIcons.checkmark,
                            valueColor: AppColors.success
                        )

                        StatCard(
                            title: "Day Streak",
                            value: "\(currentStreak)",
                            iconName: PiAPIIcons.fireStreak,
                            valueColor: AppColors.warning
                        )
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 24)

                    // Weekly activity chart
                    weeklyActivityChart
                        .padding(.horizontal, 24)
                        .padding(.bottom, 24)

                    // Recent achievements or empty state
                    if sessions.isEmpty {
                        noTrainingDataCard
                            .padding(.horizontal, 24)
                            .padding(.bottom, 100)
                    } else {
                        achievementsSection
                            .padding(.horizontal, 24)
                            .padding(.bottom, 100)
                    }
                } else {
                    // No dog empty state
                    EmptyStateView(
                        iconName: PiAPIIcons.puppyMascot,
                        title: "No Dog Added Yet",
                        message: "Add your furry friend to start tracking their training progress."
                    )
                    .padding(.top, 100)
                }
            }
        }
        .background(AppColors.background)
        .navigationBarHidden(true)
    }

    @ViewBuilder
    private var noTrainingDataCard: some View {
        VStack(spacing: AppSpacing.md) {
            PiAPIIcon(name: PiAPIIcons.target, size: 56)

            VStack(spacing: AppSpacing.xxs) {
                Text("No Training Data Yet")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(AppColors.textPrimary)

                Text("Complete some training sessions to see your achievements here.")
                    .font(.system(size: 14))
                    .foregroundStyle(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(24)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 3, y: 1)
    }

    @ViewBuilder
    private func dogHeader(_ dog: Dog) -> some View {
        HStack(spacing: 16) {
            DogAvatar(
                name: dog.name,
                breed: dog.breed,
                imageData: dog.photoData,
                size: 64
            )

            VStack(alignment: .leading, spacing: 4) {
                Text(dog.name)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(AppColors.textPrimary)

                Text("\(dog.breed ?? "Dog") • \(dog.ageDescription)")
                    .font(.system(size: 14))
                    .foregroundStyle(AppColors.textSecondary)
            }

            Spacer()
        }
        .padding(.horizontal, 24)
        .padding(.top, 16)
        .padding(.bottom, 24)
        .background(.white)
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(Color(red: 0.92, green: 0.92, blue: 0.92))
                .frame(height: 1)
        }
    }

    @ViewBuilder
    private var weeklyActivityChart: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Weekly Activity")
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(AppColors.textPrimary)

            HStack(alignment: .bottom, spacing: 12) {
                ForEach(weeklyData) { day in
                    VStack(spacing: 8) {
                        // Bar container
                        ZStack(alignment: .bottom) {
                            RoundedRectangle(cornerRadius: 6)
                                .fill(Color(red: 0.94, green: 0.94, blue: 0.94))
                                .frame(height: 140)

                            RoundedRectangle(cornerRadius: 6)
                                .fill(AppColors.primary)
                                .frame(height: max(8, 140 * day.percentage))
                        }
                        .frame(maxWidth: .infinity)

                        // Day label
                        Text(day.day)
                            .font(.system(size: 11, weight: .medium))
                            .foregroundStyle(AppColors.textSecondary)
                    }
                }
            }
        }
        .padding(20)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 3, y: 1)
    }

    @ViewBuilder
    private var achievementsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recent Achievements")
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(AppColors.textPrimary)

            VStack(spacing: 12) {
                achievementRow(
                    iconName: PiAPIIcons.trophy,
                    title: "Week Warrior",
                    description: "Trained 7 days straight"
                )

                achievementRow(
                    iconName: PiAPIIcons.star,
                    title: "Command Master",
                    description: "Mastered \"Sit\" command"
                )

                achievementRow(
                    iconName: PiAPIIcons.target,
                    title: "Perfect Session",
                    description: "100% success rate today"
                )
            }
        }
        .padding(20)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 3, y: 1)
    }

    @ViewBuilder
    private func achievementRow(
        iconName: String,
        title: String,
        description: String
    ) -> some View {
        HStack(spacing: 12) {
            // PiAPI 3D icons already have a white background baked in
            PiAPIIcon(name: iconName, size: 44)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(AppColors.textPrimary)

                Text(description)
                    .font(.system(size: 13))
                    .foregroundStyle(AppColors.textSecondary)
            }

            Spacer()
        }
    }
}

struct DayActivity: Identifiable {
    let id = UUID()
    let day: String
    let percentage: Double
}

#Preview {
    ProgressDashboardView()
        .modelContainer(for: [Dog.self, TrainingSession.self], inMemory: true)
}
