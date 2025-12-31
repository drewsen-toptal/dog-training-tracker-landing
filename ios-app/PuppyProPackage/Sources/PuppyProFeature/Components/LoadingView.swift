import SwiftUI

/// Loading style options
enum LoadingStyle {
    case icon           // PiAPI icon animation
    case lottie         // Cute dog Lottie animation
}

/// A polished loading view with animated PiAPI icons or Lottie animations
/// Maintains brand consistency with the app's premium visual style
struct LoadingView: View {
    let message: String
    var iconName: String = PiAPIIcons.puppyMascot
    var style: LoadingStyle = .lottie  // Default to dog Lottie for premium feel

    @State private var isAnimating = false
    @State private var bounceOffset: CGFloat = 0
    @State private var rotation: Double = 0

    var body: some View {
        VStack(spacing: 24) {
            // Animated content based on style
            switch style {
            case .lottie:
                // Cute dog loading Lottie animation
                LottieView.dogLoading(size: 140)

            case .icon:
                // Animated icon with bounce and subtle rotation
                ZStack {
                    // Shadow circle that scales with bounce
                    Circle()
                        .fill(AppColors.primary.opacity(0.1))
                        .frame(width: 120, height: 120)
                        .scaleEffect(isAnimating ? 0.85 : 1.0)
                        .animation(
                            .easeInOut(duration: 0.6)
                            .repeatForever(autoreverses: true),
                            value: isAnimating
                        )

                    // Main icon with bounce
                    PiAPIIcon(name: iconName, size: 100)
                        .offset(y: bounceOffset)
                        .rotationEffect(.degrees(rotation))
                }
            }

            // Loading text with fade animation
            VStack(spacing: 8) {
                Text(message)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(AppColors.textPrimary)

                // Animated dots
                LoadingDots()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppColors.background.opacity(0.95))
        .onAppear {
            if style == .icon {
                isAnimating = true
                startBounceAnimation()
            }
        }
    }

    private func startBounceAnimation() {
        // Playful bounce animation
        withAnimation(
            .easeInOut(duration: 0.5)
            .repeatForever(autoreverses: true)
        ) {
            bounceOffset = -12
        }

        // Subtle rotation wiggle
        withAnimation(
            .easeInOut(duration: 0.8)
            .repeatForever(autoreverses: true)
        ) {
            rotation = 3
        }
    }
}

/// Animated loading dots using phaseAnimator for Swift 6 compatibility
struct LoadingDots: View {
    @State private var phase = 0

    var body: some View {
        HStack(spacing: 6) {
            ForEach(0..<3, id: \.self) { index in
                Circle()
                    .fill(AppColors.primary)
                    .frame(width: 8, height: 8)
                    .scaleEffect(phase == index ? 1.3 : 0.8)
                    .opacity(phase == index ? 1.0 : 0.4)
            }
        }
        .task {
            while !Task.isCancelled {
                try? await Task.sleep(for: .milliseconds(400))
                phase = (phase + 1) % 3
            }
        }
        .animation(.easeInOut(duration: 0.3), value: phase)
    }
}

/// A compact inline loading indicator with icon
struct InlineLoadingView: View {
    let message: String
    var iconName: String = PiAPIIcons.puppyMascot

    @State private var isAnimating = false

    var body: some View {
        HStack(spacing: 12) {
            PiAPIIcon(name: iconName, size: 32)
                .rotationEffect(.degrees(isAnimating ? 360 : 0))
                .animation(
                    .linear(duration: 2.0)
                    .repeatForever(autoreverses: false),
                    value: isAnimating
                )

            Text(message)
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(AppColors.textSecondary)

            LoadingDots()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(.white)
        .clipShape(Capsule())
        .shadow(color: .black.opacity(0.08), radius: 12, y: 4)
        .onAppear {
            isAnimating = true
        }
    }
}

/// Skeleton loading placeholder with shimmer effect
struct SkeletonView: View {
    @State private var shimmerOffset: CGFloat = -1

    var body: some View {
        GeometryReader { geometry in
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.gray.opacity(0.15))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(
                            LinearGradient(
                                colors: [
                                    .clear,
                                    .white.opacity(0.4),
                                    .clear
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .offset(x: shimmerOffset * geometry.size.width)
                )
                .clipped()
        }
        .onAppear {
            withAnimation(
                .linear(duration: 1.5)
                .repeatForever(autoreverses: false)
            ) {
                shimmerOffset = 2
            }
        }
    }
}

/// Success animation style options
enum SuccessStyle {
    case icon           // PiAPI checkmark icon
    case lottie         // Animated Lottie checkmark
}

/// A success animation view for completed actions
struct SuccessAnimationView: View {
    let message: String
    var style: SuccessStyle = .lottie  // Default to Lottie for premium feel
    var onComplete: (() -> Void)?

    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0
    @State private var showLottie = false
    @State private var showStars = false

    var body: some View {
        ZStack {
            // Stars sparkle overlay for celebration effect
            if showStars {
                LottieView.starsSparkle(size: 350)
                    .allowsHitTesting(false)
            }

            VStack(spacing: 20) {
                switch style {
                case .lottie:
                    // Lottie checkmark animation
                    ZStack {
                        Circle()
                            .fill(AppColors.success.opacity(0.1))
                            .frame(width: 120, height: 120)
                            .scaleEffect(showLottie ? 1.0 : 0.5)
                            .animation(.spring(response: 0.4, dampingFraction: 0.7), value: showLottie)

                        if showLottie {
                            LottieView.checkmark(size: 80)
                        }
                    }

                case .icon:
                    ZStack {
                        Circle()
                            .fill(AppColors.success.opacity(0.15))
                            .frame(width: 120, height: 120)
                            .scaleEffect(scale * 1.2)

                        PiAPIIcon(name: PiAPIIcons.checkmark, size: 80)
                            .scaleEffect(scale)
                    }
                }

                Text(message)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(AppColors.textPrimary)
                    .opacity(opacity)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppColors.background.opacity(0.95))
        .onAppear {
            if style == .lottie {
                // Trigger Lottie animation with slight delay
                withAnimation {
                    showLottie = true
                }
                withAnimation(.easeIn(duration: 0.3).delay(0.2)) {
                    opacity = 1.0
                }
                // Show stars sparkle for celebration
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    showStars = true
                }
            } else {
                // Bounce in animation for icon style
                withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                    scale = 1.0
                }
                withAnimation(.easeIn(duration: 0.3).delay(0.2)) {
                    opacity = 1.0
                }
            }

            // Auto-dismiss after delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                onComplete?()
            }
        }
    }
}

#Preview("Loading View - Lottie") {
    LoadingView(message: "Fetching your pup's data", style: .lottie)
}

#Preview("Loading View - Icon") {
    LoadingView(message: "Fetching your pup's data", style: .icon)
}

#Preview("Inline Loading") {
    VStack {
        InlineLoadingView(message: "Syncing")
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(AppColors.background)
}

#Preview("Success Animation - Lottie") {
    SuccessAnimationView(message: "Training saved!", style: .lottie)
}

#Preview("Success Animation - Icon") {
    SuccessAnimationView(message: "Training saved!", style: .icon)
}

#Preview("Skeleton") {
    VStack(spacing: 12) {
        SkeletonView()
            .frame(height: 60)

        SkeletonView()
            .frame(height: 100)

        SkeletonView()
            .frame(height: 40)
    }
    .padding()
}
