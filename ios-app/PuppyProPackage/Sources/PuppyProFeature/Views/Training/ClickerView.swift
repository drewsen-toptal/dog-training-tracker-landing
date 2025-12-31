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
    @State private var showingSuccessAnimation = false

    private var currentDog: Dog? {
        dogs.first
    }

    var body: some View {
        ZStack {
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
            .contentMargins(.bottom, 80, for: .scrollContent)
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

            // Success animation overlay
            if showingSuccessAnimation {
                SuccessAnimationView(message: "Session Saved!") {
                    dismiss()
                }
                .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: showingSuccessAnimation)
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
        VStack(spacing: 0) {
            // Navigation row
            HStack {
                // Back button - pill style for better touch target
                Button {
                    dismiss()
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .semibold))
                        Text("Back")
                            .font(.system(size: 17, weight: .medium))
                    }
                    .foregroundStyle(AppColors.primary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(AppColors.primary.opacity(0.12))
                    .clipShape(Capsule())
                }
                .accessibilityLabel("Go Back")
                .accessibilityHint("Double-tap to close clicker and return to previous screen")

                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)

            // Title section with dog avatar
            HStack(spacing: 16) {
                // Dog avatar
                if let dog = currentDog {
                    DogAvatar(
                        name: dog.name,
                        breed: dog.breed,
                        imageData: dog.photoData,
                        size: 56
                    )
                } else {
                    ZStack {
                        Circle()
                            .fill(AppColors.primary.opacity(0.15))
                            .frame(width: 56, height: 56)
                        Image(systemName: "dog.fill")
                            .font(.system(size: 24))
                            .foregroundStyle(AppColors.primary)
                    }
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text("Clicker Training")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(AppColors.textPrimary)

                    HStack(spacing: 6) {
                        Circle()
                            .fill(AppColors.success)
                            .frame(width: 8, height: 8)
                        Text("Session active with \(currentDog?.name ?? "your pup")")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(AppColors.textSecondary)
                    }
                }

                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, AppSpacing.md)
        }
        .safeAreaPadding(.top)
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
        .padding(.top, 16)
        .padding(.bottom, 24)
        .safeAreaPadding(.bottom)
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
        // Save to database
        totalClicks += sessionClicks
        sessionClicks = 0
        sessionSeconds = 0

        let notification = UINotificationFeedbackGenerator()
        notification.notificationOccurred(.success)

        // Show success animation with Lottie checkmark
        showingSuccessAnimation = true
    }
}

#Preview {
    NavigationStack {
        ClickerView()
    }
    .modelContainer(for: Dog.self, inMemory: true)
}
