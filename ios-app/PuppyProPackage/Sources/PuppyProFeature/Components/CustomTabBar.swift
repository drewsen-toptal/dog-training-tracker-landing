import SwiftUI

/// Custom floating tab bar with modern design and SF Symbols
struct CustomTabBar: View {
    @Binding var selectedTab: AppTab
    let onTrainTap: () -> Void

    private let tabs: [(tab: AppTab, icon: String, iconFilled: String, label: String)] = [
        (.home, "house", "house.fill", "Home"),
        (.commands, "list.bullet.clipboard", "list.bullet.clipboard.fill", "Commands"),
        (.progress, "chart.line.uptrend.xyaxis", "chart.line.uptrend.xyaxis", "Progress"),
        (.settings, "gearshape", "gearshape.fill", "Settings")
    ]

    var body: some View {
        VStack(spacing: 0) {
            // Top border line for clear separation
            Rectangle()
                .fill(Color.gray.opacity(0.15))
                .frame(height: 0.5)

            HStack(spacing: 0) {
                // Left side tabs (Home, Commands)
                ForEach(tabs.prefix(2), id: \.tab) { item in
                    TabBarItem(
                        icon: item.icon,
                        iconFilled: item.iconFilled,
                        label: item.label,
                        isSelected: selectedTab == item.tab
                    ) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selectedTab = item.tab
                        }
                    }
                }

                // Center Train button (prominent)
                CenterTrainButton {
                    onTrainTap()
                }

                // Right side tabs (Progress, Settings)
                ForEach(tabs.suffix(2), id: \.tab) { item in
                    TabBarItem(
                        icon: item.icon,
                        iconFilled: item.iconFilled,
                        label: item.label,
                        isSelected: selectedTab == item.tab
                    ) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selectedTab = item.tab
                        }
                    }
                }
            }
            .padding(.top, 8)
            .padding(.bottom, 4)
        }
        .background(tabBarBackground)
    }

    @ViewBuilder
    private var tabBarBackground: some View {
        if #available(iOS 26.0, *) {
            // iOS 26+ Liquid Glass effect
            Rectangle()
                .fill(.clear)
                .glassEffect(.regular, in: .rect)
                .ignoresSafeArea(edges: .bottom)
        } else {
            // Fallback for earlier iOS versions
            Rectangle()
                .fill(.regularMaterial)
                .ignoresSafeArea(edges: .bottom)
        }
    }
}

/// Individual tab bar item with SF Symbols
private struct TabBarItem: View {
    let icon: String
    let iconFilled: String
    let label: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: isSelected ? iconFilled : icon)
                    .font(.system(size: 22, weight: .medium))
                    .foregroundStyle(isSelected ? AppColors.primary : AppColors.textTertiary)
                    .frame(width: 28, height: 28)

                Text(label)
                    .font(.system(size: 10, weight: isSelected ? .semibold : .medium))
                    .foregroundStyle(isSelected ? AppColors.primary : AppColors.textTertiary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 6)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(label)
        .accessibilityAddTraits(isSelected ? [.isButton, .isSelected] : .isButton)
        .accessibilityHint("Double-tap to switch to \(label) tab")
    }
}

/// Center train button with prominent design - uses paw print icon for clarity
private struct CenterTrainButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 2) {
                ZStack {
                    // Main button circle with gradient
                    Circle()
                        .fill(AppColors.primaryGradient)
                        .frame(width: 56, height: 56)
                        .shadow(color: AppColors.primary.opacity(0.35), radius: 8, y: 4)

                    // Paw print icon - clearer for "training"
                    Image(systemName: "pawprint.fill")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundStyle(.white)
                }
                .liquidGlassOverlay()
                .offset(y: -12) // Float slightly above

                Text("Train")
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundStyle(AppColors.primary)
                    .offset(y: -8)
            }
        }
        .buttonStyle(TrainButtonStyle())
        .frame(width: 70)
        .accessibilityLabel("Start Training")
        .accessibilityHint("Double-tap to begin a new training session")
    }
}

/// Extension to add Liquid Glass overlay for iOS 26+
extension View {
    @ViewBuilder
    func liquidGlassOverlay() -> some View {
        if #available(iOS 26.0, *) {
            self.glassEffect(.regular, in: .circle)
        } else {
            self
        }
    }
}

/// Custom button style for the train button
private struct TrainButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.92 : 1.0)
            .animation(.spring(response: 0.2, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

#Preview {
    ZStack(alignment: .bottom) {
        AppColors.background
            .ignoresSafeArea()

        CustomTabBar(selectedTab: .constant(.home)) {
            print("Train tapped")
        }
    }
}
