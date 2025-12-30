import SwiftUI

struct CommandCard: View {
    let command: Command
    let progress: CommandProgress?
    var onTap: (() -> Void)?

    private var progressPercentage: Int {
        guard let progress else { return 0 }
        return progress.successRatePercentage
    }

    private var statusColor: Color {
        guard let progress else { return AppColors.textTertiary }
        switch progress.status {
        case .notStarted: return AppColors.textTertiary
        case .learning: return AppColors.warning
        case .practicing: return AppColors.primary
        case .mastered: return AppColors.success
        }
    }

    var body: some View {
        Button {
            onTap?()
        } label: {
            HStack(spacing: AppSpacing.md) {
                // Command icon
                AsyncImage(url: URL(string: command.iconUrl ?? "")) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    default:
                        ZStack {
                            AppColors.primaryGradient
                            Image(systemName: command.category.iconName)
                                .font(.title2)
                                .foregroundStyle(.white)
                        }
                    }
                }
                .frame(width: 56, height: 56)
                .clipShape(.rect(cornerRadius: AppRadius.md))

                // Command info
                VStack(alignment: .leading, spacing: AppSpacing.xxs) {
                    Text(command.name)
                        .font(AppFonts.headline())
                        .foregroundStyle(AppColors.textPrimary)

                    HStack(spacing: AppSpacing.xs) {
                        // Difficulty badge
                        Text(command.difficulty.displayName)
                            .font(AppFonts.caption())
                            .fontWeight(.semibold)
                            .foregroundStyle(AppColors.warning)
                            .padding(.horizontal, AppSpacing.xs)
                            .padding(.vertical, AppSpacing.xxs)
                            .background(AppColors.warning.opacity(0.15))
                            .clipShape(.rect(cornerRadius: AppRadius.xs))

                        // Category badge
                        Text(command.category.displayName)
                            .font(AppFonts.caption())
                            .fontWeight(.semibold)
                            .foregroundStyle(AppColors.primary)
                            .padding(.horizontal, AppSpacing.xs)
                            .padding(.vertical, AppSpacing.xxs)
                            .background(AppColors.primary.opacity(0.1))
                            .clipShape(.rect(cornerRadius: AppRadius.xs))
                    }
                }

                Spacer()

                // Progress indicator
                if let progress {
                    VStack(alignment: .trailing, spacing: AppSpacing.xxs) {
                        Text("\(progressPercentage)%")
                            .font(AppFonts.headline())
                            .foregroundStyle(statusColor)

                        Text(progress.status.displayName)
                            .font(AppFonts.caption())
                            .foregroundStyle(AppColors.textSecondary)
                    }
                } else {
                    Image(systemName: "chevron.right")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(AppColors.textTertiary)
                }
            }
            .padding(AppSpacing.md)
            .background(.white)
            .clipShape(.rect(cornerRadius: AppRadius.lg))
            .shadow(color: .black.opacity(0.04), radius: 8, y: 2)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    VStack(spacing: 12) {
        CommandCard(
            command: Command.allCommands[1],
            progress: nil
        )

        CommandCard(
            command: Command.allCommands[0],
            progress: nil
        )
    }
    .padding()
    .background(AppColors.background)
}
