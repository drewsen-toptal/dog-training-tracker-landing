import SwiftUI
import SwiftData

struct SessionCompleteView: View {
    let session: TrainingSession
    let onDismiss: () -> Void

    @State private var showConfetti = false

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
                    // Success badge
                    ZStack {
                        Circle()
                            .fill(.white)
                            .frame(width: 100, height: 100)
                            .shadow(color: .black.opacity(0.2), radius: 20, y: 8)

                        Image(systemName: "checkmark")
                            .font(.system(size: 48, weight: .bold))
                            .foregroundStyle(AppColors.success)
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
            AsyncImage(url: URL(string: command.iconUrl ?? "")) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                default:
                    ZStack {
                        AppColors.success.opacity(0.12)
                        Image(systemName: command.category.iconName)
                            .foregroundStyle(AppColors.success)
                    }
                }
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

            Text("+5%")
                .font(AppFonts.subheadline())
                .fontWeight(.semibold)
                .foregroundStyle(AppColors.success)
                .padding(.horizontal, AppSpacing.sm)
                .padding(.vertical, AppSpacing.xxs)
                .background(AppColors.success.opacity(0.12))
                .clipShape(.rect(cornerRadius: AppRadius.xs))
        }
    }

    @ViewBuilder
    private var nextReviewCard: some View {
        HStack(spacing: AppSpacing.sm) {
            ZStack {
                AppColors.primary.opacity(0.12)
                Image(systemName: "bolt.fill")
                    .font(.title3)
                    .foregroundStyle(AppColors.primary)
            }
            .frame(width: 44, height: 44)
            .clipShape(.rect(cornerRadius: AppRadius.sm))

            VStack(alignment: .leading, spacing: 2) {
                Text("Next Review: Stay")
                    .font(AppFonts.subheadline())
                    .fontWeight(.semibold)
                    .foregroundStyle(AppColors.textPrimary)

                Text("Scheduled for tomorrow at optimal time")
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
            Image(systemName: "flame.fill")
                .font(.system(size: 32))
                .foregroundStyle(AppColors.warning)

            VStack(alignment: .leading, spacing: 2) {
                Text("12 Day Streak!")
                    .font(AppFonts.headline())
                    .foregroundStyle(AppColors.textPrimary)

                Text("Keep it going - train again tomorrow")
                    .font(AppFonts.caption())
                    .foregroundStyle(AppColors.textSecondary)
            }

            Spacer()
        }
        .padding(AppSpacing.md)
        .background(AppColors.warning.opacity(0.15))
        .clipShape(.rect(cornerRadius: AppRadius.lg))
    }
}

struct ConfettiView: View {
    var body: some View {
        GeometryReader { geometry in
            ForEach(0..<20) { i in
                ConfettiPiece(
                    color: [AppColors.warning, AppColors.success, .white][i % 3],
                    startX: CGFloat.random(in: 0...geometry.size.width),
                    delay: Double(i) * 0.15
                )
            }
        }
    }
}

struct ConfettiPiece: View {
    let color: Color
    let startX: CGFloat
    let delay: Double

    @State private var offset: CGFloat = -20
    @State private var opacity: Double = 1
    @State private var rotation: Double = 0

    var body: some View {
        Rectangle()
            .fill(color)
            .frame(width: 10, height: 10)
            .clipShape(.rect(cornerRadius: 2))
            .offset(x: startX, y: offset)
            .opacity(opacity)
            .rotationEffect(.degrees(rotation))
            .onAppear {
                withAnimation(
                    .easeOut(duration: 3)
                        .delay(delay)
                        .repeatForever(autoreverses: false)
                ) {
                    offset = 400
                    opacity = 0
                    rotation = 360
                }
            }
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
