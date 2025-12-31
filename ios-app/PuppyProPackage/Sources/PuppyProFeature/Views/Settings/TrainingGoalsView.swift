import SwiftUI
import SwiftData

struct TrainingGoalsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var userSettings: [UserSettings]

    private var settings: UserSettings? {
        userSettings.first
    }

    @State private var selectedGoal: Int = 3

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Premium animated header
                PremiumGoalsHeader()
                    .padding(.bottom, AppSpacing.xl)

                VStack(spacing: AppSpacing.lg) {
                    // Goal selector card
                    goalSelectorCard

                    // Benefits info card
                    benefitsCard
                }
                .padding(.horizontal, AppSpacing.lg)
                .padding(.bottom, 100)
            }
        }
        .background(AppColors.background)
        .navigationTitle("Training Goals")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if let settings = settings {
                selectedGoal = settings.dailyGoal
            }
        }
        .onChange(of: selectedGoal) { _, newValue in
            updateGoal(newValue)
        }
    }

    @ViewBuilder
    private var goalSelectorCard: some View {
        VStack(spacing: AppSpacing.lg) {
            // Current goal display with animation
            VStack(spacing: 4) {
                Text("\(selectedGoal)")
                    .font(.system(size: 72, weight: .bold, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [AppColors.primary, AppColors.primaryDark],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .contentTransition(.numericText())
                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: selectedGoal)

                Text(selectedGoal == 1 ? "session per day" : "sessions per day")
                    .font(.system(size: 17, weight: .medium))
                    .foregroundStyle(AppColors.textSecondary)
            }

            // Premium slider
            VStack(spacing: AppSpacing.sm) {
                // Custom slider track with gradient
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        // Track background
                        RoundedRectangle(cornerRadius: 4)
                            .fill(AppColors.textTertiary.opacity(0.2))
                            .frame(height: 8)

                        // Filled track
                        RoundedRectangle(cornerRadius: 4)
                            .fill(
                                LinearGradient(
                                    colors: [AppColors.primary, AppColors.primaryDark],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: geometry.size.width * CGFloat(selectedGoal - 1) / 9, height: 8)
                    }
                }
                .frame(height: 8)
                .padding(.horizontal, 4)

                Slider(
                    value: Binding(
                        get: { Double(selectedGoal) },
                        set: { selectedGoal = Int($0) }
                    ),
                    in: 1...10,
                    step: 1
                )
                .tint(AppColors.primary)

                HStack {
                    Text("1")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(AppColors.textTertiary)
                    Spacer()
                    Text("10")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(AppColors.textTertiary)
                }
            }
            .padding(.horizontal, AppSpacing.md)
        }
        .padding(AppSpacing.xl)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(.white)
                .shadow(color: AppColors.primary.opacity(0.08), radius: 20, y: 6)
        )
    }

    @ViewBuilder
    private var benefitsCard: some View {
        VStack(alignment: .leading, spacing: AppSpacing.lg) {
            HStack(spacing: AppSpacing.sm) {
                ZStack {
                    Circle()
                        .fill(AppColors.success.opacity(0.12))
                        .frame(width: 36, height: 36)

                    Image(systemName: "star.fill")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(AppColors.success)
                }

                Text("Tips for Success")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(AppColors.textPrimary)
            }

            VStack(spacing: AppSpacing.md) {
                benefitRow(
                    icon: "clock.fill",
                    color: AppColors.warning,
                    title: "Keep sessions short",
                    description: "5-10 minutes is ideal for most dogs"
                )

                benefitRow(
                    icon: "arrow.triangle.2.circlepath",
                    color: AppColors.primary,
                    title: "Be consistent",
                    description: "Daily practice builds lasting habits"
                )

                benefitRow(
                    icon: "trophy.fill",
                    color: AppColors.success,
                    title: "End on success",
                    description: "Always finish with a command your dog knows"
                )
            }
        }
        .padding(AppSpacing.lg)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.white)
                .shadow(color: AppColors.primary.opacity(0.08), radius: 16, y: 4)
        )
    }

    @ViewBuilder
    private func benefitRow(icon: String, color: Color, title: String, description: String) -> some View {
        HStack(alignment: .top, spacing: AppSpacing.md) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.12))
                    .frame(width: 40, height: 40)

                Image(systemName: icon)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(color)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(AppColors.textPrimary)

                Text(description)
                    .font(.system(size: 13))
                    .foregroundStyle(AppColors.textSecondary)
            }

            Spacer()
        }
    }

    private func updateGoal(_ newGoal: Int) {
        if let settings = settings {
            settings.dailyGoal = newGoal
        } else {
            let newSettings = UserSettings()
            newSettings.dailyGoal = newGoal
            modelContext.insert(newSettings)
        }
    }
}

// MARK: - Premium Animated Header

private struct PremiumGoalsHeader: View {
    @State private var isFloating = false
    @State private var iconScale: CGFloat = 0.5
    @State private var iconOffset: CGFloat = 30
    @State private var textOpacity: Double = 0
    @State private var textOffset: CGFloat = 20

    var body: some View {
        VStack(spacing: 20) {
            // Animated icon with premium rings
            ZStack {
                // Outer pulsing ring
                Circle()
                    .fill(AppColors.primary.opacity(0.08))
                    .frame(width: 160, height: 160)
                    .scaleEffect(isFloating ? 1.05 : 0.95)
                    .animation(
                        .easeInOut(duration: 2.0)
                        .repeatForever(autoreverses: true),
                        value: isFloating
                    )

                // Middle ring
                Circle()
                    .fill(AppColors.primary.opacity(0.12))
                    .frame(width: 130, height: 130)
                    .scaleEffect(iconScale)

                // Inner ring
                Circle()
                    .fill(AppColors.primary.opacity(0.18))
                    .frame(width: 100, height: 100)
                    .scaleEffect(iconScale)

                // Target icon with bounce and float
                PiAPIIcon(name: PiAPIIcons.target, size: 56)
                    .scaleEffect(iconScale)
                    .offset(y: iconOffset + (isFloating ? -6 : 0))
            }
            .animation(
                .easeInOut(duration: 1.5)
                .repeatForever(autoreverses: true),
                value: isFloating
            )

            // Premium text
            VStack(spacing: 8) {
                Text("Daily Session Goal")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundStyle(AppColors.textPrimary)

                Text("Set how many training sessions\nyou want to complete each day")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
            }
            .opacity(textOpacity)
            .offset(y: textOffset)
        }
        .padding(.top, AppSpacing.xl)
        .onAppear {
            startEntranceAnimation()
        }
    }

    private func startEntranceAnimation() {
        // Icon bounces in
        withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
            iconScale = 1.0
            iconOffset = 0
        }

        // Text fades up after icon
        withAnimation(.easeOut(duration: 0.5).delay(0.2)) {
            textOpacity = 1.0
            textOffset = 0
        }

        // Start floating animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            isFloating = true
        }
    }
}

#Preview {
    NavigationStack {
        TrainingGoalsView()
    }
    .modelContainer(for: UserSettings.self, inMemory: true)
}
