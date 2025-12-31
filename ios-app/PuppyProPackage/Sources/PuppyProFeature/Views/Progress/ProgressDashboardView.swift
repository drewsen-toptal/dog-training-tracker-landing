import SwiftUI
import SwiftData

struct ProgressDashboardView: View {
    @Query private var dogs: [Dog]
    @Query(sort: \TrainingSession.startTime, order: .reverse) private var sessions: [TrainingSession]
    @State private var animateProgress = false

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
            let isToday = calendar.isDateInToday(date)

            return DayActivity(day: dayName, percentage: percentage, isToday: isToday)
        }
    }

    private var successRate: Int {
        let totalReps = sessions.reduce(0) { $0 + $1.totalReps }
        let successReps = sessions.reduce(0) { $0 + $1.successCount }
        guard totalReps > 0 else { return 0 }
        return Int(Double(successReps) / Double(totalReps) * 100)
    }

    private var todaySuccessRate: Int {
        let calendar = Calendar.current
        let todaySessions = sessions.filter { calendar.isDateInToday($0.startTime) }
        let totalReps = todaySessions.reduce(0) { $0 + $1.totalReps }
        let successReps = todaySessions.reduce(0) { $0 + $1.successCount }
        guard totalReps > 0 else { return 0 }
        return Int(Double(successReps) / Double(totalReps) * 100)
    }

    private var hadPerfectSessionToday: Bool {
        let calendar = Calendar.current
        let todaySessions = sessions.filter { calendar.isDateInToday($0.startTime) }
        // Check if any session today had 100% success rate
        return todaySessions.contains { session in
            session.totalReps > 0 && session.successCount == session.totalReps
        }
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

    private var totalSessions: Int {
        sessions.count
    }

    private var commandsMastered: Int {
        guard let dog = currentDog else { return 0 }
        return dog.commandProgress?.filter { $0.status == .mastered }.count ?? 0
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Dog profile header or empty state
                if let dog = currentDog {
                    // Premium gradient header
                    premiumHeader(dog)

                    // Stats ring cards
                    statsRingSection
                        .padding(.horizontal, 20)
                        .padding(.top, -40)

                    // Weekly activity chart
                    weeklyActivityChart
                        .padding(.horizontal, 20)
                        .padding(.top, 24)

                    // Recent achievements or empty state
                    if sessions.isEmpty {
                        noTrainingDataCard
                            .padding(.horizontal, 20)
                            .padding(.top, 24)
                            .padding(.bottom, 100)
                    } else {
                        achievementsSection
                            .padding(.horizontal, 20)
                            .padding(.top, 24)
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
        .background(Color(red: 0.97, green: 0.97, blue: 0.98))
        .navigationBarHidden(true)
        .onAppear {
            withAnimation(.easeOut(duration: 1.0).delay(0.3)) {
                animateProgress = true
            }
        }
    }

    /// Motivational message based on training performance
    private var motivationalMessage: String {
        if currentStreak >= 7 {
            return "Amazing dedication! Keep the streak alive!"
        } else if currentStreak >= 3 {
            return "\(currentStreak) day streak! You're on fire!"
        } else if todaySuccessRate >= 90 {
            return "Incredible performance today!"
        } else if todaySuccessRate >= 70 {
            return "Great progress! Keep training!"
        } else if sessions.isEmpty {
            return "Start your training journey today!"
        } else {
            return "Every session counts. Let's train!"
        }
    }

    /// Today's training summary for header
    private var todaySessionCount: Int {
        let calendar = Calendar.current
        return sessions.filter { calendar.isDateInToday($0.startTime) }.count
    }

    private var todayReps: Int {
        let calendar = Calendar.current
        return sessions.filter { calendar.isDateInToday($0.startTime) }.reduce(0) { $0 + $1.totalReps }
    }

    @ViewBuilder
    private func premiumHeader(_ dog: Dog) -> some View {
        ZStack(alignment: .bottom) {
            // Gradient background with more depth
            LinearGradient(
                colors: [
                    AppColors.primary,
                    AppColors.primary.opacity(0.85),
                    Color(red: 0.15, green: 0.55, blue: 0.55)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .frame(height: 280)

            // Enhanced pattern overlay - multiple decorative elements
            Circle()
                .fill(.white.opacity(0.06))
                .frame(width: 350, height: 350)
                .offset(x: 150, y: -120)

            Circle()
                .fill(.white.opacity(0.04))
                .frame(width: 250, height: 250)
                .offset(x: -140, y: -50)

            Circle()
                .fill(.white.opacity(0.03))
                .frame(width: 180, height: 180)
                .offset(x: 80, y: 100)

            // Subtle diagonal lines pattern
            GeometryReader { geo in
                Path { path in
                    let maxX = Int(geo.size.width) + 100
                    for i in stride(from: -100, to: maxX, by: 40) {
                        path.move(to: CGPoint(x: CGFloat(i), y: 0))
                        path.addLine(to: CGPoint(x: CGFloat(i + 150), y: geo.size.height))
                    }
                }
                .stroke(.white.opacity(0.02), lineWidth: 1)
            }
            .frame(height: 280)

            // Content
            VStack(spacing: 0) {
                // Top title bar
                HStack {
                    Text("Progress")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(.white.opacity(0.9))

                    Spacer()

                    // Streak badge (if active)
                    if currentStreak > 0 {
                        HStack(spacing: 4) {
                            Image(systemName: "flame.fill")
                                .font(.system(size: 12, weight: .semibold))
                            Text("\(currentStreak)")
                                .font(.system(size: 13, weight: .bold))
                        }
                        .foregroundStyle(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(.white.opacity(0.2))
                        .clipShape(Capsule())
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 60)

                Spacer()

                // Dog avatar with animated ring
                ZStack {
                    // Outer glow ring
                    Circle()
                        .stroke(
                            LinearGradient(
                                colors: [.white.opacity(0.4), .white.opacity(0.1)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 3
                        )
                        .frame(width: 96, height: 96)

                    // Progress ring showing today's success rate
                    Circle()
                        .trim(from: 0, to: animateProgress ? Double(todaySuccessRate) / 100.0 : 0)
                        .stroke(
                            LinearGradient(
                                colors: [.white, .white.opacity(0.7)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            style: StrokeStyle(lineWidth: 3, lineCap: .round)
                        )
                        .frame(width: 96, height: 96)
                        .rotationEffect(.degrees(-90))

                    DogAvatar(
                        name: dog.name,
                        breed: dog.breed,
                        imageData: dog.photoData,
                        size: 80
                    )
                    .shadow(color: .black.opacity(0.25), radius: 12, y: 6)
                }

                VStack(spacing: 6) {
                    Text(dog.name)
                        .font(.system(size: 28, weight: .bold))
                        .foregroundStyle(.white)

                    Text(motivationalMessage)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(.white.opacity(0.85))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
                .padding(.top, 12)

                // Today's quick stats ribbon
                HStack(spacing: 0) {
                    todayStatItem(value: "\(todaySessionCount)", label: "Sessions")

                    Rectangle()
                        .fill(.white.opacity(0.2))
                        .frame(width: 1, height: 30)

                    todayStatItem(value: "\(todayReps)", label: "Reps")

                    Rectangle()
                        .fill(.white.opacity(0.2))
                        .frame(width: 1, height: 30)

                    todayStatItem(value: "\(todaySuccessRate)%", label: "Accuracy")
                }
                .padding(.vertical, 12)
                .padding(.horizontal, 20)
                .background(.white.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 60)
            }
        }
    }

    @ViewBuilder
    private func todayStatItem(value: String, label: String) -> some View {
        VStack(spacing: 2) {
            Text(value)
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(.white)

            Text(label)
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(.white.opacity(0.7))
                .textCase(.uppercase)
        }
        .frame(maxWidth: .infinity)
    }

    @ViewBuilder
    private var statsRingSection: some View {
        HStack(spacing: 12) {
            // Success Rate Ring
            PremiumStatRing(
                value: Double(successRate),
                maxValue: 100,
                title: "Success",
                valueText: "\(successRate)%",
                color: AppColors.success,
                iconName: PiAPIIcons.checkmark,
                animate: animateProgress
            )

            // Streak Ring
            PremiumStatRing(
                value: Double(currentStreak),
                maxValue: 7,
                title: "Streak",
                valueText: "\(currentStreak)",
                subtitle: currentStreak == 1 ? "day" : "days",
                color: Color.orange,
                iconName: PiAPIIcons.fireStreak,
                animate: animateProgress
            )

            // Sessions Ring
            PremiumStatRing(
                value: Double(min(totalSessions, 30)),
                maxValue: 30,
                title: "Sessions",
                valueText: "\(totalSessions)",
                subtitle: "total",
                color: AppColors.primary,
                iconName: PiAPIIcons.target,
                animate: animateProgress
            )
        }
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
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.06), radius: 12, y: 4)
    }

    @ViewBuilder
    private var weeklyActivityChart: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Text("Weekly Activity")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(AppColors.textPrimary)

                Spacer()

                Text("This Week")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(AppColors.textSecondary)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Color(red: 0.95, green: 0.95, blue: 0.97))
                    .clipShape(Capsule())
            }

            HStack(alignment: .bottom, spacing: 8) {
                ForEach(weeklyData) { day in
                    VStack(spacing: 8) {
                        // Bar container
                        ZStack(alignment: .bottom) {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            Color(red: 0.95, green: 0.95, blue: 0.97),
                                            Color(red: 0.92, green: 0.92, blue: 0.95)
                                        ],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                                .frame(height: 120)

                            RoundedRectangle(cornerRadius: 8)
                                .fill(
                                    LinearGradient(
                                        colors: day.isToday ? [
                                            AppColors.primary,
                                            AppColors.primary.opacity(0.7)
                                        ] : [
                                            AppColors.primary.opacity(0.6),
                                            AppColors.primary.opacity(0.4)
                                        ],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                                .frame(height: animateProgress ? max(8, 120 * day.percentage) : 8)
                                .animation(.spring(response: 0.8, dampingFraction: 0.7).delay(Double(weeklyData.firstIndex(where: { $0.id == day.id }) ?? 0) * 0.1), value: animateProgress)
                        }
                        .frame(maxWidth: .infinity)

                        // Day label
                        Text(day.day)
                            .font(.system(size: 11, weight: day.isToday ? .bold : .medium))
                            .foregroundStyle(day.isToday ? AppColors.primary : AppColors.textSecondary)
                    }
                }
            }
        }
        .padding(20)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.06), radius: 12, y: 4)
    }

    @ViewBuilder
    private var achievementsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Achievements")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(AppColors.textPrimary)

                Spacer()

                Text("\(getUnlockedAchievementsCount())/3")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(AppColors.primary)
            }

            VStack(spacing: 0) {
                PremiumAchievementRow(
                    iconName: PiAPIIcons.trophy,
                    title: "Week Warrior",
                    description: "Trained 7 days straight",
                    isUnlocked: currentStreak >= 7,
                    accentColor: Color.orange
                )

                Divider()
                    .padding(.leading, 60)

                PremiumAchievementRow(
                    iconName: PiAPIIcons.star,
                    title: "Command Master",
                    description: "Mastered \"Sit\" command",
                    isUnlocked: commandsMastered > 0,
                    accentColor: Color.yellow
                )

                Divider()
                    .padding(.leading, 60)

                PremiumAchievementRow(
                    iconName: PiAPIIcons.target,
                    title: "Perfect Session",
                    description: "100% success rate in a session",
                    isUnlocked: hadPerfectSessionToday,
                    accentColor: AppColors.success
                )
            }
        }
        .padding(20)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.06), radius: 12, y: 4)
    }

    private func getUnlockedAchievementsCount() -> Int {
        var count = 0
        if currentStreak >= 7 { count += 1 }
        if commandsMastered > 0 { count += 1 }
        if hadPerfectSessionToday { count += 1 }
        return count
    }
}

// MARK: - Premium Stat Ring Component

struct PremiumStatRing: View {
    let value: Double
    let maxValue: Double
    let title: String
    let valueText: String
    var subtitle: String? = nil
    let color: Color
    let iconName: String
    let animate: Bool

    private var progress: Double {
        min(value / maxValue, 1.0)
    }

    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                // Background ring
                Circle()
                    .stroke(color.opacity(0.15), lineWidth: 6)
                    .frame(width: 70, height: 70)

                // Progress ring
                Circle()
                    .trim(from: 0, to: animate ? progress : 0)
                    .stroke(
                        AngularGradient(
                            colors: [color, color.opacity(0.7), color],
                            center: .center,
                            startAngle: .degrees(0),
                            endAngle: .degrees(360)
                        ),
                        style: StrokeStyle(lineWidth: 6, lineCap: .round)
                    )
                    .frame(width: 70, height: 70)
                    .rotationEffect(.degrees(-90))
                    .animation(.spring(response: 1.0, dampingFraction: 0.7), value: animate)

                // Icon
                PiAPIIcon(name: iconName, size: 32)
            }

            VStack(spacing: 2) {
                Text(valueText)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(AppColors.textPrimary)

                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.system(size: 11, weight: .medium))
                        .foregroundStyle(AppColors.textSecondary)
                } else {
                    Text(title)
                        .font(.system(size: 11, weight: .medium))
                        .foregroundStyle(AppColors.textSecondary)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.06), radius: 12, y: 4)
    }
}

// MARK: - Premium Achievement Row

struct PremiumAchievementRow: View {
    let iconName: String
    let title: String
    let description: String
    let isUnlocked: Bool
    let accentColor: Color

    var body: some View {
        HStack(spacing: 14) {
            // Icon with glow effect
            ZStack {
                if isUnlocked {
                    Circle()
                        .fill(accentColor.opacity(0.15))
                        .frame(width: 48, height: 48)
                }

                PiAPIIcon(name: iconName, size: 40)
                    .opacity(isUnlocked ? 1.0 : 0.4)
                    .saturation(isUnlocked ? 1.0 : 0.0)
            }

            VStack(alignment: .leading, spacing: 3) {
                HStack(spacing: 6) {
                    Text(title)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(isUnlocked ? AppColors.textPrimary : AppColors.textSecondary)

                    if isUnlocked {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 14))
                            .foregroundStyle(AppColors.success)
                    }
                }

                Text(description)
                    .font(.system(size: 13))
                    .foregroundStyle(AppColors.textSecondary)
            }

            Spacer()

            if !isUnlocked {
                Image(systemName: "lock.fill")
                    .font(.system(size: 12))
                    .foregroundStyle(AppColors.textSecondary.opacity(0.5))
            }
        }
        .padding(.vertical, 14)
    }
}

struct DayActivity: Identifiable {
    let id = UUID()
    let day: String
    let percentage: Double
    var isToday: Bool = false
}

#Preview {
    ProgressDashboardView()
        .modelContainer(for: [Dog.self, TrainingSession.self], inMemory: true)
}
