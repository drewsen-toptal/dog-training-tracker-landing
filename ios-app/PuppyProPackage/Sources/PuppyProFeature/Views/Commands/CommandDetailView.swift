import SwiftUI
import SwiftData
import WebKit

// MARK: - YouTube Player

struct YouTubePlayerView: UIViewRepresentable {
    let videoId: String

    func makeUIView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        configuration.mediaTypesRequiringUserActionForPlayback = []

        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.scrollView.isScrollEnabled = false
        webView.isOpaque = false
        webView.backgroundColor = .clear
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        let embedHTML = """
        <!DOCTYPE html>
        <html>
        <head>
            <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
            <style>
                * { margin: 0; padding: 0; }
                html, body { width: 100%; height: 100%; background: #1a1a1c; }
                iframe { position: absolute; top: 0; left: 0; width: 100%; height: 100%; border: 0; border-radius: 12px; }
            </style>
        </head>
        <body>
            <iframe
                src="https://www.youtube.com/embed/\(videoId)?playsinline=1&rel=0&modestbranding=1"
                allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
                allowfullscreen>
            </iframe>
        </body>
        </html>
        """
        webView.loadHTMLString(embedHTML, baseURL: nil)
    }
}

struct CommandDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Query private var dogs: [Dog]

    let command: Command

    @State private var showingTraining = false

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
                    // Command hero
                    commandHero

                    // Progress card
                    progressCard

                    // Video section
                    videoSection

                    // Instructions
                    instructionsCard

                    // Tips
                    tipsCard

                    // Spacer for bottom button
                    Spacer()
                        .frame(height: 100)
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
                TrainingSessionView(dog: dog)
            }
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

                YouTubePlayerView(videoId: videoId)
                    .frame(height: 200)
                    .clipShape(.rect(cornerRadius: AppRadius.lg))
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
