import Foundation
import SwiftData

@Model
public final class UserSettings {
    public var id: UUID = UUID()
    var hapticEnabled: Bool = true
    var clickerSound: String = "classic"
    var clickerVolume: Double = 0.8
    var defaultSessionDuration: Int = 300
    var dailyReminderEnabled: Bool = true
    var dailyReminderTime: Date?
    var currentStreak: Int = 0
    var longestStreak: Int = 0
    var lastTrainingDate: Date?
    var dailyGoal: Int = 3
    var hasCompletedOnboarding: Bool = false

    init() {
        self.id = UUID()
        self.dailyReminderTime = Calendar.current.date(bySettingHour: 9, minute: 0, second: 0, of: Date())
    }

    var streakIsActive: Bool {
        guard let lastDate = lastTrainingDate else { return false }
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let lastTrainedDay = calendar.startOfDay(for: lastDate)
        let daysSince = calendar.dateComponents([.day], from: lastTrainedDay, to: today).day ?? 0
        return daysSince <= 1
    }

    func recordTrainingSession() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        if let lastDate = lastTrainingDate {
            let lastTrainedDay = calendar.startOfDay(for: lastDate)
            let daysSince = calendar.dateComponents([.day], from: lastTrainedDay, to: today).day ?? 0

            if daysSince == 0 {
                return
            } else if daysSince == 1 {
                currentStreak += 1
            } else {
                currentStreak = 1
            }
        } else {
            currentStreak = 1
        }

        lastTrainingDate = Date()
        longestStreak = max(longestStreak, currentStreak)
    }
}

enum ClickerSoundType: String, CaseIterable, Identifiable {
    case classic = "classic"
    case soft = "soft"
    case whistle = "whistle"
    case beep = "beep"
    case chime = "chime"
    case silent = "silent"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .classic: return "Classic Click"
        case .soft: return "Soft Click"
        case .whistle: return "Whistle Short"
        case .beep: return "Beep"
        case .chime: return "Chime"
        case .silent: return "Silent (Haptic Only)"
        }
    }
}
