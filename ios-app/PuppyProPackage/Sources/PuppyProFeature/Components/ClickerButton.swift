import SwiftUI
import AVFoundation

struct ClickerButton: View {
    let onTap: () -> Void
    var size: CGFloat = 180
    var showPulseRing: Bool = true

    @State private var isPressed = false
    @State private var pulseAnimation = false

    var body: some View {
        ZStack {
            // Outer pulse rings
            if showPulseRing {
                Circle()
                    .stroke(AppColors.primary.opacity(0.15), lineWidth: 2)
                    .frame(width: size + 80, height: size + 80)
                    .scaleEffect(pulseAnimation ? 1.1 : 1.0)
                    .opacity(pulseAnimation ? 0.2 : 0.5)
                    .animation(
                        .easeInOut(duration: 2).repeatForever(autoreverses: true),
                        value: pulseAnimation
                    )

                Circle()
                    .stroke(AppColors.primary.opacity(0.25), lineWidth: 2)
                    .frame(width: size + 40, height: size + 40)
            }

            // Main clicker button
            Button {
                withAnimation(.spring(response: 0.15, dampingFraction: 0.6)) {
                    isPressed = true
                }

                // Haptic feedback
                let impact = UIImpactFeedbackGenerator(style: .medium)
                impact.impactOccurred()

                onTap()

                // Use Task-based approach instead of GCD
                Task { @MainActor in
                    try? await Task.sleep(for: .milliseconds(100))
                    withAnimation(.spring(response: 0.2)) {
                        isPressed = false
                    }
                }
            } label: {
                ZStack {
                    Circle()
                        .fill(AppColors.primaryGradient)
                        .shadow(
                            color: AppColors.primary.opacity(0.5),
                            radius: isPressed ? 8 : 20,
                            y: isPressed ? 2 : 8
                        )

                    VStack(spacing: 8) {
                        PiAPIIcon(name: PiAPIIcons.clicker, size: size * 0.35)

                        Text("CLICK")
                            .font(.system(size: size * 0.1, weight: .bold))
                            .foregroundStyle(.white)
                            .tracking(2)
                    }
                }
                .frame(width: size, height: size)
                .scaleEffect(isPressed ? 0.95 : 1.0)
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Clicker")
            .accessibilityHint("Double-tap to record a click for training")

            // Glow ring
            Circle()
                .stroke(AppColors.primary.opacity(0.2), lineWidth: 8)
                .frame(width: size + 16, height: size + 16)
        }
        .onAppear {
            pulseAnimation = true
        }
    }
}

#Preview {
    ZStack {
        AppColors.background
            .ignoresSafeArea()

        ClickerButton {
            print("Clicked!")
        }
    }
}
