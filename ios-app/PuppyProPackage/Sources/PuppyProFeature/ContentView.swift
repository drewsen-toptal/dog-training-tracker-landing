import SwiftUI
import SwiftData
import os.log

private let logger = Logger(subsystem: "com.drewsen.PuppyPro", category: "ContentView")

public struct ContentView: View {
    @Environment(AppState.self) private var appState
    @State private var selectedTab: AppTab = .home
    @State private var showingTrainingSheet = false

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
    }

    @ViewBuilder
    private var mainTabView: some View {
        ZStack(alignment: .bottom) {
            // Content area
            Group {
                switch selectedTab {
                case .home:
                    NavigationStack {
                        HomeView()
                    }
                case .commands:
                    NavigationStack {
                        CommandListView()
                    }
                case .progress:
                    NavigationStack {
                        ProgressDashboardView()
                    }
                case .settings:
                    NavigationStack {
                        SettingsView()
                    }
                }
            }

            // Custom floating tab bar
            CustomTabBar(selectedTab: $selectedTab) {
                showingTrainingSheet = true
            }
        }
        .sheet(isPresented: $showingTrainingSheet) {
            ClickerView()
        }
    }
}

enum AppTab: String, Hashable {
    case home
    case commands
    case progress
    case settings
}

#Preview {
    ContentView()
        .environment(AppState())
        .modelContainer(for: [Dog.self, TrainingSession.self, CommandProgress.self], inMemory: true)
}
