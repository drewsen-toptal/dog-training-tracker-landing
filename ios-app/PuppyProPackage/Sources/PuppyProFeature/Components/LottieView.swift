import SwiftUI
import Lottie

/// A SwiftUI wrapper for Lottie animations
struct LottieView: View {
    let animationName: String
    let loopMode: LottieLoopMode
    let animationSpeed: CGFloat
    let contentMode: UIView.ContentMode

    @State private var playbackState: LottiePlaybackMode = .paused

    init(
        animationName: String,
        loopMode: LottieLoopMode = .loop,
        animationSpeed: CGFloat = 1.0,
        contentMode: UIView.ContentMode = .scaleAspectFit
    ) {
        self.animationName = animationName
        self.loopMode = loopMode
        self.animationSpeed = animationSpeed
        self.contentMode = contentMode
    }

    var body: some View {
        LottieViewRepresentable(
            animationName: animationName,
            loopMode: loopMode,
            animationSpeed: animationSpeed,
            contentMode: contentMode
        )
    }
}

/// UIViewRepresentable wrapper for LottieAnimationView
private struct LottieViewRepresentable: UIViewRepresentable {
    let animationName: String
    let loopMode: LottieLoopMode
    let animationSpeed: CGFloat
    let contentMode: UIView.ContentMode

    func makeUIView(context: Context) -> some UIView {
        let containerView = UIView(frame: .zero)
        containerView.backgroundColor = .clear

        let animationView = LottieAnimationView(name: animationName, bundle: .module)
        animationView.loopMode = loopMode
        animationView.animationSpeed = animationSpeed
        animationView.contentMode = contentMode
        animationView.backgroundBehavior = .pauseAndRestore
        animationView.translatesAutoresizingMaskIntoConstraints = false

        containerView.addSubview(animationView)

        NSLayoutConstraint.activate([
            animationView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            animationView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            animationView.topAnchor.constraint(equalTo: containerView.topAnchor),
            animationView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])

        animationView.play()

        return containerView
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
        // Animation continues playing
    }
}

// MARK: - Lottie Animation Names

/// Centralized names for all Lottie animations used in the app
enum LottieAnimations {
    /// Success celebration - used after completing a training session
    static let success = "success-celebration"

    /// Trophy animation - used when goal is achieved
    static let trophy = "trophy"

    /// Confetti burst - subtle celebration effect
    static let confetti = "confetti"

    /// Paw print loading spinner
    static let pawLoading = "paw-loading"

    /// Cute dog loading animation - friendly loading state
    static let dogLoading = "cute-dog-loading"

    /// Dog wagging tail - friendly empty state
    static let happyDog = "happy-dog"

    /// Checkmark animation - quick success feedback
    static let checkmark = "checkmark-success"

    /// Stars sparkle animation - celebration effect
    static let starsSparkle = "stars-sparkle"
}

// MARK: - Preset Lottie Views

extension LottieView {
    /// Success celebration animation (plays once)
    static func success(size: CGFloat = 150) -> some View {
        LottieView(
            animationName: LottieAnimations.success,
            loopMode: .playOnce,
            animationSpeed: 1.0
        )
        .frame(width: size, height: size)
    }

    /// Trophy celebration (plays once)
    static func trophy(size: CGFloat = 100) -> some View {
        LottieView(
            animationName: LottieAnimations.trophy,
            loopMode: .playOnce,
            animationSpeed: 1.2
        )
        .frame(width: size, height: size)
    }

    /// Confetti burst (plays once)
    static func confetti(size: CGFloat = 200) -> some View {
        LottieView(
            animationName: LottieAnimations.confetti,
            loopMode: .playOnce,
            animationSpeed: 1.0
        )
        .frame(width: size, height: size)
    }

    /// Loading spinner with paw print
    static func loading(size: CGFloat = 60) -> some View {
        LottieView(
            animationName: LottieAnimations.pawLoading,
            loopMode: .loop,
            animationSpeed: 1.0
        )
        .frame(width: size, height: size)
    }

    /// Cute dog loading animation
    static func dogLoading(size: CGFloat = 120) -> some View {
        LottieView(
            animationName: LottieAnimations.dogLoading,
            loopMode: .loop,
            animationSpeed: 1.0
        )
        .frame(width: size, height: size)
    }

    /// Happy dog animation (loops)
    static func happyDog(size: CGFloat = 100) -> some View {
        LottieView(
            animationName: LottieAnimations.happyDog,
            loopMode: .loop,
            animationSpeed: 1.0
        )
        .frame(width: size, height: size)
    }

    /// Quick checkmark success
    static func checkmark(size: CGFloat = 50) -> some View {
        LottieView(
            animationName: LottieAnimations.checkmark,
            loopMode: .playOnce,
            animationSpeed: 1.5
        )
        .frame(width: size, height: size)
    }

    /// Stars sparkle animation (loops)
    static func starsSparkle(size: CGFloat = 300) -> some View {
        LottieView(
            animationName: LottieAnimations.starsSparkle,
            loopMode: .loop,
            animationSpeed: 1.0
        )
        .frame(width: size, height: size)
    }
}
