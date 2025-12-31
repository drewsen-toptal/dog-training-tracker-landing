import SwiftUI
import SwiftData

struct SessionCompleteView: View {
    let session: TrainingSession
    let onDismiss: () -> Void

    @Query(sort: \TrainingSession.startTime, order: .reverse) private var allSessions: [TrainingSession]
    @State private var showConfetti = false

    /// Calculate the current streak based on consecutive training days
    private var currentStreak: Int {
        guard !allSessions.isEmpty else { return 0 }

        var streak = 0
        let calendar = Calendar.current
        var checkDate = calendar.startOfDay(for: Date())
        var checkedYesterday = false

        while true {
            let hasSessionOnDate = allSessions.contains { session in
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

    /// Get a command from this session for the "next review" card
    private var nextReviewCommand: Command? {
        session.commandsPracticed.first.flatMap { Command.command(for: $0) }
    }

    var body: some View {
        ZStack {
            // Gradient background
            LinearGradient(
                colors: [AppColors.primary, AppColors.primaryDark],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            // Confetti particles (decorative)
            if showConfetti {
                ConfettiView()
            }

            VStack(spacing: 0) {
                // Success content
                VStack(spacing: AppSpacing.lg) {
                    // Success badge with Lottie checkmark
                    ZStack {
                        Circle()
                            .fill(.white)
                            .frame(width: 100, height: 100)
                            .shadow(color: .black.opacity(0.2), radius: 20, y: 8)

                        if showConfetti {
                            LottieView.checkmark(size: 60)
                        }
                    }
                    .scaleEffect(showConfetti ? 1 : 0)
                    .animation(.spring(response: 0.6, dampingFraction: 0.5), value: showConfetti)

                    Text("Great Session!")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundStyle(.white)

                    if let dog = session.dog {
                        Text("\(dog.name) is making progress")
                            .font(AppFonts.body())
                            .foregroundStyle(.white.opacity(0.85))
                    }
                }
                .padding(.top, AppSpacing.xxxl)

                // Stats card
                VStack(spacing: AppSpacing.lg) {
                    // Stats grid
                    HStack(spacing: 0) {
                        statItem(
                            value: "\(session.successRatePercentage)%",
                            label: "Success Rate",
                            color: AppColors.success
                        )

                        statItem(
                            value: "\(session.totalReps)",
                            label: "Reps Total",
                            color: AppColors.primary
                        )

                        statItem(
                            value: session.formattedDuration,
                            label: "Duration",
                            color: AppColors.textPrimary
                        )
                    }

                    Divider()

                    // Commands practiced
                    VStack(spacing: AppSpacing.sm) {
                        ForEach(session.commandsPracticed.prefix(3), id: \.self) { commandId in
                            if let command = Command.command(for: commandId) {
                                commandResultRow(command: command)
                            }
                        }
                    }
                }
                .padding(AppSpacing.xl)
                .background(.white)
                .clipShape(.rect(cornerRadius: AppRadius.xl))
                .shadow(color: .black.opacity(0.15), radius: 20, y: 8)
                .padding(.horizontal, AppSpacing.xl)
                .padding(.top, AppSpacing.xxl)

                // Next review info
                nextReviewCard
                    .padding(.horizontal, AppSpacing.xl)
                    .padding(.top, AppSpacing.lg)

                // Streak update
                streakCard
                    .padding(.horizontal, AppSpacing.xl)
                    .padding(.top, AppSpacing.md)

                Spacer()

                // Bottom buttons
                VStack(spacing: AppSpacing.sm) {
                    Button {
                        onDismiss()
                    } label: {
                        Text("Done")
                            .font(AppFonts.headline())
                            .foregroundStyle(AppColors.primary)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(.white)
                            .clipShape(.rect(cornerRadius: AppRadius.xl))
                            .shadow(color: .black.opacity(0.15), radius: 12, y: 4)
                    }

                    Button("Train Another Session") {
                        // Would restart training
                        onDismiss()
                    }
                    .font(AppFonts.headline())
                    .foregroundStyle(.white.opacity(0.8))
                    .padding(.vertical, AppSpacing.md)
                }
                .padding(.horizontal, AppSpacing.xl)
                .padding(.bottom, AppSpacing.xxxl)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.5)) {
                showConfetti = true
            }
        }
    }

    @ViewBuilder
    private func statItem(value: String, label: String, color: Color) -> some View {
        VStack(spacing: AppSpacing.xs) {
            Text(value)
                .font(.system(size: 32, weight: .bold))
                .foregroundStyle(color)

            Text(label.uppercased())
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(AppColors.textSecondary)
                .tracking(0.3)
        }
        .frame(maxWidth: .infinity)
    }

    @ViewBuilder
    private func commandResultRow(command: Command) -> some View {
        HStack(spacing: AppSpacing.sm) {
            // Command icon
            ZStack {
                AppColors.success.opacity(0.12)
                PiAPIIcon(name: command.piAPIIconName, size: 28)
            }
            .frame(width: 44, height: 44)
            .clipShape(.rect(cornerRadius: AppRadius.sm))

            VStack(alignment: .leading, spacing: 2) {
                Text(command.name)
                    .font(AppFonts.headline())
                    .foregroundStyle(AppColors.textPrimary)

                Text("Practiced")
                    .font(AppFonts.caption())
                    .foregroundStyle(AppColors.textSecondary)
            }

            Spacer()

            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 20))
                .foregroundStyle(AppColors.success)
        }
    }

    @ViewBuilder
    private var nextReviewCard: some View {
        HStack(spacing: AppSpacing.sm) {
            ZStack {
                AppColors.primary.opacity(0.12)
                PiAPIIcon(name: PiAPIIcons.bolt, size: 24)
            }
            .frame(width: 44, height: 44)
            .clipShape(.rect(cornerRadius: AppRadius.sm))

            VStack(alignment: .leading, spacing: 2) {
                Text("Next Review: \(nextReviewCommand?.name ?? "Commands")")
                    .font(AppFonts.subheadline())
                    .fontWeight(.semibold)
                    .foregroundStyle(AppColors.textPrimary)

                Text("Practice again for best retention")
                    .font(AppFonts.caption())
                    .foregroundStyle(AppColors.textSecondary)
            }

            Spacer()
        }
        .padding(AppSpacing.md)
        .background(.white)
        .clipShape(.rect(cornerRadius: AppRadius.lg))
        .shadow(color: .black.opacity(0.1), radius: 10, y: 4)
    }

    @ViewBuilder
    private var streakCard: some View {
        HStack(spacing: AppSpacing.sm) {
            PiAPIIcon(name: PiAPIIcons.fireStreak, size: 32)

            VStack(alignment: .leading, spacing: 2) {
                if currentStreak > 0 {
                    Text("\(currentStreak) Day Streak!")
                        .font(AppFonts.headline())
                        .foregroundStyle(AppColors.textPrimary)

                    Text(currentStreak == 1 ? "Great start - train again tomorrow!" : "Keep it going - train again tomorrow")
                        .font(AppFonts.caption())
                        .foregroundStyle(AppColors.textSecondary)
                } else {
                    Text("Streak Started!")
                        .font(AppFonts.headline())
                        .foregroundStyle(AppColors.textPrimary)

                    Text("Train tomorrow to build your streak")
                        .font(AppFonts.caption())
                        .foregroundStyle(AppColors.textSecondary)
                }
            }

            Spacer()
        }
        .padding(AppSpacing.md)
        .background(AppColors.warning.opacity(0.15))
        .clipShape(.rect(cornerRadius: AppRadius.lg))
    }
}

// MARK: - Enhanced Celebration System

struct CelebrationView: View {
    @State private var particles: [CelebrationParticle] = []
    @State private var burstTriggered = false

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Continuous confetti rain
                ForEach(0..<30) { i in
                    ConfettiPiece(
                        shape: CelebrationShape.allCases[i % CelebrationShape.allCases.count],
                        color: celebrationColors[i % celebrationColors.count],
                        startX: CGFloat.random(in: 0...geometry.size.width),
                        delay: Double(i) * 0.1,
                        screenHeight: geometry.size.height
                    )
                }

                // Burst particles from center
                ForEach(particles) { particle in
                    BurstParticle(particle: particle)
                }
            }
        }
        .onAppear {
            triggerCelebration()
        }
    }

    private var celebrationColors: [Color] {
        [
            Color(red: 1.0, green: 0.84, blue: 0.0),   // Gold
            Color(red: 0.2, green: 0.8, blue: 0.4),    // Green
            Color(red: 1.0, green: 0.6, blue: 0.2),    // Orange
            Color(red: 0.4, green: 0.8, blue: 1.0),    // Sky blue
            Color(red: 1.0, green: 0.4, blue: 0.6),    // Pink
            .white
        ]
    }

    private func triggerCelebration() {
        // Haptic burst
        let impact = UIImpactFeedbackGenerator(style: .heavy)
        impact.impactOccurred()

        // Generate burst particles
        for i in 0..<40 {
            let angle = Double(i) * (360.0 / 40.0) + Double.random(in: -10...10)
            let velocity = CGFloat.random(in: 150...300)
            let particle = CelebrationParticle(
                id: i,
                color: celebrationColors[i % celebrationColors.count],
                shape: CelebrationShape.allCases[i % CelebrationShape.allCases.count],
                angle: angle,
                velocity: velocity,
                size: CGFloat.random(in: 8...16)
            )
            particles.append(particle)
        }

        // Secondary haptic
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            let notification = UINotificationFeedbackGenerator()
            notification.notificationOccurred(.success)
        }
    }
}

enum CelebrationShape: CaseIterable {
    case circle, star, rectangle, diamond
}

struct CelebrationParticle: Identifiable {
    let id: Int
    let color: Color
    let shape: CelebrationShape
    let angle: Double
    let velocity: CGFloat
    let size: CGFloat
}

struct BurstParticle: View {
    let particle: CelebrationParticle

    @State private var offset: CGSize = .zero
    @State private var opacity: Double = 1
    @State private var rotation: Double = 0
    @State private var scale: CGFloat = 0

    var body: some View {
        Group {
            switch particle.shape {
            case .circle:
                Circle().fill(particle.color)
            case .star:
                StarShape().fill(particle.color)
            case .rectangle:
                Rectangle().fill(particle.color)
            case .diamond:
                Rectangle().fill(particle.color).rotationEffect(.degrees(45))
            }
        }
        .frame(width: particle.size, height: particle.size)
        .scaleEffect(scale)
        .opacity(opacity)
        .rotationEffect(.degrees(rotation))
        .offset(offset)
        .onAppear {
            let radians = particle.angle * .pi / 180
            let targetX = cos(radians) * particle.velocity
            let targetY = sin(radians) * particle.velocity

            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                scale = 1.2
            }

            withAnimation(.easeOut(duration: 1.5)) {
                offset = CGSize(width: targetX, height: targetY)
                rotation = Double.random(in: 360...720)
            }

            withAnimation(.easeIn(duration: 1.5).delay(0.3)) {
                opacity = 0
                scale = 0.3
            }
        }
    }
}

struct StarShape: Shape {
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let outerRadius = min(rect.width, rect.height) / 2
        let innerRadius = outerRadius * 0.4
        var path = Path()

        for i in 0..<10 {
            let radius = i.isMultiple(of: 2) ? outerRadius : innerRadius
            let angle = (Double(i) * 36 - 90) * .pi / 180
            let point = CGPoint(
                x: center.x + CGFloat(cos(angle)) * radius,
                y: center.y + CGFloat(sin(angle)) * radius
            )
            if i == 0 {
                path.move(to: point)
            } else {
                path.addLine(to: point)
            }
        }
        path.closeSubpath()
        return path
    }
}

struct ConfettiPiece: View {
    let shape: CelebrationShape
    let color: Color
    let startX: CGFloat
    let delay: Double
    let screenHeight: CGFloat

    @State private var offsetY: CGFloat = -30
    @State private var offsetX: CGFloat = 0
    @State private var opacity: Double = 1
    @State private var rotation: Double = 0
    @State private var scale: CGFloat = 1

    private var shapeSize: CGFloat {
        CGFloat.random(in: 6...14)
    }

    var body: some View {
        Group {
            switch shape {
            case .circle:
                Circle().fill(color)
            case .star:
                StarShape().fill(color)
            case .rectangle:
                RoundedRectangle(cornerRadius: 2).fill(color)
            case .diamond:
                Rectangle().fill(color).rotationEffect(.degrees(45))
            }
        }
        .frame(width: shapeSize, height: shapeSize)
        .offset(x: startX + offsetX, y: offsetY)
        .opacity(opacity)
        .rotationEffect(.degrees(rotation))
        .scaleEffect(scale)
        .onAppear {
            let swayAmount = CGFloat.random(in: -50...50)
            let duration = Double.random(in: 2.5...4.0)

            withAnimation(
                .easeInOut(duration: duration)
                    .delay(delay)
                    .repeatForever(autoreverses: false)
            ) {
                offsetY = screenHeight + 50
                offsetX = swayAmount
                rotation = Double.random(in: 360...720)
            }

            withAnimation(
                .easeIn(duration: duration * 0.3)
                    .delay(delay + duration * 0.7)
                    .repeatForever(autoreverses: false)
            ) {
                opacity = 0
            }
        }
    }
}

// Legacy support
struct ConfettiView: View {
    var body: some View {
        CelebrationView()
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Dog.self, TrainingSession.self, configurations: config)

    let dog = Dog(name: "Max")
    container.mainContext.insert(dog)

    let session = TrainingSession(dog: dog, commandIds: ["stay", "come", "down"])
    session.successCount = 21
    session.totalReps = 24
    session.durationSeconds = 332
    container.mainContext.insert(session)

    return SessionCompleteView(session: session) {}
        .modelContainer(container)
}
