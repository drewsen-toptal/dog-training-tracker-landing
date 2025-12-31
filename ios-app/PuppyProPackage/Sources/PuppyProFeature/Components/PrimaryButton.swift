import SwiftUI

struct PrimaryButton: View {
    let title: String
    var iconName: String?
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
                    if let iconName {
                        PiAPIIcon(name: iconName, size: 24, clipToCircle: true)
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
        .accessibilityLabel(isLoading ? "Loading" : title)
        .accessibilityAddTraits(isDisabled ? .isButton : [.isButton])
    }
}

struct SecondaryButton: View {
    let title: String
    var iconName: String?
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: AppSpacing.sm) {
                if let iconName {
                    PiAPIIcon(name: iconName, size: 24, clipToCircle: true)
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
    var iconName: String?
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: AppSpacing.sm) {
                if let iconName {
                    PiAPIIcon(name: iconName, size: 26, clipToCircle: true)
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
        .accessibilityLabel(title)
        .accessibilityHint("Records a successful training attempt")
    }
}

struct FailButton: View {
    let title: String
    var iconName: String?
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: AppSpacing.sm) {
                if let iconName {
                    PiAPIIcon(name: iconName, size: 26, clipToCircle: true)
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
        .accessibilityLabel(title)
        .accessibilityHint("Records an attempt that needs more practice")
    }
}

#Preview {
    VStack(spacing: 16) {
        PrimaryButton(title: "Start Training", iconName: PiAPIIcons.play) {}
        PrimaryButton(title: "Loading...", isLoading: true) {}
        PrimaryButton(title: "Disabled", isDisabled: true) {}
        SecondaryButton(title: "Cancel", iconName: PiAPIIcons.close) {}

        HStack(spacing: 16) {
            FailButton(title: "Needs Work", iconName: PiAPIIcons.close) {}
            SuccessButton(title: "Success!", iconName: PiAPIIcons.checkmark) {}
        }
    }
    .padding()
    .background(AppColors.background)
}
