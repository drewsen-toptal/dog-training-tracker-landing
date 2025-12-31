import SwiftUI
import SwiftData
import PuppyProFeature

@main
struct PuppyProApp: App {
    @State private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appState)
        }
        .modelContainer(for: [Dog.self, TrainingSession.self, CommandProgress.self, UserSettings.self])
    }
}
