import SwiftUI
import AVFoundation

struct ClickerView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var totalClicks = 247 // Would come from UserDefaults or database
    @State private var sessionClicks = 0
    @State private var sessionSeconds = 0
    @State private var timerTask: Task<Void, Never>?
    @State private var soundEnabled = true

    var body: some View {
        ZStack {
            // Light background
            AppColors.background
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                headerView

                // Counter section
                counterSection

                // Clicker area
                Spacer()

                clickerArea

                Spacer()

                // Session card
                sessionCard

                // Action buttons
                actionButtons
            }
        }
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
            VStack(alignment: .leading, spacing: 2) {
                Text("Clicker")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(AppColors.textPrimary)

                Text("Training Max")
                    .font(AppFonts.subheadline())
                    .foregroundStyle(AppColors.textSecondary)
            }

            Spacer()

            Button {
                // Settings
            } label: {
                Image(systemName: "gearshape.fill")
                    .font(.title3)
                    .foregroundStyle(AppColors.textSecondary)
                    .frame(width: 44, height: 44)
                    .background(.white)
                    .clipShape(.rect(cornerRadius: AppRadius.md))
                    .shadow(color: .black.opacity(0.08), radius: 8, y: 2)
            }
        }
        .padding(.horizontal, AppSpacing.lg)
        .padding(.top, AppSpacing.sm)
        .padding(.bottom, AppSpacing.lg)
    }

    @ViewBuilder
    private var counterSection: some View {
        VStack(spacing: AppSpacing.xs) {
            Text("TOTAL CLICKS")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(AppColors.textSecondary)
                .tracking(1)

            Text("\(totalClicks + sessionClicks)")
                .font(.system(size: 80, weight: .bold))
                .foregroundStyle(AppColors.textPrimary)
                .contentTransition(.numericText())

            Text("This session: \(sessionClicks) clicks")
                .font(AppFonts.subheadline())
                .foregroundStyle(AppColors.textTertiary)
        }
        .padding(.vertical, AppSpacing.xl)
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
            HStack(spacing: AppSpacing.sm) {
                ZStack {
                    AppColors.primary.opacity(0.1)
                    Image(systemName: "clock.fill")
                        .foregroundStyle(AppColors.primary)
                }
                .frame(width: 44, height: 44)
                .clipShape(.rect(cornerRadius: AppRadius.sm))

                VStack(alignment: .leading, spacing: 2) {
                    Text("Session Time")
                        .font(AppFonts.caption())
                        .foregroundStyle(AppColors.textSecondary)

                    Text(formattedTime)
                        .font(.title2.weight(.bold))
                        .foregroundStyle(AppColors.textPrimary)
                        .contentTransition(.numericText())
                }
            }

            Spacer()

            // Sound toggle
            HStack(spacing: AppSpacing.sm) {
                VStack(alignment: .trailing, spacing: 2) {
                    Text("Sound")
                        .font(AppFonts.caption())
                        .foregroundStyle(AppColors.textSecondary)

                    Text(soundEnabled ? "ON" : "OFF")
                        .font(AppFonts.subheadline())
                        .fontWeight(.semibold)
                        .foregroundStyle(AppColors.primary)
                }

                Button {
                    soundEnabled.toggle()
                } label: {
                    ZStack {
                        AppColors.primary.opacity(0.1)
                        Image(systemName: soundEnabled ? "speaker.wave.2.fill" : "speaker.slash.fill")
                            .foregroundStyle(AppColors.primary)
                    }
                    .frame(width: 44, height: 44)
                    .clipShape(.rect(cornerRadius: AppRadius.sm))
                }
            }
        }
        .padding(AppSpacing.lg)
        .background(.white)
        .clipShape(.rect(cornerRadius: AppRadius.lg))
        .shadow(color: .black.opacity(0.08), radius: 12, y: 4)
        .padding(.horizontal, AppSpacing.lg)
    }

    @ViewBuilder
    private var actionButtons: some View {
        HStack(spacing: AppSpacing.sm) {
            SecondaryButton(title: "Reset", icon: "arrow.counterclockwise") {
                sessionClicks = 0
                sessionSeconds = 0
            }

            PrimaryButton(title: "Save Session", icon: "checkmark") {
                saveSession()
            }
        }
        .padding(.horizontal, AppSpacing.lg)
        .padding(.vertical, AppSpacing.lg)
        .padding(.bottom, AppSpacing.xl)
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

        // Haptic
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()

        // Sound would play here if enabled
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
}
