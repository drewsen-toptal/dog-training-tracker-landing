import SwiftUI

/// Centralized registry of all PiAPI-generated 3D icons (local asset names)
enum PiAPIIcons {
    // MARK: - Training Commands
    static let sit = "Sit"
    static let stay = "Stay"
    static let down = "Down"
    static let come = "Come"
    static let heel = "Heel"
    static let leaveIt = "LeaveIt"
    static let dropIt = "DropIt"
    static let wait = "Wait"
    static let watchMe = "WatchMe"
    static let place = "Place"
    static let shake = "Shake"
    static let spin = "Spin"

    // MARK: - Feature Icons
    static let clicker = "Clicker"
    static let lightning = "Lightning"
    static let cloudDownload = "CloudDownload"
    static let shieldCheck = "ShieldCheck"

    // MARK: - Gamification
    static let fireStreak = "FireStreak"
    static let trophy = "Trophy"
    static let star = "Star"

    // MARK: - Mascot & Branding
    static let puppyMascot = "PuppyMascot"

    // MARK: - Breed Avatars
    static let dogDefault = "DogDefault"
    static let dogGoldenRetriever = "DogGoldenRetriever"
    static let dogLabrador = "DogLabrador"
    static let dogGermanShepherd = "DogGermanShepherd"
    static let dogBulldog = "DogBulldog"
    static let dogPoodle = "DogPoodle"
    static let dogBeagle = "DogBeagle"
    static let dogCorgi = "DogCorgi"
    static let dogHusky = "DogHusky"
    static let dogPomeranian = "DogPomeranian"

    // MARK: - UI Icons
    static let search = "Search"
    static let calendar = "Calendar"
    static let camera = "Camera"
    static let play = "Play"
    static let lightbulb = "Lightbulb"
    static let settings = "Settings"
    static let clock = "Clock"
    static let soundOn = "SoundOn"
    static let soundOff = "SoundOff"
    static let reset = "Reset"
    static let checkmark = "SuccessCheck"
    static let close = "Close"
    static let chevronRight = "ChevronRight"
    static let heart = "Heart"
    static let random = "Random"
    static let bell = "Bell"
    static let target = "Target"
    static let waveform = "Waveform"
    static let export = "Export"
    static let trash = "Trash"
    static let help = "Help"
    static let email = "Email"
    static let arrow = "Arrow"
    static let bolt = "Bolt"
    static let plus = "Plus"

    // MARK: - Tab Bar Icons
    static let tabHome = "TabHome"
    static let tabTrain = "TabTrain"
    static let tabCommands = "TabCommands"
    static let tabProgress = "TabProgress"
}

/// Reusable component for displaying PiAPI 3D icons from local bundle
/// Uses scaledToFill with clipping to crop out baked-in white backgrounds for consistent sizing
struct PiAPIIcon: View {
    let name: String
    let size: CGFloat
    var clipToCircle: Bool = false

    /// Scale factor to zoom in and crop white padding (1.0 = no zoom, 1.3 = 30% zoom)
    private let cropScale: CGFloat = 1.15

    var body: some View {
        Image(name, bundle: nil)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: size * cropScale, height: size * cropScale)
            .frame(width: size, height: size)
            .clipped()
            .clipShape(clipToCircle ? AnyShape(Circle()) : AnyShape(RoundedRectangle(cornerRadius: size * 0.2)))
    }
}

/// Extension to get PiAPI icon name for a command
extension Command {
    var piAPIIconName: String {
        switch id {
        case "sit": return PiAPIIcons.sit
        case "stay": return PiAPIIcons.stay
        case "down": return PiAPIIcons.down
        case "come": return PiAPIIcons.come
        case "heel": return PiAPIIcons.heel
        case "leave_it": return PiAPIIcons.leaveIt
        case "drop_it": return PiAPIIcons.dropIt
        case "wait": return PiAPIIcons.wait
        case "watch_me": return PiAPIIcons.watchMe
        case "place": return PiAPIIcons.place
        case "shake": return PiAPIIcons.shake
        case "spin": return PiAPIIcons.spin
        default: return PiAPIIcons.star // Default fallback
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        PiAPIIcon(name: PiAPIIcons.clicker, size: 60)
        PiAPIIcon(name: PiAPIIcons.fireStreak, size: 60)
        PiAPIIcon(name: PiAPIIcons.trophy, size: 60)
        PiAPIIcon(name: PiAPIIcons.sit, size: 60)
    }
    .padding()
}
