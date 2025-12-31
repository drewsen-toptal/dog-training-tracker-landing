import SwiftUI

struct EmptyStateView: View {
    let iconName: String
    let title: String
    let message: String
    var actionTitle: String? = nil
    var action: (() -> Void)? = nil

    var body: some View {
        VStack(spacing: AppSpacing.lg) {
            PiAPIIcon(name: iconName, size: 80)

            VStack(spacing: AppSpacing.xs) {
                Text(title)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(AppColors.textPrimary)
                    .multilineTextAlignment(.center)

                Text(message)
                    .font(.system(size: 15))
                    .foregroundStyle(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
            }

            if let actionTitle = actionTitle, let action = action {
                Button {
                    action()
                } label: {
                    Text(actionTitle)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 32)
                        .padding(.vertical, 14)
                        .background(AppColors.primaryGradient)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .padding(.top, AppSpacing.sm)
            }
        }
        .padding(AppSpacing.xl)
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    VStack(spacing: 40) {
        EmptyStateView(
            iconName: PiAPIIcons.dogDefault,
            title: "No Dog Added Yet",
            message: "Add your furry friend to start tracking their training progress.",
            actionTitle: "Add Dog"
        ) {
            print("Add dog tapped")
        }

        EmptyStateView(
            iconName: PiAPIIcons.target,
            title: "No Training Data",
            message: "Complete some training sessions to see your progress here."
        )
    }
    .background(AppColors.background)
}
