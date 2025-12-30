import SwiftUI
import SwiftData
import PuppyProFeature

@main
struct PuppyProApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Dog.self, TrainingSession.self, CommandProgress.self, UserSettings.self])
    }
}
