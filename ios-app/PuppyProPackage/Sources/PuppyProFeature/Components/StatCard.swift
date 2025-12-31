import SwiftUI

struct StatCard: View {
    let title: String
    let value: String
    let iconName: String?
    var valueColor: Color = AppColors.textPrimary

    init(
        title: String,
        value: String,
        iconName: String? = nil,
        valueColor: Color = AppColors.textPrimary
    ) {
        self.title = title
        self.value = value
        self.iconName = iconName
        self.valueColor = valueColor
    }

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            // PiAPI 3D icons already have a white background baked in
            if let iconName {
                PiAPIIcon(name: iconName, size: 40)
            }

            // Value
            Text(value)
                .font(.system(size: 28, weight: .bold))
                .foregroundStyle(valueColor)

            // Title
            Text(title)
                .font(AppFonts.caption())
                .foregroundStyle(AppColors.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(AppSpacing.lg)
        .background(.white)
        .clipShape(.rect(cornerRadius: AppRadius.lg))
        .shadow(color: .black.opacity(0.03), radius: 6, y: 2)
    }
}

struct StatCardRow: View {
    let stats: [(title: String, value: String, iconName: String?)]

    var body: some View {
        HStack(spacing: AppSpacing.md) {
            ForEach(Array(stats.enumerated()), id: \.offset) { _, stat in
                StatCard(
                    title: stat.title,
                    value: stat.value,
                    iconName: stat.iconName
                )
            }
        }
    }
}

#Preview {
    VStack(spacing: 16) {
        HStack(spacing: 16) {
            StatCard(
                title: "Success Rate",
                value: "87%",
                iconName: PiAPIIcons.checkmark,
                valueColor: AppColors.success
            )

            StatCard(
                title: "Day Streak",
                value: "12",
                iconName: PiAPIIcons.fireStreak,
                valueColor: AppColors.warning
            )
        }
    }
    .padding()
    .background(AppColors.background)
}
