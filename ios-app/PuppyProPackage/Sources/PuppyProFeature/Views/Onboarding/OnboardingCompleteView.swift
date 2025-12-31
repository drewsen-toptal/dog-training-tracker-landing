import SwiftUI

/// Celebration view shown after completing onboarding
/// Features a happy dog Lottie animation with premium entrance effects
struct OnboardingCompleteView: View {
    let dogName: String
    let onContinue: () -> Void

    @State private var showAnimation = false
    @State private var showText = false
    @State private var showButton = false
    @State private var confettiTrigger = false

    var body: some View {
        ZStack {
            // Gradient background
            LinearGradient(
                colors: [AppColors.primary, AppColors.primaryDark],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            // Stars sparkle overlay - Lottie animation
            if confettiTrigger {
                LottieView.starsSparkle(size: 500)
                    .allowsHitTesting(false)
            }

            // Confetti overlay
            if confettiTrigger {
                ConfettiView()
            }

            VStack(spacing: AppSpacing.xxl) {
                Spacer()

                // Happy dog with premium 3D mascot
                ZStack {
                    // Glow effect
                    Circle()
                        .fill(.white.opacity(0.15))
                        .frame(width: 220, height: 220)
                        .blur(radius: 30)
                        .scaleEffect(showAnimation ? 1.1 : 0.8)
                        .animation(
                            .easeInOut(duration: 2.0)
                            .repeatForever(autoreverses: true),
                            value: showAnimation
                        )

                    // White background circle
                    Circle()
                        .fill(.white)
                        .frame(width: 180, height: 180)
                        .shadow(color: .black.opacity(0.2), radius: 20, y: 10)

                    // Happy dog Lottie animation
                    if showAnimation {
                        LottieView.happyDog(size: 140)
                    }
                }
                .scaleEffect(showAnimation ? 1 : 0.5)
                .opacity(showAnimation ? 1 : 0)

                // Celebration text
                VStack(spacing: AppSpacing.md) {
                    Text("You're All Set! 🎉")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundStyle(.white)

                    Text("Welcome aboard, \(dogName)!")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(.white.opacity(0.9))

                    Text("Let's start your training journey together")
                        .font(AppFonts.body())
                        .foregroundStyle(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, AppSpacing.xl)
                }
                .opacity(showText ? 1 : 0)
                .offset(y: showText ? 0 : 20)

                Spacer()

                // Continue button
                Button {
                    // Haptic feedback
                    let generator = UIImpactFeedbackGenerator(style: .medium)
                    generator.impactOccurred()
                    onContinue()
                } label: {
                    HStack(spacing: AppSpacing.sm) {
                        Text("Start Training")
                            .font(AppFonts.headline())

                        Image(systemName: "arrow.right")
                            .font(.system(size: 16, weight: .semibold))
                    }
                    .foregroundStyle(AppColors.primary)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(.white)
                    .clipShape(.rect(cornerRadius: AppRadius.xl))
                    .shadow(color: .black.opacity(0.15), radius: 12, y: 4)
                }
                .padding(.horizontal, AppSpacing.xl)
                .opacity(showButton ? 1 : 0)
                .offset(y: showButton ? 0 : 30)
                .padding(.bottom, AppSpacing.xxxl)
            }
        }
        .onAppear {
            startAnimations()
        }
    }

    private func startAnimations() {
        // Trigger happy dog animation
        withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
            showAnimation = true
        }

        // Show confetti
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            confettiTrigger = true

            // Haptic burst
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
        }

        // Show text
        withAnimation(.easeOut(duration: 0.5).delay(0.4)) {
            showText = true
        }

        // Show button
        withAnimation(.spring(response: 0.5, dampingFraction: 0.7).delay(0.8)) {
            showButton = true
        }
    }
}

#Preview {
    OnboardingCompleteView(dogName: "Buddy") {
        print("Continue tapped")
    }
}
