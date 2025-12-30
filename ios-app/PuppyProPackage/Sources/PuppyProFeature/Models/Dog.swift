import Foundation
import SwiftData

@Model
public final class Dog {
    public var id: UUID = UUID()
    var name: String = ""
    var breed: String?
    var birthDate: Date?
    var weight: Double?
    var photoData: Data?
    var createdAt: Date = Date()
    var updatedAt: Date = Date()

    @Relationship(deleteRule: .cascade, inverse: \CommandProgress.dog)
    var commandProgress: [CommandProgress]?

    @Relationship(deleteRule: .cascade, inverse: \TrainingSession.dog)
    var trainingSessions: [TrainingSession]?

    init(
        name: String = "",
        breed: String? = nil,
        birthDate: Date? = nil,
        weight: Double? = nil,
        photoData: Data? = nil
    ) {
        self.id = UUID()
        self.name = name
        self.breed = breed
        self.birthDate = birthDate
        self.weight = weight
        self.photoData = photoData
        self.createdAt = Date()
        self.updatedAt = Date()
    }

    var ageInMonths: Int? {
        guard let birthDate else { return nil }
        let components = Calendar.current.dateComponents([.month], from: birthDate, to: Date())
        return components.month
    }

    var ageDescription: String {
        guard let months = ageInMonths else { return "Unknown age" }
        if months < 12 {
            return "\(months) month\(months == 1 ? "" : "s")"
        } else {
            let years = months / 12
            let remainingMonths = months % 12
            if remainingMonths == 0 {
                return "\(years) year\(years == 1 ? "" : "s")"
            }
            return "\(years)y \(remainingMonths)m"
        }
    }

    var masteredCommandsCount: Int {
        commandProgress?.filter { $0.status == .mastered }.count ?? 0
    }

    var totalSessionsCount: Int {
        trainingSessions?.count ?? 0
    }
}
