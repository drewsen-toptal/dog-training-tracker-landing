import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var dogs: [Dog]
    @Query(sort: \TrainingSession.startTime, order: .reverse) private var sessions: [TrainingSession]
    @Query private var userSettings: [UserSettings]
    @Query private var allCommandProgress: [CommandProgress]

    @State private var showingTrainingSheet = false
    @State private var showingAddDogSheet = false

    private var currentDog: Dog? {
        dogs.first
    }

    private func getProgress(for command: Command) -> CommandProgress? {
        guard let dog = currentDog else { return nil }
        return dog.commandProgress?.first { $0.commandId == command.id }
    }

    private var settings: UserSettings? {
        userSettings.first
    }

    private var todaysSessions: [TrainingSession] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        return sessions.filter { session in
            calendar.isDate(session.startTime, inSameDayAs: today)
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

    private var dailyGoal: Int {
        settings?.dailyGoal ?? 3
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Header with greeting and streak
                headerSection

                // Today's Goal Card
                todaysGoalCard
                    .padding(.horizontal, AppSpacing.lg)
                    .padding(.bottom, AppSpacing.lg)

                // Due for Review Section
                dueForReviewSection

                // Quick Actions
                quickActionsSection
                    .padding(.horizontal, AppSpacing.lg)
                    .padding(.bottom, AppSpacing.xl)

                // Weekly Progress
                weeklyProgressSection
                    .padding(.horizontal, AppSpacing.lg)
                    .padding(.bottom, 100)
            }
        }
        .background(AppColors.background)
        .navigationBarHidden(true)
        .sheet(isPresented: $showingTrainingSheet) {
            if let dog = currentDog {
                TrainingSessionView(dog: dog)
            }
        }
        .sheet(isPresented: $showingAddDogSheet) {
            AddDogView()
        }
    }

    // MARK: - Header Section
    @ViewBuilder
    private var headerSection: some View {
        VStack(spacing: AppSpacing.lg) {
            HStack {
                // Dog avatar and greeting
                HStack(spacing: 14) {
                    if let dog = currentDog {
                        DogAvatar(
                            name: dog.name,
                            breed: dog.breed,
                            imageData: dog.photoData,
                            size: 52
                        )
                    } else {
                        Circle()
                            .fill(AppColors.primaryGradient)
                            .frame(width: 52, height: 52)
                            .overlay {
                                Text("🐕")
                                    .font(.system(size: 26))
                            }
                    }

                    VStack(alignment: .leading, spacing: 2) {
                        Text("Hi \(currentDog?.name ?? "there")!")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundStyle(AppColors.textPrimary)

                        HStack(spacing: 4) {
                            if todaysSessions.count >= dailyGoal {
                                Text("Great job! Goal achieved!")
                                    .font(.system(size: 14))
                                    .foregroundStyle(AppColors.success)
                                    .fontWeight(.medium)
                                Image(systemName: "checkmark.seal.fill")
                                    .font(.system(size: 12))
                                    .foregroundStyle(AppColors.success)
                            } else {
                                Text("Ready for today's training?")
                                    .font(.system(size: 14))
                                    .foregroundStyle(AppColors.textSecondary)
                            }
                        }
                    }
                }

                Spacer()

                // Add dog button - PiAPI 3D icons already have a white background baked in
                Button {
                    showingAddDogSheet = true
                } label: {
                    PiAPIIcon(name: PiAPIIcons.plus, size: 36)
                }
                .accessibilityLabel("Add Dog")
                .accessibilityHint("Double-tap to add a new dog to your profile")

                // Streak badge
                HStack(spacing: 6) {
                    PiAPIIcon(name: PiAPIIcons.fireStreak, size: 18)

                    Text("\(currentStreak)")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(Color(red: 0.65, green: 0.55, blue: 0.2))
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(AppColors.warning.opacity(0.12))
                .clipShape(Capsule())
                .accessibilityElement(children: .combine)
                .accessibilityLabel("\(currentStreak) day streak")
            }
        }
        .padding(.horizontal, AppSpacing.lg)
        .padding(.top, AppSpacing.lg)
        .padding(.bottom, AppSpacing.lg)
        .background(.white)
    }

    // MARK: - Today's Goal Card
    @ViewBuilder
    private var todaysGoalCard: some View {
        let completedSessions = todaysSessions.count
        let progress = min(Double(completedSessions) / Double(dailyGoal), 1.0)
        let goalAchieved = completedSessions >= dailyGoal

        HStack(spacing: AppSpacing.lg) {
            VStack(alignment: .leading, spacing: AppSpacing.md) {
                HStack(spacing: 6) {
                    if goalAchieved {
                        Image(systemName: "trophy.fill")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(Color(red: 1.0, green: 0.85, blue: 0.3))
                    }
                    Text(goalAchieved ? "GOAL ACHIEVED" : "TODAY'S GOAL")
                        .font(.system(size: 12, weight: .semibold))
                        .tracking(0.5)
                        .foregroundStyle(.white.opacity(0.85))
                }

                Text(goalAchieved ? "Amazing work today!" : "Complete \(dailyGoal) training sessions")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(.white)

                HStack(spacing: 12) {
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            Capsule()
                                .fill(.white.opacity(0.3))
                                .frame(height: 8)

                            Capsule()
                                .fill(goalAchieved ? Color(red: 1.0, green: 0.85, blue: 0.3) : .white)
                                .frame(width: geometry.size.width * progress, height: 8)
                        }
                    }
                    .frame(height: 8)

                    Text("\(completedSessions)/\(dailyGoal)")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(goalAchieved ? Color(red: 1.0, green: 0.85, blue: 0.3) : .white)
                }
            }

            Spacer()

            // Trophy/target icon on the right
            if goalAchieved {
                // Random celebration animation for variety
                LottieView.randomCelebration(size: 70)
            } else {
                ZStack {
                    Circle()
                        .fill(.white.opacity(0.1))
                        .frame(width: 56, height: 56)
                    Image(systemName: "target")
                        .font(.system(size: 24, weight: .medium))
                        .foregroundStyle(.white.opacity(0.7))
                }
            }
        }
        .padding(AppSpacing.lg)
        .background(
            LinearGradient(
                colors: goalAchieved ? [
                    Color(red: 0.2, green: 0.6, blue: 0.3),
                    Color(red: 0.15, green: 0.5, blue: 0.25)
                ] : [
                    Color(red: 0.188, green: 0.557, blue: 0.545),
                    Color(red: 0.15, green: 0.45, blue: 0.5)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.xl))
        .overlay(alignment: .topTrailing) {
            if goalAchieved {
                // Celebration sparkles
                GoalAchievedSparkles()
                    .frame(width: 100, height: 100)
                    .offset(x: 10, y: -10)
            } else {
                Circle()
                    .fill(.white.opacity(0.08))
                    .frame(width: 120, height: 120)
                    .offset(x: 40, y: -40)
            }
        }
        .clipped()
    }

    // MARK: - Due for Review Section
    @ViewBuilder
    private var dueForReviewSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("Due for Review")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(AppColors.textPrimary)

                Spacer()

                NavigationLink {
                    CommandListView()
                } label: {
                    Text("See All")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(AppColors.primary)
                }
                .accessibilityLabel("See all commands")
                .accessibilityHint("Double-tap to view all training commands")
            }
            .padding(.horizontal, AppSpacing.lg)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(Command.allCommands.prefix(3)) { command in
                        NavigationLink {
                            CommandDetailView(command: command)
                        } label: {
                            DueReviewCard(
                                command: command,
                                dueStatus: getDueStatus(for: command),
                                progress: getProgress(for: command)
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, AppSpacing.lg)
                .padding(.bottom, AppSpacing.md)
            }
        }
        .padding(.bottom, AppSpacing.xl)
    }

    private func getDueStatus(for command: Command) -> DueStatus {
        guard let progress = getProgress(for: command) else {
            return .notStarted
        }

        guard let nextReview = progress.nextReviewDate else {
            return progress.status == .notStarted ? .notStarted : .soon(hours: 24)
        }

        let hoursUntilDue = Calendar.current.dateComponents([.hour], from: Date(), to: nextReview).hour ?? 0

        if hoursUntilDue <= 0 {
            return .urgent
        } else if hoursUntilDue <= 6 {
            return .soon(hours: hoursUntilDue)
        } else {
            return .soon(hours: hoursUntilDue)
        }
    }

    // MARK: - Quick Actions Section
    @ViewBuilder
    private var quickActionsSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Quick Actions")
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(AppColors.textPrimary)

            HStack(spacing: 12) {
                // Clicker Button
                NavigationLink {
                    ClickerView()
                } label: {
                    QuickActionCard(
                        title: "Clicker",
                        iconName: PiAPIIcons.clicker
                    )
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Open Clicker")
                .accessibilityHint("Double-tap to open the training clicker tool")

                // Random Command Button
                Button {
                    showingTrainingSheet = true
                } label: {
                    QuickActionCard(
                        title: "Random",
                        iconName: PiAPIIcons.random
                    )
                }
                .buttonStyle(.plain)
                .disabled(currentDog == nil)
                .accessibilityLabel("Random Command Training")
                .accessibilityHint("Double-tap to start training a random command")
            }
        }
    }

    // MARK: - Weekly Progress Section
    @ViewBuilder
    private var weeklyProgressSection: some View {
        let weekData = getWeeklyData()
        let daysWithTraining = weekData.filter { $0.hasSession }.count

        VStack(alignment: .leading, spacing: 18) {
            HStack {
                Text("This Week")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(AppColors.textPrimary)

                Spacer()

                HStack(spacing: 4) {
                    Text("\(daysWithTraining)")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(AppColors.primary)
                    Text("of 7 days trained")
                        .font(.system(size: 14))
                        .foregroundStyle(AppColors.textSecondary)
                }
            }

            HStack(spacing: 0) {
                ForEach(weekData) { day in
                    WeekDayCircle(day: day)
                        .frame(maxWidth: .infinity)
                }
            }
        }
        .padding(AppSpacing.lg)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .shadow(color: .black.opacity(0.06), radius: 12, y: 2)
    }

    private func getWeeklyData() -> [WeekDay] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        // Get start of week (Sunday)
        let weekday = calendar.component(.weekday, from: today)
        guard let startOfWeek = calendar.date(byAdding: .day, value: -(weekday - 1), to: today) else {
            return []
        }

        return (0..<7).compactMap { dayOffset -> WeekDay? in
            guard let date = calendar.date(byAdding: .day, value: dayOffset, to: startOfWeek) else {
                return nil
            }

            let dayNumber = calendar.component(.day, from: date)
            let isToday = calendar.isDateInToday(date)
            let hasSession = sessions.contains { session in
                calendar.isDate(session.startTime, inSameDayAs: date)
            }

            let dayFormatter = DateFormatter()
            dayFormatter.dateFormat = "EEE"
            let dayName = String(dayFormatter.string(from: date).prefix(3))

            return WeekDay(
                dayName: dayName,
                dayNumber: dayNumber,
                isToday: isToday,
                hasSession: hasSession
            )
        }
    }
}

// MARK: - Supporting Types

enum DueStatus {
    case notStarted
    case urgent
    case soon(hours: Int)

    var text: String {
        switch self {
        case .notStarted: return "Not started"
        case .urgent: return "Due now"
        case .soon(let hours):
            if hours <= 0 { return "Due now" }
            let days = hours / 24
            if days > 365 { return "Due in 1y+" }
            if days > 30 { return "Due in \(days / 30)mo" }
            if hours >= 24 { return "Due in \(days)d" }
            return "Due in \(hours)h"
        }
    }

    var isUrgent: Bool {
        switch self {
        case .urgent: return true
        case .notStarted, .soon: return false
        }
    }

    var isNotStarted: Bool {
        switch self {
        case .notStarted: return true
        default: return false
        }
    }
}

struct WeekDay: Identifiable {
    let id = UUID()
    let dayName: String
    let dayNumber: Int
    let isToday: Bool
    let hasSession: Bool
}

// MARK: - Due Review Card

struct DueReviewCard: View {
    let command: Command
    let dueStatus: DueStatus
    let progress: CommandProgress?

    private var lastPracticedText: String {
        guard let progress = progress else { return "Not started yet" }
        return "Last practiced \(progress.daysSinceLastPracticeDescription.lowercased())"
    }

    private var progressPercentage: Double {
        guard let progress = progress else { return 0 }
        return progress.successRate
    }

    private var progressText: String {
        guard let progress = progress, progress.practiceCount > 0 else { return "0%" }
        return "\(progress.successRatePercentage)%"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 14) {
                // PiAPI 3D icons already have a white background baked in
                PiAPIIcon(name: command.piAPIIconName, size: 48)

                VStack(alignment: .leading, spacing: 2) {
                    Text(command.name)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(AppColors.textPrimary)

                    Text(lastPracticedText)
                        .font(.system(size: 13))
                        .foregroundStyle(AppColors.textSecondary)
                }
            }

            HStack {
                // Due badge
                Text(dueStatus.text)
                    .font(.system(size: 12, weight: .semibold))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        dueStatus.isNotStarted
                            ? AppColors.textTertiary.opacity(0.15)
                            : dueStatus.isUrgent
                                ? Color.red.opacity(0.1)
                                : AppColors.warning.opacity(0.15)
                    )
                    .foregroundStyle(
                        dueStatus.isNotStarted
                            ? AppColors.textSecondary
                            : dueStatus.isUrgent
                                ? Color.red
                                : Color(red: 0.6, green: 0.55, blue: 0.2)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 8))

                Spacer()

                // Progress indicator
                HStack(spacing: 8) {
                    ProgressView(value: progressPercentage)
                        .progressViewStyle(.linear)
                        .frame(width: 60)
                        .tint(progressPercentage > 0 ? AppColors.primary : AppColors.textTertiary)

                    Text(progressText)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(AppColors.textTertiary)
                }
            }
        }
        .padding(18)
        .frame(width: 280)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .shadow(color: .black.opacity(0.06), radius: 12, y: 2)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(command.name) command, \(dueStatus.text), \(progressText) progress")
        .accessibilityHint("Double-tap to view command details and train")
    }
}

// MARK: - Quick Action Card

struct QuickActionCard: View {
    let title: String
    let iconName: String

    var body: some View {
        HStack(spacing: 14) {
            // PiAPI 3D icons already have a white background baked in
            PiAPIIcon(name: iconName, size: 44)

            Text(title)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(AppColors.textPrimary)
                .lineLimit(1)
                .minimumScaleFactor(0.8)

            Spacer()
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 18)
        .frame(maxWidth: .infinity)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 8, y: 2)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(title)
    }
}

// MARK: - Week Day Circle

struct WeekDayCircle: View {
    let day: WeekDay

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                if day.isToday {
                    Circle()
                        .fill(AppColors.primary)
                        .frame(width: 36, height: 36)
                        .shadow(color: AppColors.primary.opacity(0.4), radius: 8, y: 2)

                    Text("\(day.dayNumber)")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundStyle(.white)
                } else if day.hasSession {
                    Circle()
                        .fill(AppColors.success)
                        .frame(width: 36, height: 36)

                    Image(systemName: "checkmark")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(.white)
                } else {
                    Circle()
                        .fill(Color(red: 0.94, green: 0.94, blue: 0.94))
                        .frame(width: 36, height: 36)
                }
            }

            Text(day.dayName.uppercased())
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(AppColors.textSecondary)
        }
    }
}

// MARK: - Goal Achieved Sparkles

struct GoalAchievedSparkles: View {
    @State private var isAnimating = false

    private let sparklePositions: [(x: CGFloat, y: CGFloat, delay: Double)] = [
        (0.2, 0.3, 0.0),
        (0.8, 0.2, 0.1),
        (0.5, 0.6, 0.2),
        (0.7, 0.8, 0.15),
        (0.3, 0.7, 0.25),
    ]

    var body: some View {
        GeometryReader { geometry in
            ForEach(0..<sparklePositions.count, id: \.self) { index in
                let pos = sparklePositions[index]
                Image(systemName: "sparkle")
                    .font(.system(size: CGFloat.random(in: 8...14)))
                    .foregroundStyle(Color(red: 1.0, green: 0.85, blue: 0.3))
                    .opacity(isAnimating ? 1 : 0)
                    .scaleEffect(isAnimating ? 1 : 0.3)
                    .position(
                        x: geometry.size.width * pos.x,
                        y: geometry.size.height * pos.y
                    )
                    .animation(
                        .easeInOut(duration: 0.8)
                            .repeatForever(autoreverses: true)
                            .delay(pos.delay),
                        value: isAnimating
                    )
            }
        }
        .onAppear {
            isAnimating = true
        }
    }
}

#Preview {
    HomeView()
        .modelContainer(for: [Dog.self, TrainingSession.self, CommandProgress.self], inMemory: true)
}
