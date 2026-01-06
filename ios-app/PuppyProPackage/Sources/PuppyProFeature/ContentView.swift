import SwiftUI
import SwiftData
import UIKit
import os.log

private let logger = Logger(subsystem: "com.drewsen.PuppyPro", category: "ContentView")

public struct ContentView: View {
    @Environment(AppState.self) private var appState
    @State private var selectedTab: AppTab = .home
    @State private var showingTrainingSheet = false
    @State private var subscriptionManager = SubscriptionManager()

    public init() {
        logger.info("🏠 ContentView init() called")
    }

    public var body: some View {
        Group {
            if appState.hasCompletedOnboarding {
                mainTabView
            } else {
                OnboardingView()
            }
        }
        .environment(subscriptionManager)
    }

    @ViewBuilder
    private var mainTabView: some View {
        ZStack(alignment: .bottom) {
            // Content area - extends to bottom edge with liquid glass transitions
            Group {
                switch selectedTab {
                case .home:
                    NavigationStack {
                        HomeView()
                    }
                    .transition(liquidGlassTransition)
                case .commands:
                    NavigationStack {
                        CommandListView()
                    }
                    .transition(liquidGlassTransition)
                case .progress:
                    NavigationStack {
                        ProgressDashboardView()
                    }
                    .transition(liquidGlassTransition)
                case .settings:
                    NavigationStack {
                        SettingsView()
                    }
                    .transition(liquidGlassTransition)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .animation(.spring(response: 0.35, dampingFraction: 0.86), value: selectedTab)

            // Custom Cal AI style tab bar floating over content
            CalAIStyleTabBar(
                selectedTab: $selectedTab,
                onTrainTap: { showingTrainingSheet = true }
            )
        }
        .ignoresSafeArea(edges: .bottom)
        .sheet(isPresented: $showingTrainingSheet) {
            ClickerView()
        }
    }

    private var liquidGlassTransition: AnyTransition {
        .asymmetric(
            insertion: .opacity.combined(with: .scale(scale: 0.96)).combined(with: .offset(y: 8)),
            removal: .opacity.combined(with: .scale(scale: 1.02))
        )
    }
}

enum AppTab: String, Hashable {
    case home
    case commands
    case progress
    case settings
}

/// Cal AI style tab bar with tabs on left and FAB on right
private struct CalAIStyleTabBar: View {
    @Binding var selectedTab: AppTab
    let onTrainTap: () -> Void
    @Namespace private var glassNamespace // For Liquid Glass morphing

    private let tabs: [(tab: AppTab, icon: String, iconFilled: String, label: String)] = [
        (.home, "house", "house.fill", "Home"),
        (.commands, "list.bullet.clipboard", "list.bullet.clipboard.fill", "Commands"),
        (.progress, "chart.line.uptrend.xyaxis", "chart.line.uptrend.xyaxis", "Progress"),
        (.settings, "gearshape", "gearshape.fill", "Settings")
    ]

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                // Tab items with Liquid Glass morphing effect
                tabBarContent
                    .padding(.horizontal, 8)
                    .padding(.vertical, 8)
                    .background(tabBarPillBackground)

                // Train FAB on the right
                TrainFloatingButton(action: onTrainTap)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 8)
        }
        .padding(.bottom, 20) // Safe area padding
        .background(Color.clear)
    }

    @ViewBuilder
    private var tabBarContent: some View {
        if #available(iOS 26.0, *) {
            // iOS 26+ with Liquid Glass sliding pill
            HStack(spacing: 0) {
                ForEach(tabs, id: \.tab) { item in
                    Button {
                        let impact = UIImpactFeedbackGenerator(style: .light)
                        impact.impactOccurred()

                        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                            selectedTab = item.tab
                        }
                    } label: {
                        VStack(spacing: 4) {
                            Image(systemName: selectedTab == item.tab ? item.iconFilled : item.icon)
                                .font(.system(size: 20, weight: .medium))
                                .foregroundStyle(selectedTab == item.tab ? AppColors.primary : AppColors.textTertiary)
                                .frame(width: 24, height: 24)

                            Text(item.label)
                                .font(.system(size: 10, weight: selectedTab == item.tab ? .semibold : .medium))
                                .foregroundStyle(selectedTab == item.tab ? AppColors.primary : AppColors.textTertiary)
                        }
                        .frame(width: 64)
                        .padding(.vertical, 8)
                        .background {
                            if selectedTab == item.tab {
                                // Single Liquid Glass pill - only on selected tab
                                Capsule()
                                    .fill(.ultraThinMaterial)
                                    .glassEffect(.regular, in: .capsule)
                                    .matchedGeometryEffect(id: "ACTIVETAB", in: glassNamespace)
                                    .shadow(color: .black.opacity(0.08), radius: 4, y: 2)
                            }
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
        } else {
            // Fallback for iOS < 26 with matchedGeometryEffect
            HStack(spacing: 0) {
                ForEach(tabs, id: \.tab) { item in
                    Button {
                        let impact = UIImpactFeedbackGenerator(style: .light)
                        impact.impactOccurred()

                        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                            selectedTab = item.tab
                        }
                    } label: {
                        VStack(spacing: 4) {
                            Image(systemName: selectedTab == item.tab ? item.iconFilled : item.icon)
                                .font(.system(size: 20, weight: .medium))
                                .foregroundStyle(selectedTab == item.tab ? AppColors.primary : AppColors.textTertiary)
                                .frame(width: 24, height: 24)

                            Text(item.label)
                                .font(.system(size: 10, weight: selectedTab == item.tab ? .semibold : .medium))
                                .foregroundStyle(selectedTab == item.tab ? AppColors.primary : AppColors.textTertiary)
                        }
                        .frame(width: 64)
                        .padding(.vertical, 8)
                        .background {
                            if selectedTab == item.tab {
                                Capsule()
                                    .fill(.ultraThinMaterial)
                                    .matchedGeometryEffect(id: "ACTIVETAB", in: glassNamespace)
                                    .shadow(color: .black.opacity(0.1), radius: 5, y: 3)
                            }
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    @ViewBuilder
    private var tabBarPillBackground: some View {
        if #available(iOS 26.0, *) {
            Capsule()
                .fill(.ultraThinMaterial)
                .glassEffect(.regular, in: .capsule)
                .shadow(color: Color.black.opacity(0.08), radius: 8, y: 2)
        } else {
            Capsule()
                .fill(.ultraThinMaterial)
                .shadow(color: Color.black.opacity(0.08), radius: 8, y: 2)
        }
    }
}

/// Cal AI style floating Train button
private struct TrainFloatingButton: View {
    let action: () -> Void

    var body: some View {
        Button {
            // Haptic feedback
            let impact = UIImpactFeedbackGenerator(style: .medium)
            impact.impactOccurred()
            action()
        } label: {
            ZStack {
                Circle()
                    .fill(AppColors.primary)
                    .frame(width: 56, height: 56)
                    .shadow(color: Color.black.opacity(0.15), radius: 8, y: 4)

                Image(systemName: "pawprint.fill")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundStyle(.white)
            }
        }
        .buttonStyle(TrainButtonStyle())
        .accessibilityLabel("Start Training")
        .accessibilityHint("Double-tap to begin a new training session")
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
    ContentView()
        .environment(AppState())
        .modelContainer(for: [Dog.self, TrainingSession.self, CommandProgress.self], inMemory: true)
}
