import SwiftUI

struct CommandCard: View {
    let command: Command
    let progress: CommandProgress?
    var sessionCount: Int = 0

    private var progressPercentage: Int {
        guard let progress else { return 0 }
        return progress.successRatePercentage
    }

    private var isMastered: Bool {
        guard let progress else { return false }
        return progress.status == .mastered
    }

    private var iconBackgroundColor: Color {
        guard let progress else {
            return Color(red: 0.94, green: 0.94, blue: 0.94)
        }

        switch progress.status {
        case .mastered:
            return AppColors.primary.opacity(0.1)
        case .practicing:
            return AppColors.warning.opacity(0.15)
        case .learning:
            return Color(red: 0.94, green: 0.94, blue: 0.94)
        case .notStarted:
            return Color(red: 0.94, green: 0.94, blue: 0.94)
        }
    }

    private var iconColor: Color {
        guard let progress else {
            return AppColors.textSecondary
        }

        switch progress.status {
        case .mastered:
            return AppColors.primary
        case .practicing:
            return AppColors.warning
        case .learning:
            return AppColors.textSecondary
        case .notStarted:
            return AppColors.textSecondary
        }
    }

    private var difficultyBadge: some View {
        let (text, bgColor, textColor) = difficultyStyle

        return Text(text)
            .font(.system(size: 11, weight: .semibold))
            .textCase(.uppercase)
            .tracking(0.5)
            .padding(.horizontal, 10)
            .padding(.vertical, 3)
            .background(bgColor)
            .foregroundStyle(textColor)
            .clipShape(RoundedRectangle(cornerRadius: 6))
    }

    private var difficultyStyle: (String, Color, Color) {
        switch command.difficulty {
        case .beginner:
            return ("Easy", AppColors.warning.opacity(0.15), AppColors.warning)
        case .intermediate:
            return ("Medium", Color(red: 0.94, green: 0.94, blue: 0.94), AppColors.textSecondary)
        case .advanced:
            return ("Hard", Color.red.opacity(0.1), Color.red)
        }
    }

    private var progressText: String {
        if progressPercentage == 0 && sessionCount == 0 {
            return "Not started"
        }
        return "\(progressPercentage)% • \(sessionCount) sessions"
    }

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            // PiAPI 3D icons already have a white background baked in
            PiAPIIcon(name: command.piAPIIconName, size: 56)

            // Content
            VStack(alignment: .leading, spacing: 0) {
                // Name and badges
                VStack(alignment: .leading, spacing: 6) {
                    Text(command.name)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(AppColors.textPrimary)

                    HStack(spacing: 8) {
                        if isMastered {
                            Text("Mastered")
                                .font(.system(size: 11, weight: .semibold))
                                .textCase(.uppercase)
                                .tracking(0.5)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 3)
                                .background(AppColors.primary.opacity(0.1))
                                .foregroundStyle(AppColors.primary)
                                .clipShape(RoundedRectangle(cornerRadius: 6))
                        }

                        difficultyBadge
                    }
                }

                // Progress bar
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 100)
                            .fill(Color(red: 0.94, green: 0.94, blue: 0.94))
                            .frame(height: 6)

                        RoundedRectangle(cornerRadius: 100)
                            .fill(AppColors.primary)
                            .frame(width: max(0, geometry.size.width * CGFloat(progressPercentage) / 100), height: 6)
                    }
                }
                .frame(height: 6)
                .padding(.top, 12)

                // Progress text
                Text(progressText)
                    .font(.system(size: 13))
                    .foregroundStyle(AppColors.textSecondary)
                    .padding(.top, 6)
            }
        }
        .padding(16)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 3, y: 1)
        .overlay(alignment: .leading) {
            if isMastered {
                RoundedRectangle(cornerRadius: 2)
                    .fill(AppColors.primary)
                    .frame(width: 4)
                    .clipShape(
                        UnevenRoundedRectangle(
                            topLeadingRadius: 16,
                            bottomLeadingRadius: 16,
                            bottomTrailingRadius: 0,
                            topTrailingRadius: 0
                        )
                    )
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(command.name) command, \(command.difficulty.displayName) difficulty, \(progressText)")
        .accessibilityHint("Double-tap to view command details and start training")
    }
}

#Preview {
    VStack(spacing: 12) {
        CommandCard(
            command: Command.allCommands[0],
            progress: {
                let progress = CommandProgress(commandId: "sit")
                progress.practiceCount = 48
                progress.successCount = 48
                progress.statusRawValue = ProgressStatus.mastered.rawValue
                return progress
            }(),
            sessionCount: 48
        )

        CommandCard(
            command: Command.allCommands[1],
            progress: {
                let progress = CommandProgress(commandId: "stay")
                progress.practiceCount = 24
                progress.successCount = 16
                progress.statusRawValue = ProgressStatus.practicing.rawValue
                return progress
            }(),
            sessionCount: 24
        )

        CommandCard(
            command: Command.allCommands[2],
            progress: nil,
            sessionCount: 0
        )
    }
    .padding()
    .background(AppColors.background)
}
