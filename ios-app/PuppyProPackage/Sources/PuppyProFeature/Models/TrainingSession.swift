import Foundation
import SwiftData

@Model
public final class TrainingSession {
    public var id: UUID = UUID()
    var startTime: Date = Date()
    var endTime: Date?
    var durationSeconds: Int = 0
    var notes: String?
    var rating: Int?
    var commandsPracticed: [String] = []
    var successCount: Int = 0
    var totalReps: Int = 0

    var dog: Dog?

    init(dog: Dog? = nil, commandIds: [String] = []) {
        self.id = UUID()
        self.dog = dog
        self.startTime = Date()
        self.commandsPracticed = commandIds
    }

    var isComplete: Bool {
        endTime != nil
    }

    var successRate: Double {
        guard totalReps > 0 else { return 0 }
        return Double(successCount) / Double(totalReps)
    }

    var successRatePercentage: Int {
        Int(successRate * 100)
    }

    var formattedDuration: String {
        let minutes = durationSeconds / 60
        let seconds = durationSeconds % 60
        return String(format: "%d:%02d", minutes, seconds)
    }

    func endSession(notes: String? = nil, rating: Int? = nil) {
        self.endTime = Date()
        self.notes = notes
        self.rating = rating

        if let start = Calendar.current.dateComponents([.second], from: startTime, to: endTime ?? Date()).second {
            self.durationSeconds = start
        }
    }

    func recordRep(wasSuccessful: Bool) {
        totalReps += 1
        if wasSuccessful {
            successCount += 1
        }
    }
}
