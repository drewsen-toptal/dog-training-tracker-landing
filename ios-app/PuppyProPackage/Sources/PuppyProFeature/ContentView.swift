import SwiftUI
import SwiftData

public struct ContentView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @State private var selectedTab: AppTab = .home

    public init() {}

    public var body: some View {
        if hasCompletedOnboarding {
            mainTabView
        } else {
            OnboardingView(hasCompletedOnboarding: $hasCompletedOnboarding)
        }
    }

    @ViewBuilder
    private var mainTabView: some View {
        TabView(selection: $selectedTab) {
            Tab("Home", systemImage: "house.fill", value: .home) {
                HomeView()
            }

            Tab("Commands", systemImage: "list.bullet.rectangle.fill", value: .commands) {
                NavigationStack {
                    CommandListView()
                }
            }

            Tab("Clicker", systemImage: "hand.tap.fill", value: .clicker) {
                NavigationStack {
                    ClickerView()
                }
            }

            Tab("Progress", systemImage: "chart.bar.fill", value: .progress) {
                ProgressDashboardView()
            }

            Tab("Settings", systemImage: "gearshape.fill", value: .settings) {
                NavigationStack {
                    SettingsView()
                }
            }
        }
        .tint(AppColors.primary)
    }
}

enum AppTab: String, Hashable {
    case home
    case commands
    case clicker
    case progress
    case settings
}

#Preview {
    ContentView()
        .modelContainer(for: [Dog.self, TrainingSession.self, CommandProgress.self], inMemory: true)
}
