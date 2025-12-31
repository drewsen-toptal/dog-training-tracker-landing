import SwiftUI
import SwiftData
import AVFoundation

struct ClickerView: View {
    @Environment(\.dismiss) private var dismiss
    @Query private var dogs: [Dog]

    @AppStorage("totalClickerClicks") private var totalClicks = 0
    @State private var sessionClicks = 0
    @State private var sessionSeconds = 0
    @State private var timerTask: Task<Void, Never>?
    @AppStorage("clickerSoundEnabled") private var soundEnabled = true

    private var currentDog: Dog? {
        dogs.first
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Header
                headerView

                // Counter section
                counterSection

                // Clicker area
                clickerArea
                    .padding(.vertical, 40)

                // Session card
                sessionCard

                // Action buttons
                actionButtons
            }
        }
        .scrollIndicators(.hidden)
        .scrollBounceBehavior(.basedOnSize)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(
                colors: [
                    Color(red: 0.96, green: 0.96, blue: 0.97),
                    Color(red: 0.92, green: 0.92, blue: 0.94)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        )
        .navigationBarHidden(true)
        .onAppear {
            startTimer()
        }
        .onDisappear {
            timerTask?.cancel()
        }
    }

    @ViewBuilder
    private var headerView: some View {
        HStack {
            // Back button
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(AppColors.textSecondary)
                    .frame(width: 44, height: 44)
                    .contentShape(Rectangle())
            }
            .accessibilityLabel("Go Back")
            .accessibilityHint("Double-tap to close clicker and return to previous screen")

            VStack(alignment: .leading, spacing: 2) {
                Text("Clicker")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(AppColors.textPrimary)

                Text("Training \(currentDog?.name ?? "your pup")")
                    .font(.system(size: 15))
                    .foregroundStyle(AppColors.textSecondary)
            }

            Spacer()

            Button {
                // Settings
            } label: {
                // PiAPI 3D icons already have a white background baked in
                PiAPIIcon(name: PiAPIIcons.settings, size: 44, clipToCircle: true)
            }
            .accessibilityLabel("Clicker Settings")
            .accessibilityHint("Double-tap to open clicker settings")
        }
        .padding(.horizontal, 20)
        .padding(.top, 88) // Extra padding for comfortable sheet spacing
        .padding(.bottom, AppSpacing.lg)
    }

    @ViewBuilder
    private var counterSection: some View {
        VStack(spacing: 8) {
            Text("TOTAL CLICKS")
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(AppColors.textSecondary)
                .tracking(1)

            Text("\(totalClicks + sessionClicks)")
                .font(.system(size: 80, weight: .bold))
                .foregroundStyle(AppColors.textPrimary)
                .contentTransition(.numericText())
                .monospacedDigit()

            Text("This session: \(sessionClicks) clicks")
                .font(.system(size: 15))
                .foregroundStyle(AppColors.textTertiary)
        }
        .padding(.vertical, 32)
    }

    @ViewBuilder
    private var clickerArea: some View {
        ClickerButton(onTap: {
            recordClick()
        }, size: 180)
    }

    @ViewBuilder
    private var sessionCard: some View {
        HStack {
            // Timer
            HStack(spacing: 12) {
                // PiAPI 3D icons already have a white background baked in
                PiAPIIcon(name: PiAPIIcons.clock, size: 44)

                VStack(alignment: .leading, spacing: 2) {
                    Text("Session Time")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(AppColors.textSecondary)

                    Text(formattedTime)
                        .font(.system(size: 22, weight: .bold))
                        .foregroundStyle(AppColors.textPrimary)
                        .contentTransition(.numericText())
                        .monospacedDigit()
                }
            }

            Spacer()

            // Sound toggle
            HStack(spacing: 12) {
                VStack(alignment: .trailing, spacing: 2) {
                    Text("Sound")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(AppColors.textSecondary)

                    Text(soundEnabled ? "ON" : "OFF")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(AppColors.primary)
                }

                Button {
                    withAnimation(.spring(response: 0.3)) {
                        soundEnabled.toggle()
                    }

                    let impact = UIImpactFeedbackGenerator(style: .light)
                    impact.impactOccurred()
                } label: {
                    // PiAPI 3D icons already have a white background baked in
                    PiAPIIcon(name: soundEnabled ? PiAPIIcons.soundOn : PiAPIIcons.soundOff, size: 44)
                }
                .accessibilityLabel("Toggle Sound")
                .accessibilityValue(soundEnabled ? "On" : "Off")
                .accessibilityHint("Double-tap to turn clicker sound \(soundEnabled ? "off" : "on")")
            }
        }
        .padding(20)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.08), radius: 20, y: 4)
        .padding(.horizontal, 20)
    }

    @ViewBuilder
    private var actionButtons: some View {
        HStack(spacing: 12) {
            // Reset Button
            Button {
                withAnimation(.spring(response: 0.3)) {
                    sessionClicks = 0
                    sessionSeconds = 0
                }

                let impact = UIImpactFeedbackGenerator(style: .medium)
                impact.impactOccurred()
            } label: {
                HStack(spacing: 8) {
                    PiAPIIcon(name: PiAPIIcons.reset, size: 22)

                    Text("Reset")
                        .font(.system(size: 16, weight: .semibold))
                }
                .foregroundStyle(AppColors.textSecondary)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .overlay {
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color(red: 0.90, green: 0.90, blue: 0.90), lineWidth: 2)
                }
            }
            .accessibilityLabel("Reset Session")
            .accessibilityHint("Double-tap to reset the current session clicks and timer")

            // Save Button
            Button {
                saveSession()
            } label: {
                HStack(spacing: 8) {
                    PiAPIIcon(name: PiAPIIcons.checkmark, size: 22)

                    Text("Save Session")
                        .font(.system(size: 16, weight: .semibold))
                }
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(AppColors.success)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(color: AppColors.success.opacity(0.35), radius: 16, y: 4)
            }
            .accessibilityLabel("Save Session")
            .accessibilityHint("Double-tap to save \(sessionClicks) clicks and end the session")
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 20)
        .padding(.bottom, 40)
    }

    private var formattedTime: String {
        let minutes = sessionSeconds / 60
        let seconds = sessionSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    private func startTimer() {
        timerTask = Task { @MainActor in
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(1))
                if !Task.isCancelled {
                    sessionSeconds += 1
                }
            }
        }
    }

    private func recordClick() {
        withAnimation(.spring(response: 0.2)) {
            sessionClicks += 1
        }

        // Sound
        if soundEnabled {
            AudioServicesPlaySystemSound(1104) // Tick sound
        }
    }

    private func saveSession() {
        // Would save to database
        totalClicks += sessionClicks
        sessionClicks = 0
        sessionSeconds = 0

        let notification = UINotificationFeedbackGenerator()
        notification.notificationOccurred(.success)

        dismiss()
    }
}

#Preview {
    NavigationStack {
        ClickerView()
    }
    .modelContainer(for: Dog.self, inMemory: true)
}
