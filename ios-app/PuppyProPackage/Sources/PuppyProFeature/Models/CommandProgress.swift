import Foundation
import SwiftData

enum ProgressStatus: String, Codable, CaseIterable, Sendable {
    case notStarted = "not_started"
    case learning = "learning"
    case practicing = "practicing"
    case mastered = "mastered"

    var displayName: String {
        switch self {
        case .notStarted: return "Not Started"
        case .learning: return "Learning"
        case .practicing: return "Practicing"
        case .mastered: return "Mastered"
        }
    }

    var progressPercentage: Double {
        switch self {
        case .notStarted: return 0.0
        case .learning: return 0.33
        case .practicing: return 0.66
        case .mastered: return 1.0
        }
    }
}

@Model
public final class CommandProgress {
    public var id: UUID = UUID()
    var commandId: String = ""
    var statusRawValue: String = ProgressStatus.notStarted.rawValue
    var masteredDate: Date?
    var practiceCount: Int = 0
    var successCount: Int = 0
    var lastPracticedDate: Date?
    var nextReviewDate: Date?
    var easeFactor: Double = 2.5
    var interval: Int = 1

    var dog: Dog?

    var status: ProgressStatus {
        get { ProgressStatus(rawValue: statusRawValue) ?? .notStarted }
        set { statusRawValue = newValue.rawValue }
    }

    init(commandId: String = "", dog: Dog? = nil) {
        self.id = UUID()
        self.commandId = commandId
        self.dog = dog
        self.statusRawValue = ProgressStatus.notStarted.rawValue
    }

    var successRate: Double {
        guard practiceCount > 0 else { return 0 }
        return Double(successCount) / Double(practiceCount)
    }

    var successRatePercentage: Int {
        Int(successRate * 100)
    }

    var isDueForReview: Bool {
        guard let nextReview = nextReviewDate else { return status != .notStarted }
        return Date() >= nextReview
    }

    var daysSinceLastPractice: Int? {
        guard let lastPracticed = lastPracticedDate else { return nil }
        let components = Calendar.current.dateComponents([.day], from: lastPracticed, to: Date())
        return components.day
    }

    var daysSinceLastPracticeDescription: String {
        guard let days = daysSinceLastPractice else { return "Never" }
        if days == 0 { return "Today" }
        if days == 1 { return "Yesterday" }
        return "\(days)d ago"
    }

    func recordPractice(wasSuccessful: Bool) {
        practiceCount += 1
        if wasSuccessful {
            successCount += 1
        }
        lastPracticedDate = Date()

        updateSpacedRepetition(wasSuccessful: wasSuccessful)
        updateStatus()
    }

    private func updateSpacedRepetition(wasSuccessful: Bool) {
        if wasSuccessful {
            if interval == 1 {
                interval = 6
            } else {
                interval = Int(Double(interval) * easeFactor)
            }
            easeFactor = max(1.3, easeFactor + 0.1)
        } else {
            interval = 1
            easeFactor = max(1.3, easeFactor - 0.2)
        }

        nextReviewDate = Calendar.current.date(byAdding: .day, value: interval, to: Date())
    }

    private func updateStatus() {
        let rate = successRate

        if rate >= 0.9 && practiceCount >= 20 {
            status = .mastered
            if masteredDate == nil {
                masteredDate = Date()
            }
        } else if rate >= 0.7 && practiceCount >= 10 {
            status = .practicing
        } else if practiceCount >= 3 {
            status = .learning
        }
    }
}
