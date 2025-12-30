import SwiftUI

struct PrimaryButton: View {
    let title: String
    var icon: String?
    var isLoading: Bool = false
    var isDisabled: Bool = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: AppSpacing.sm) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    if let icon {
                        Image(systemName: icon)
                            .font(.body.weight(.semibold))
                    }
                    Text(title)
                        .font(AppFonts.headline())
                }
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(
                isDisabled
                    ? AnyShapeStyle(AppColors.textTertiary)
                    : AnyShapeStyle(AppColors.primaryGradient)
            )
            .clipShape(.rect(cornerRadius: AppRadius.xl))
            .shadow(
                color: isDisabled ? .clear : AppColors.primary.opacity(0.4),
                radius: 12,
                y: 4
            )
        }
        .disabled(isDisabled || isLoading)
    }
}

struct SecondaryButton: View {
    let title: String
    var icon: String?
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: AppSpacing.sm) {
                if let icon {
                    Image(systemName: icon)
                        .font(.body.weight(.semibold))
                }
                Text(title)
                    .font(AppFonts.headline())
            }
            .foregroundStyle(AppColors.textPrimary)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(.white)
            .clipShape(.rect(cornerRadius: AppRadius.lg))
            .overlay(
                RoundedRectangle(cornerRadius: AppRadius.lg)
                    .stroke(AppColors.background, lineWidth: 2)
            )
        }
    }
}

struct SuccessButton: View {
    let title: String
    var icon: String?
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: AppSpacing.sm) {
                if let icon {
                    Image(systemName: icon)
                        .font(.body.weight(.semibold))
                }
                Text(title)
                    .font(AppFonts.headline())
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 64)
            .background(AppColors.success)
            .clipShape(.rect(cornerRadius: AppRadius.lg))
            .shadow(color: AppColors.success.opacity(0.4), radius: 12, y: 4)
        }
    }
}

struct FailButton: View {
    let title: String
    var icon: String?
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: AppSpacing.sm) {
                if let icon {
                    Image(systemName: icon)
                        .font(.body.weight(.semibold))
                }
                Text(title)
                    .font(AppFonts.headline())
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 64)
            .background(Color(red: 0.25, green: 0.25, blue: 0.27))
            .clipShape(.rect(cornerRadius: AppRadius.lg))
        }
    }
}

#Preview {
    VStack(spacing: 16) {
        PrimaryButton(title: "Start Training", icon: "play.fill") {}
        PrimaryButton(title: "Loading...", isLoading: true) {}
        PrimaryButton(title: "Disabled", isDisabled: true) {}
        SecondaryButton(title: "Cancel", icon: "xmark") {}

        HStack(spacing: 16) {
            FailButton(title: "Needs Work", icon: "xmark") {}
            SuccessButton(title: "Success!", icon: "checkmark") {}
        }
    }
    .padding()
    .background(AppColors.background)
}
