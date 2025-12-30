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

        return (0..<7).reversed().map { daysAgo in
            guard let date = calendar.date(byAdding: .day, value: -daysAgo, to: today) else {
                return DayActivity(day: "?", percentage: 0)
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
        NavigationStack {
            ScrollView {
                VStack(spacing: AppSpacing.lg) {
                    // Dog profile header
                    if let dog = currentDog {
                        dogHeader(dog)
                    }

                    // Stats cards
                    statsCards

                    // Weekly activity chart
                    weeklyActivityChart

                    // Recent achievements
                    achievementsSection
                }
                .padding(.horizontal, AppSpacing.lg)
                .padding(.bottom, 100)
            }
            .background(AppColors.background)
            .navigationTitle("Progress")
        }
    }

    @ViewBuilder
    private func dogHeader(_ dog: Dog) -> some View {
        HStack(spacing: AppSpacing.md) {
            DogAvatar(
                name: dog.name,
                imageData: dog.photoData,
                size: 64
            )

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
        .padding(AppSpacing.lg)
        .background(.white)
        .clipShape(.rect(cornerRadius: AppRadius.lg))
        .shadow(color: .black.opacity(0.04), radius: 8, y: 2)
    }

    @ViewBuilder
    private var statsCards: some View {
        HStack(spacing: AppSpacing.md) {
            StatCard(
                title: "Success Rate",
                value: "\(successRate)%",
                iconSystemName: "checkmark.circle.fill",
                valueColor: AppColors.success
            )

            StatCard(
                title: "Day Streak",
                value: "\(currentStreak)",
                iconSystemName: "flame.fill",
                valueColor: AppColors.warning
            )
        }
    }

    @ViewBuilder
    private var weeklyActivityChart: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text("Weekly Activity")
                .font(AppFonts.headline())
                .foregroundStyle(AppColors.textPrimary)

            HStack(alignment: .bottom, spacing: AppSpacing.xs) {
                ForEach(weeklyData) { day in
                    VStack(spacing: AppSpacing.xs) {
                        // Bar
                        ZStack(alignment: .bottom) {
                            RoundedRectangle(cornerRadius: AppRadius.xs)
                                .fill(AppColors.background)
                                .frame(height: 140)

                            RoundedRectangle(cornerRadius: AppRadius.xs)
                                .fill(AppColors.primary)
                                .frame(height: max(8, 140 * day.percentage))
                        }
                        .frame(maxWidth: .infinity)

                        // Day label
                        Text(day.day)
                            .font(.caption2)
                            .fontWeight(.medium)
                            .foregroundStyle(AppColors.textSecondary)
                    }
                }
            }
        }
        .padding(AppSpacing.lg)
        .background(.white)
        .clipShape(.rect(cornerRadius: AppRadius.lg))
        .shadow(color: .black.opacity(0.03), radius: 6, y: 2)
    }

    @ViewBuilder
    private var achievementsSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text("Recent Achievements")
                .font(AppFonts.headline())
                .foregroundStyle(AppColors.textPrimary)

            VStack(spacing: AppSpacing.sm) {
                achievementRow(
                    icon: "trophy.fill",
                    iconColor: AppColors.warning,
                    title: "Week Warrior",
                    description: "Trained 7 days straight"
                )

                achievementRow(
                    icon: "star.fill",
                    iconColor: AppColors.primary,
                    title: "Command Master",
                    description: "Mastered \"Sit\" command"
                )

                achievementRow(
                    icon: "target",
                    iconColor: AppColors.primary,
                    title: "Perfect Session",
                    description: "100% success rate today"
                )
            }
        }
        .padding(AppSpacing.lg)
        .background(.white)
        .clipShape(.rect(cornerRadius: AppRadius.lg))
        .shadow(color: .black.opacity(0.03), radius: 6, y: 2)
    }

    @ViewBuilder
    private func achievementRow(icon: String, iconColor: Color, title: String, description: String) -> some View {
        HStack(spacing: AppSpacing.sm) {
            ZStack {
                iconColor.opacity(0.12)
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundStyle(iconColor)
            }
            .frame(width: 44, height: 44)
            .clipShape(.rect(cornerRadius: AppRadius.sm))

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(AppFonts.headline())
                    .foregroundStyle(AppColors.textPrimary)

                Text(description)
                    .font(AppFonts.caption())
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
