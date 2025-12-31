import Foundation

enum CommandCategory: String, Codable, CaseIterable, Identifiable {
    case basics
    case manners
    case tricks
    case advanced

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .basics: return "Basics"
        case .manners: return "Manners"
        case .tricks: return "Tricks"
        case .advanced: return "Advanced"
        }
    }

    var iconName: String {
        switch self {
        case .basics: return "star.fill"
        case .manners: return "hand.raised.fill"
        case .tricks: return "sparkles"
        case .advanced: return "trophy.fill"
        }
    }
}

enum Difficulty: String, Codable, CaseIterable {
    case beginner
    case intermediate
    case advanced

    var displayName: String {
        switch self {
        case .beginner: return "Easy"
        case .intermediate: return "Medium"
        case .advanced: return "Hard"
        }
    }

    var color: String {
        switch self {
        case .beginner: return "success"
        case .intermediate: return "warning"
        case .advanced: return "error"
        }
    }
}

enum VoiceTone: String, Codable {
    case firm
    case excited
    case calm
    case gentle

    var displayName: String {
        switch self {
        case .firm: return "Firm"
        case .excited: return "Excited"
        case .calm: return "Calm"
        case .gentle: return "Gentle"
        }
    }

    var icon: String {
        switch self {
        case .firm: return "speaker.wave.3.fill"
        case .excited: return "star.fill"
        case .calm: return "leaf.fill"
        case .gentle: return "heart.fill"
        }
    }

    var tip: String {
        switch self {
        case .firm: return "Use a clear, confident voice"
        case .excited: return "Sound happy and enthusiastic!"
        case .calm: return "Keep your voice low and steady"
        case .gentle: return "Use a soft, encouraging tone"
        }
    }
}

struct HandSignal: Codable {
    let name: String
    let description: String
    let icon: String  // SF Symbol name
}

struct TrainingStep: Codable, Identifiable {
    let order: Int
    let instruction: String
    let duration: String?
    let tip: String?

    var id: Int { order }
}

struct Command: Codable, Identifiable {
    let id: String
    let name: String
    let category: CommandCategory
    let difficulty: Difficulty
    let estimatedDays: Int
    let description: String
    let steps: [TrainingStep]
    let tips: [String]
    let commonMistakes: [String]
    let prerequisites: [String]?
    let youtubeVideoId: String?

    /// Required subscription tier for this command
    var requiredTier: SubscriptionTier {
        // Free tier: Sit, Stay, Come (3 basic commands)
        let freeCommands = ["sit", "stay", "come"]
        if freeCommands.contains(id) {
            return .free
        }

        // Good Boy tier: +Down, Heel, Wait (6 total commands)
        let goodBoyCommands = ["down", "heel", "wait"]
        if goodBoyCommands.contains(id) {
            return .goodBoy
        }

        // Best Friend tier: All remaining commands
        return .bestFriend
    }

    /// Check if a subscription tier can access this command
    func isAccessible(with tier: SubscriptionTier) -> Bool {
        return tier.level >= requiredTier.level
    }

    var youtubeUrl: URL? {
        guard let videoId = youtubeVideoId else { return nil }
        return URL(string: "https://www.youtube.com/watch?v=\(videoId)")
    }

    var youtubeEmbedUrl: URL? {
        guard let videoId = youtubeVideoId else { return nil }
        return URL(string: "https://www.youtube.com/embed/\(videoId)")
    }

    /// Hand signal for this command
    var handSignal: HandSignal {
        switch id {
        case "sit":
            return HandSignal(name: "Palm Up", description: "Raise your palm upward", icon: "hand.raised.fill")
        case "stay":
            return HandSignal(name: "Stop Hand", description: "Open palm facing dog", icon: "hand.raised.fill")
        case "down":
            return HandSignal(name: "Palm Down", description: "Point finger down to ground", icon: "hand.point.down.fill")
        case "come":
            return HandSignal(name: "Arm Sweep", description: "Sweep arm toward your body", icon: "arrow.turn.down.left")
        case "heel":
            return HandSignal(name: "Pat Thigh", description: "Pat your left thigh", icon: "figure.walk")
        case "leave_it":
            return HandSignal(name: "Closed Fist", description: "Close your fist firmly", icon: "hand.raised.slash.fill")
        case "drop_it":
            return HandSignal(name: "Open Palm", description: "Hold open palm under mouth", icon: "hand.palm.facing.fill")
        case "wait":
            return HandSignal(name: "Stop Signal", description: "Flat hand like stop sign", icon: "hand.raised.fill")
        case "watch_me":
            return HandSignal(name: "Point to Eyes", description: "Point two fingers at your eyes", icon: "eye.fill")
        case "place":
            return HandSignal(name: "Point", description: "Point to the designated spot", icon: "hand.point.right.fill")
        case "shake":
            return HandSignal(name: "Offer Hand", description: "Extend your hand palm-up", icon: "hand.wave.fill")
        case "spin":
            return HandSignal(name: "Circle Finger", description: "Make circular motion with finger", icon: "arrow.trianglehead.2.clockwise.rotate.90")
        default:
            return HandSignal(name: "Verbal Only", description: "Use voice command", icon: "waveform")
        }
    }

    /// Recommended voice tone for this command
    var voiceTone: VoiceTone {
        switch id {
        case "sit", "down", "stay", "wait", "place":
            return .firm
        case "come":
            return .excited
        case "heel", "watch_me":
            return .calm
        case "leave_it", "drop_it":
            return .firm
        case "shake", "spin":
            return .gentle
        default:
            return .calm
        }
    }

    /// Short motivational phrase for the command
    var motivationalPhrase: String {
        switch id {
        case "sit": return "Foundation of all training!"
        case "stay": return "Patience is key"
        case "down": return "Calm and relaxed"
        case "come": return "The life-saving command"
        case "heel": return "Walking together as a team"
        case "leave_it": return "Self-control mastery"
        case "drop_it": return "Trading up!"
        case "wait": return "Just a moment..."
        case "watch_me": return "Eyes on me!"
        case "place": return "Your special spot"
        case "shake": return "Nice to meet you!"
        case "spin": return "Show off time!"
        default: return "You've got this!"
        }
    }

    static let allCommands: [Command] = [
        Command(
            id: "sit",
            name: "Sit",
            category: .basics,
            difficulty: .beginner,
            estimatedDays: 3,
            description: "The foundation of all dog training. Teaching your dog to sit on command.",
            steps: [
                TrainingStep(order: 1, instruction: "Hold a treat close to your dog's nose", duration: nil, tip: "Use a high-value treat"),
                TrainingStep(order: 2, instruction: "Move your hand up, allowing their head to follow the treat", duration: nil, tip: nil),
                TrainingStep(order: 3, instruction: "As their head moves up, their bottom will naturally lower", duration: nil, tip: nil),
                TrainingStep(order: 4, instruction: "Once in sitting position, say \"Sit\"", duration: nil, tip: "Say it clearly and consistently"),
                TrainingStep(order: 5, instruction: "Click and give the treat immediately", duration: nil, tip: "Timing is crucial!")
            ],
            tips: ["Practice in short 5-minute sessions", "Be patient and consistent", "Always end on a positive note"],
            commonMistakes: ["Pushing down on the dog's back", "Repeating the command multiple times", "Treating too late"],
            prerequisites: nil,
            youtubeVideoId: "1GbYflg4gJg"
        ),
        Command(
            id: "stay",
            name: "Stay",
            category: .basics,
            difficulty: .intermediate,
            estimatedDays: 7,
            description: "Teaching your dog to remain in position until released.",
            steps: [
                TrainingStep(order: 1, instruction: "Have your dog sit first. This is the foundation for Stay.", duration: nil, tip: nil),
                TrainingStep(order: 2, instruction: "Hold your palm up facing your dog and say \"Stay\" in a firm voice.", duration: nil, tip: nil),
                TrainingStep(order: 3, instruction: "Take one step back. Wait 2-3 seconds.", duration: "2-3 seconds", tip: nil),
                TrainingStep(order: 4, instruction: "If your dog stays, click and reward! Return and give treats.", duration: nil, tip: nil),
                TrainingStep(order: 5, instruction: "Gradually increase distance and duration as your dog improves.", duration: nil, tip: nil)
            ],
            tips: ["Always release with a consistent word like 'Okay!' or 'Free!'", "Start with short stays (2-3 seconds) and build up slowly", "Practice in low-distraction areas first before adding challenges"],
            commonMistakes: ["Increasing distance too quickly", "Not using a release word", "Punishing the dog for breaking stay"],
            prerequisites: ["sit"],
            youtubeVideoId: "gp6lU4Whm0c"
        ),
        Command(
            id: "down",
            name: "Down",
            category: .basics,
            difficulty: .intermediate,
            estimatedDays: 5,
            description: "Teaching your dog to lie down on command.",
            steps: [
                TrainingStep(order: 1, instruction: "Start with your dog in a sitting position", duration: nil, tip: nil),
                TrainingStep(order: 2, instruction: "Hold a treat in front of their nose", duration: nil, tip: nil),
                TrainingStep(order: 3, instruction: "Slowly move the treat down to the ground between their paws", duration: nil, tip: "Move slowly in an L-shape"),
                TrainingStep(order: 4, instruction: "When they lie down, say \"Down\" and click immediately", duration: nil, tip: nil),
                TrainingStep(order: 5, instruction: "Reward with the treat and praise", duration: nil, tip: nil)
            ],
            tips: ["Use a soft surface initially", "Be patient - this can take time", "Don't push your dog down"],
            commonMistakes: ["Moving the treat too fast", "Holding the treat too high", "Not waiting for full down position"],
            prerequisites: ["sit"],
            youtubeVideoId: "K-NMwNc6K-U"
        ),
        Command(
            id: "come",
            name: "Come",
            category: .basics,
            difficulty: .intermediate,
            estimatedDays: 10,
            description: "The most important safety command - teaching reliable recall.",
            steps: [
                TrainingStep(order: 1, instruction: "Start in a quiet area with minimal distractions", duration: nil, tip: nil),
                TrainingStep(order: 2, instruction: "Say your dog's name followed by \"Come!\" in an excited voice", duration: nil, tip: "Sound happy and excited"),
                TrainingStep(order: 3, instruction: "When they come to you, click and give a high-value treat", duration: nil, tip: nil),
                TrainingStep(order: 4, instruction: "Gradually increase distance and add distractions", duration: nil, tip: nil),
                TrainingStep(order: 5, instruction: "Practice in different locations", duration: nil, tip: nil)
            ],
            tips: ["Never punish your dog when they come to you", "Use the best treats for recall training", "Practice randomly throughout the day"],
            commonMistakes: ["Calling the dog for unpleasant things", "Chasing the dog", "Using a stern voice"],
            prerequisites: nil,
            youtubeVideoId: "rKlMirm4pIo"
        ),
        Command(
            id: "heel",
            name: "Heel",
            category: .basics,
            difficulty: .advanced,
            estimatedDays: 14,
            description: "Walking politely by your side without pulling.",
            steps: [
                TrainingStep(order: 1, instruction: "Start with your dog on your left side", duration: nil, tip: nil),
                TrainingStep(order: 2, instruction: "Hold a treat at your left thigh level", duration: nil, tip: nil),
                TrainingStep(order: 3, instruction: "Say \"Heel\" and take a step forward", duration: nil, tip: nil),
                TrainingStep(order: 4, instruction: "Click and treat when they stay by your side", duration: nil, tip: nil),
                TrainingStep(order: 5, instruction: "Gradually increase steps before treating", duration: nil, tip: nil)
            ],
            tips: ["Keep sessions short and fun", "Use high-value treats", "Practice in low-distraction areas first"],
            commonMistakes: ["Walking too fast initially", "Not rewarding frequently enough", "Pulling on the leash"],
            prerequisites: ["sit", "stay"],
            youtubeVideoId: "sFgtqgiAKoQ"
        ),
        Command(
            id: "leave_it",
            name: "Leave It",
            category: .basics,
            difficulty: .intermediate,
            estimatedDays: 7,
            description: "Teaching your dog to ignore temptations.",
            steps: [
                TrainingStep(order: 1, instruction: "Place a treat in your closed fist", duration: nil, tip: nil),
                TrainingStep(order: 2, instruction: "Let your dog sniff and paw at your hand", duration: nil, tip: nil),
                TrainingStep(order: 3, instruction: "When they back away, say \"Leave It\" and click", duration: nil, tip: nil),
                TrainingStep(order: 4, instruction: "Reward with a different treat from your other hand", duration: nil, tip: nil),
                TrainingStep(order: 5, instruction: "Progress to treats on the floor covered by your hand", duration: nil, tip: nil)
            ],
            tips: ["Always reward with a different treat", "Never let them get the 'leave it' item", "Be patient"],
            commonMistakes: ["Letting them get the forbidden item", "Moving too fast in progression"],
            prerequisites: nil,
            youtubeVideoId: "pHmKqe4T2x0"
        ),
        Command(
            id: "drop_it",
            name: "Drop It",
            category: .basics,
            difficulty: .intermediate,
            estimatedDays: 5,
            description: "Teaching your dog to release items from their mouth.",
            steps: [
                TrainingStep(order: 1, instruction: "Let your dog play with a toy", duration: nil, tip: nil),
                TrainingStep(order: 2, instruction: "Show them a high-value treat", duration: nil, tip: nil),
                TrainingStep(order: 3, instruction: "When they drop the toy, say \"Drop It\" and click", duration: nil, tip: nil),
                TrainingStep(order: 4, instruction: "Give the treat and return the toy", duration: nil, tip: nil),
                TrainingStep(order: 5, instruction: "Practice with increasingly valued items", duration: nil, tip: nil)
            ],
            tips: ["Always trade for something of equal or higher value", "Make it a fun game"],
            commonMistakes: ["Chasing the dog", "Not returning the toy sometimes"],
            prerequisites: nil,
            youtubeVideoId: "ndTiVOCNY4M"
        ),
        Command(
            id: "wait",
            name: "Wait",
            category: .basics,
            difficulty: .beginner,
            estimatedDays: 3,
            description: "A brief pause before proceeding - great for doors and mealtimes.",
            steps: [
                TrainingStep(order: 1, instruction: "Hold your hand up like a stop signal", duration: nil, tip: nil),
                TrainingStep(order: 2, instruction: "Say \"Wait\" in a calm voice", duration: nil, tip: nil),
                TrainingStep(order: 3, instruction: "Pause for 1-2 seconds", duration: "1-2 seconds", tip: nil),
                TrainingStep(order: 4, instruction: "Release with \"Okay\" and reward", duration: nil, tip: nil),
                TrainingStep(order: 5, instruction: "Gradually increase wait time", duration: nil, tip: nil)
            ],
            tips: ["Use before meals and at doors", "Keep it short - wait is temporary"],
            commonMistakes: ["Confusing with Stay", "Making them wait too long initially"],
            prerequisites: nil,
            youtubeVideoId: "wLryNwaIEsA"
        ),
        Command(
            id: "watch_me",
            name: "Watch Me",
            category: .basics,
            difficulty: .beginner,
            estimatedDays: 3,
            description: "Getting and holding your dog's attention.",
            steps: [
                TrainingStep(order: 1, instruction: "Hold a treat near your eyes", duration: nil, tip: nil),
                TrainingStep(order: 2, instruction: "Say \"Watch Me\" or \"Look\"", duration: nil, tip: nil),
                TrainingStep(order: 3, instruction: "When they make eye contact, click immediately", duration: nil, tip: nil),
                TrainingStep(order: 4, instruction: "Give the treat", duration: nil, tip: nil),
                TrainingStep(order: 5, instruction: "Gradually increase duration of eye contact", duration: nil, tip: nil)
            ],
            tips: ["Start with brief moments of eye contact", "Use it before giving other commands"],
            commonMistakes: ["Holding the treat too far from your face"],
            prerequisites: nil,
            youtubeVideoId: "pAqwKD5AQKw"
        ),
        Command(
            id: "place",
            name: "Place",
            category: .basics,
            difficulty: .intermediate,
            estimatedDays: 7,
            description: "Going to and staying on a designated spot.",
            steps: [
                TrainingStep(order: 1, instruction: "Choose a bed, mat, or designated spot", duration: nil, tip: nil),
                TrainingStep(order: 2, instruction: "Lure your dog onto the spot with a treat", duration: nil, tip: nil),
                TrainingStep(order: 3, instruction: "When all four paws are on, say \"Place\" and click", duration: nil, tip: nil),
                TrainingStep(order: 4, instruction: "Reward while they're on the spot", duration: nil, tip: nil),
                TrainingStep(order: 5, instruction: "Add \"Stay\" once they understand the spot", duration: nil, tip: nil)
            ],
            tips: ["Use the same spot initially", "Make it comfortable"],
            commonMistakes: ["Changing spots too early", "Not rewarding on the spot"],
            prerequisites: ["stay"],
            youtubeVideoId: "MIkBrjWn9ZY"
        ),
        Command(
            id: "shake",
            name: "Shake",
            category: .tricks,
            difficulty: .beginner,
            estimatedDays: 3,
            description: "A classic trick - shaking paws with your dog.",
            steps: [
                TrainingStep(order: 1, instruction: "Have your dog sit", duration: nil, tip: nil),
                TrainingStep(order: 2, instruction: "Gently tap the back of their paw", duration: nil, tip: nil),
                TrainingStep(order: 3, instruction: "When they lift it, say \"Shake\" and take it gently", duration: nil, tip: nil),
                TrainingStep(order: 4, instruction: "Click and treat immediately", duration: nil, tip: nil),
                TrainingStep(order: 5, instruction: "Practice until they offer the paw on command", duration: nil, tip: nil)
            ],
            tips: ["Be gentle with their paw", "Keep sessions short and fun"],
            commonMistakes: ["Grabbing the paw too firmly"],
            prerequisites: ["sit"],
            youtubeVideoId: "RgKIcAPXWXk"
        ),
        Command(
            id: "spin",
            name: "Spin",
            category: .tricks,
            difficulty: .beginner,
            estimatedDays: 2,
            description: "A fun trick where your dog spins in a circle.",
            steps: [
                TrainingStep(order: 1, instruction: "Hold a treat at your dog's nose level", duration: nil, tip: nil),
                TrainingStep(order: 2, instruction: "Slowly move it in a circle around them", duration: nil, tip: nil),
                TrainingStep(order: 3, instruction: "When they complete the circle, say \"Spin\" and click", duration: nil, tip: nil),
                TrainingStep(order: 4, instruction: "Give the treat", duration: nil, tip: nil),
                TrainingStep(order: 5, instruction: "Gradually reduce the luring motion", duration: nil, tip: nil)
            ],
            tips: ["Start slow", "Be enthusiastic with praise"],
            commonMistakes: ["Moving the treat too fast"],
            prerequisites: nil,
            youtubeVideoId: "SyVCdxb1spw"
        )
    ]

    static func command(for id: String) -> Command? {
        allCommands.first { $0.id == id }
    }

    static var commandsByCategory: [CommandCategory: [Command]] {
        Dictionary(grouping: allCommands, by: { $0.category })
    }
}
