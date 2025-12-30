import SwiftUI

struct StatCard: View {
    let title: String
    let value: String
    let iconUrl: String?
    let iconSystemName: String?
    var valueColor: Color = AppColors.textPrimary

    init(
        title: String,
        value: String,
        iconUrl: String? = nil,
        iconSystemName: String? = nil,
        valueColor: Color = AppColors.textPrimary
    ) {
        self.title = title
        self.value = value
        self.iconUrl = iconUrl
        self.iconSystemName = iconSystemName
        self.valueColor = valueColor
    }

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            // Icon
            Group {
                if let iconUrl, let url = URL(string: iconUrl) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        default:
                            iconPlaceholder
                        }
                    }
                } else {
                    iconPlaceholder
                }
            }
            .frame(width: 40, height: 40)
            .clipShape(.rect(cornerRadius: AppRadius.sm))

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

    @ViewBuilder
    private var iconPlaceholder: some View {
        ZStack {
            AppColors.primary.opacity(0.1)
            if let systemName = iconSystemName {
                Image(systemName: systemName)
                    .font(.title3)
                    .foregroundStyle(AppColors.primary)
            }
        }
    }
}

struct StatCardRow: View {
    let stats: [(title: String, value: String, icon: String?, systemIcon: String?)]

    var body: some View {
        HStack(spacing: AppSpacing.md) {
            ForEach(Array(stats.enumerated()), id: \.offset) { _, stat in
                StatCard(
                    title: stat.title,
                    value: stat.value,
                    iconUrl: stat.icon,
                    iconSystemName: stat.systemIcon
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
                iconSystemName: "checkmark.circle.fill",
                valueColor: AppColors.success
            )

            StatCard(
                title: "Day Streak",
                value: "12",
                iconSystemName: "flame.fill",
                valueColor: AppColors.warning
            )
        }
    }
    .padding()
    .background(AppColors.background)
}
