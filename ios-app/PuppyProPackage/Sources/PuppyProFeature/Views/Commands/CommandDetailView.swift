import SwiftUI
import SwiftData
import YouTubePlayerKit

// MARK: - YouTube Video Card (Embedded Player)

struct YouTubeVideoCard: View {
    let videoId: String
    let commandName: String

    // Configure YouTube player with inline playback and fullscreen enabled
    // Block navigation to YouTube by using empty openURLAction handler
    private var player: YouTubePlayer {
        YouTubePlayer(
            source: .video(id: videoId),
            configuration: .init(
                fullscreenMode: .system,
                openURLAction: .init { _ in },  // Block YouTube icon navigation
                showControls: true,
                showFullscreenButton: true,
                playInline: true,
                showRelatedVideos: false
            )
        )
    }

    var body: some View {
        YouTubePlayerView(player)
            .aspectRatio(16/9, contentMode: .fit)
            .clipShape(.rect(cornerRadius: AppRadius.md))
            .accessibilityLabel("\(commandName) training video")
            .accessibilityHint("Tap the video to play")
    }
}

struct CommandDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Query private var dogs: [Dog]

    let command: Command

    @State private var showingTraining = false
    @State private var animateProgress = false

    private var currentDog: Dog? {
        dogs.first
    }

    private var commandProgress: CommandProgress? {
        guard let dog = currentDog else { return nil }
        return dog.commandProgress?.first { $0.commandId == command.id }
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                VStack(spacing: AppSpacing.lg) {
                    // Premium Command Hero with gradient
                    premiumHero

                    // Circular Progress Ring
                    masteryRing

                    // Video section
                    videoSection

                    // Instructions with premium styling
                    instructionsCard

                    // Tips
                    tipsCard

                    // Spacer for bottom button (gradient 40 + button ~60 + tab bar padding 100)
                    Spacer()
                        .frame(height: 200)
                }
                .padding(.horizontal, AppSpacing.lg)
            }
            .background(AppColors.background)

            // Bottom CTA
            bottomButton
        }
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingTraining) {
            if let dog = currentDog {
                TrainingSessionView(dog: dog, initialCommand: command, singleCommandMode: true)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 1.0).delay(0.3)) {
                animateProgress = true
            }
        }
    }

    @ViewBuilder
    private var premiumHero: some View {
        VStack(spacing: 0) {
            // Gradient header background
            ZStack {
                // Gradient background
                LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryDark],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )

                // Decorative circles
                Circle()
                    .fill(.white.opacity(0.1))
                    .frame(width: 200, height: 200)
                    .offset(x: 100, y: -80)

                Circle()
                    .fill(.white.opacity(0.08))
                    .frame(width: 120, height: 120)
                    .offset(x: -120, y: 60)

                // Content
                VStack(spacing: AppSpacing.md) {
                    // Large command icon with glow
                    ZStack {
                        Circle()
                            .fill(.white.opacity(0.2))
                            .frame(width: 100, height: 100)
                            .blur(radius: 10)

                        Circle()
                            .fill(.white)
                            .frame(width: 88, height: 88)
                            .shadow(color: .black.opacity(0.15), radius: 12, y: 6)

                        PiAPIIcon(name: command.piAPIIconName, size: 52)
                    }

                    // Command name
                    Text(command.name)
                        .font(.system(size: 32, weight: .bold))
                        .foregroundStyle(.white)

                    // Badges
                    HStack(spacing: AppSpacing.sm) {
                        // Difficulty badge
                        HStack(spacing: 4) {
                            Image(systemName: difficultyIcon)
                                .font(.system(size: 12, weight: .bold))
                            Text(command.difficulty.displayName)
                                .font(.system(size: 13, weight: .semibold))
                        }
                        .foregroundStyle(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(.white.opacity(0.2))
                        .clipShape(Capsule())

                        // Category badge
                        HStack(spacing: 4) {
                            Image(systemName: "folder.fill")
                                .font(.system(size: 12, weight: .bold))
                            Text(command.category.displayName)
                                .font(.system(size: 13, weight: .semibold))
                        }
                        .foregroundStyle(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(.white.opacity(0.2))
                        .clipShape(Capsule())
                    }
                }
                .padding(.vertical, AppSpacing.xl)
            }
            .frame(height: 220)
            .clipShape(.rect(cornerRadius: AppRadius.xl))
            .shadow(color: AppColors.primary.opacity(0.3), radius: 16, y: 8)
        }
    }

    private var difficultyIcon: String {
        switch command.difficulty {
        case .beginner: return "star.fill"
        case .intermediate: return "star.leadinghalf.filled"
        case .advanced: return "star.circle.fill"
        }
    }

    @ViewBuilder
    private var commandHero: some View {
        HStack(spacing: AppSpacing.lg) {
            // Command icon
            ZStack {
                AppColors.primaryGradient
                PiAPIIcon(name: command.piAPIIconName, size: 48)
            }
            .frame(width: 72, height: 72)
            .clipShape(.rect(cornerRadius: AppRadius.lg))
            .shadow(color: AppColors.primary.opacity(0.3), radius: 12, y: 6)

            VStack(alignment: .leading, spacing: AppSpacing.xxs) {
                Text(command.name)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(AppColors.textPrimary)

                HStack(spacing: AppSpacing.xs) {
                    // Difficulty badge
                    Text(command.difficulty.displayName)
                        .font(AppFonts.caption())
                        .fontWeight(.semibold)
                        .foregroundStyle(AppColors.warning)
                        .padding(.horizontal, AppSpacing.sm)
                        .padding(.vertical, AppSpacing.xxs)
                        .background(AppColors.warning.opacity(0.15))
                        .clipShape(.rect(cornerRadius: AppRadius.xs))

                    // Category badge
                    Text(command.category.displayName)
                        .font(AppFonts.caption())
                        .fontWeight(.semibold)
                        .foregroundStyle(AppColors.primary)
                        .padding(.horizontal, AppSpacing.sm)
                        .padding(.vertical, AppSpacing.xxs)
                        .background(AppColors.primary.opacity(0.1))
                        .clipShape(.rect(cornerRadius: AppRadius.xs))
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
    private var masteryRing: some View {
        let progress = commandProgress
        let successRate = progress?.successRate ?? 0
        let practiceCount = progress?.practiceCount ?? 0
        let successRateText = progress != nil && practiceCount > 0 ? "\(progress!.successRatePercentage)%" : "0%"
        let lastTrainedText = progress?.daysSinceLastPracticeDescription ?? "Never"
        let animatedProgress = animateProgress ? successRate : 0

        VStack(spacing: AppSpacing.lg) {
            // Circular progress with animated ring
            HStack(spacing: AppSpacing.xl) {
                // Animated ring
                ZStack {
                    // Background ring
                    Circle()
                        .stroke(AppColors.background, lineWidth: 12)
                        .frame(width: 100, height: 100)

                    // Progress ring
                    Circle()
                        .trim(from: 0, to: animatedProgress)
                        .stroke(
                            successRate > 0 ? AnyShapeStyle(AppColors.primaryGradient) : AnyShapeStyle(AppColors.textTertiary),
                            style: StrokeStyle(lineWidth: 12, lineCap: .round)
                        )
                        .frame(width: 100, height: 100)
                        .rotationEffect(.degrees(-90))

                    // Center content
                    VStack(spacing: 2) {
                        Text(successRateText)
                            .font(.system(size: 22, weight: .bold))
                            .foregroundStyle(successRate > 0 ? AppColors.primary : AppColors.textTertiary)

                        Text("Mastery")
                            .font(.system(size: 10, weight: .medium))
                            .foregroundStyle(AppColors.textSecondary)
                    }
                }

                // Stats column
                VStack(alignment: .leading, spacing: AppSpacing.md) {
                    // Sessions stat
                    HStack(spacing: AppSpacing.sm) {
                        ZStack {
                            Circle()
                                .fill(AppColors.primary.opacity(0.12))
                                .frame(width: 36, height: 36)

                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(AppColors.primary)
                        }

                        VStack(alignment: .leading, spacing: 2) {
                            Text("\(practiceCount)")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundStyle(AppColors.textPrimary)

                            Text("Training Sessions")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundStyle(AppColors.textSecondary)
                        }
                    }

                    // Last trained stat
                    HStack(spacing: AppSpacing.sm) {
                        ZStack {
                            Circle()
                                .fill(AppColors.success.opacity(0.12))
                                .frame(width: 36, height: 36)

                            Image(systemName: "clock.fill")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(AppColors.success)
                        }

                        VStack(alignment: .leading, spacing: 2) {
                            Text(lastTrainedText)
                                .font(.system(size: 18, weight: .bold))
                                .foregroundStyle(AppColors.textPrimary)

                            Text("Last Trained")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundStyle(AppColors.textSecondary)
                        }
                    }
                }

                Spacer()
            }
        }
        .padding(AppSpacing.lg)
        .background(.white)
        .clipShape(.rect(cornerRadius: AppRadius.lg))
        .shadow(color: .black.opacity(0.04), radius: 8, y: 2)
    }

    @ViewBuilder
    private var progressCard: some View {
        let progress = commandProgress
        let successRate = progress?.successRate ?? 0
        let practiceCount = progress?.practiceCount ?? 0
        let successRateText = progress != nil && practiceCount > 0 ? "\(progress!.successRatePercentage)%" : "0%"
        let lastTrainedText = progress?.daysSinceLastPracticeDescription ?? "Never"

        VStack(spacing: AppSpacing.md) {
            HStack {
                Text("Mastery Progress")
                    .font(AppFonts.headline())
                    .foregroundStyle(AppColors.textPrimary)

                Spacer()

                Text(successRateText)
                    .font(.title2.weight(.bold))
                    .foregroundStyle(successRate > 0 ? AppColors.primary : AppColors.textTertiary)
            }

            // Progress bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 5)
                        .fill(AppColors.background)
                        .frame(height: 10)

                    RoundedRectangle(cornerRadius: 5)
                        .fill(successRate > 0 ? AnyShapeStyle(AppColors.primaryGradient) : AnyShapeStyle(AppColors.textTertiary))
                        .frame(width: geometry.size.width * successRate, height: 10)
                }
            }
            .frame(height: 10)

            // Stats
            HStack {
                statColumn(value: "\(practiceCount)", label: "Sessions")
                Spacer()
                statColumn(value: successRateText, label: "Success Rate")
                Spacer()
                statColumn(value: lastTrainedText, label: "Last Trained")
            }
        }
        .padding(AppSpacing.lg)
        .background(.white)
        .clipShape(.rect(cornerRadius: AppRadius.lg))
        .shadow(color: .black.opacity(0.04), radius: 8, y: 2)
    }

    @ViewBuilder
    private func statColumn(value: String, label: String) -> some View {
        VStack(spacing: AppSpacing.xxs) {
            Text(value)
                .font(.title3.weight(.bold))
                .foregroundStyle(AppColors.textPrimary)

            Text(label.uppercased())
                .font(.caption2)
                .fontWeight(.semibold)
                .foregroundStyle(AppColors.textSecondary)
        }
    }

    @ViewBuilder
    private var videoSection: some View {
        if let videoId = command.youtubeVideoId {
            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                Text("Training Video")
                    .font(AppFonts.headline())
                    .foregroundStyle(AppColors.textPrimary)

                YouTubeVideoCard(videoId: videoId, commandName: command.name)
            }
            .padding(AppSpacing.lg)
            .background(.white)
            .clipShape(.rect(cornerRadius: AppRadius.lg))
            .shadow(color: .black.opacity(0.04), radius: 8, y: 2)
        } else {
            VStack(spacing: 0) {
                ZStack {
                    LinearGradient(
                        colors: [Color(red: 0.2, green: 0.2, blue: 0.22), Color(red: 0.15, green: 0.15, blue: 0.17)],
                        startPoint: .top,
                        endPoint: .bottom
                    )

                    VStack(spacing: AppSpacing.md) {
                        ZStack {
                            Circle()
                                .fill(.white.opacity(0.15))
                                .frame(width: 64, height: 64)

                            Image(systemName: "video.fill")
                                .font(.system(size: 24))
                                .foregroundStyle(.white.opacity(0.6))
                        }

                        VStack(spacing: AppSpacing.xxs) {
                            Text("Training Video")
                                .font(AppFonts.headline())
                                .fontWeight(.semibold)
                                .foregroundStyle(.white)

                            Text("Coming Soon")
                                .font(AppFonts.caption())
                                .fontWeight(.medium)
                                .foregroundStyle(.white.opacity(0.5))
                        }
                    }
                }
                .frame(height: 160)
            }
            .clipShape(.rect(cornerRadius: AppRadius.lg))
            .shadow(color: .black.opacity(0.04), radius: 8, y: 2)
        }
    }

    @ViewBuilder
    private var instructionsCard: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text("How to Train \"\(command.name)\"")
                .font(AppFonts.headline())
                .foregroundStyle(AppColors.textPrimary)

            ForEach(command.steps) { step in
                HStack(alignment: .top, spacing: AppSpacing.sm) {
                    // Step number
                    Text("\(step.order)")
                        .font(AppFonts.subheadline())
                        .fontWeight(.bold)
                        .foregroundStyle(AppColors.primary)
                        .frame(width: 28, height: 28)
                        .background(AppColors.primary.opacity(0.12))
                        .clipShape(Circle())

                    Text(step.instruction)
                        .font(AppFonts.body())
                        .foregroundStyle(AppColors.textSecondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        .padding(AppSpacing.lg)
        .background(.white)
        .clipShape(.rect(cornerRadius: AppRadius.lg))
        .shadow(color: .black.opacity(0.04), radius: 8, y: 2)
    }

    @ViewBuilder
    private var tipsCard: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            HStack(spacing: AppSpacing.sm) {
                PiAPIIcon(name: PiAPIIcons.lightbulb, size: 22)

                Text("Pro Tips")
                    .font(AppFonts.headline())
                    .foregroundStyle(AppColors.textPrimary)
            }

            ForEach(command.tips, id: \.self) { tip in
                HStack(alignment: .top, spacing: AppSpacing.sm) {
                    Circle()
                        .fill(AppColors.warning)
                        .frame(width: 6, height: 6)
                        .padding(.top, 8)

                    Text(tip)
                        .font(AppFonts.subheadline())
                        .foregroundStyle(AppColors.textSecondary)
                }
            }
        }
        .padding(AppSpacing.lg)
        .background(AppColors.warning.opacity(0.12))
        .clipShape(.rect(cornerRadius: AppRadius.lg))
    }

    @ViewBuilder
    private var bottomButton: some View {
        VStack(spacing: 0) {
            LinearGradient(
                colors: [AppColors.background.opacity(0), AppColors.background],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 40)

            VStack {
                PrimaryButton(
                    title: "Start Training \(command.name)",
                    iconName: PiAPIIcons.play,
                    isDisabled: currentDog == nil
                ) {
                    showingTraining = true
                }
                .padding(.horizontal, AppSpacing.xl)
            }
            .padding(.bottom, 100) // Account for tab bar height
            .background(AppColors.background)
        }
    }
}

#Preview {
    NavigationStack {
        CommandDetailView(command: Command.allCommands[1])
    }
    .modelContainer(for: Dog.self, inMemory: true)
}
