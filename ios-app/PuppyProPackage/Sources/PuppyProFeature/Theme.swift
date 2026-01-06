import SwiftUI

enum AppColors {
    // Primary teal color from mockups: oklch(0.55 0.15 165)
    // Brand color for Puppy PRO - professional, trustworthy teal
    static let primary = Color(red: 0.188, green: 0.557, blue: 0.545)
    static let primaryDark = Color(red: 0.149, green: 0.482, blue: 0.482)
    static let primaryLight = Color(red: 0.25, green: 0.65, blue: 0.63)

    // Success green: oklch(0.65 0.18 145)
    static let success = Color(red: 0.294, green: 0.639, blue: 0.396)

    // Warning/amber: oklch(0.75 0.14 55)
    static let warning = Color(red: 0.831, green: 0.635, blue: 0.325)

    // Error red: oklch(0.60 0.22 25)
    static let error = Color(red: 0.757, green: 0.306, blue: 0.294)

    // Background colors
    static let background = Color(red: 0.96, green: 0.96, blue: 0.965)
    static let backgroundDark = Color(red: 0.15, green: 0.15, blue: 0.165)

    // Text colors
    static let textPrimary = Color(red: 0.15, green: 0.15, blue: 0.165)
    static let textSecondary = Color(red: 0.5, green: 0.5, blue: 0.52)
    static let textTertiary = Color(red: 0.65, green: 0.65, blue: 0.67)

    // Card background
    static let cardBackground = Color.white

    // Gradient for primary buttons - premium feel
    static let primaryGradient = LinearGradient(
        colors: [primary, primaryDark],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    // Success gradient
    static let successGradient = LinearGradient(
        colors: [success, success.opacity(0.8)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    // Premium gradient for special elements
    static let premiumGradient = LinearGradient(
        colors: [primaryLight, primary, primaryDark],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

// MARK: - Premium Card Style

struct PremiumCardStyle: ViewModifier {
    var cornerRadius: CGFloat = AppRadius.lg

    func body(content: Content) -> some View {
        content
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .shadow(color: .black.opacity(0.06), radius: 12, y: 4)
    }
}

extension View {
    func premiumCard(cornerRadius: CGFloat = AppRadius.lg) -> some View {
        modifier(PremiumCardStyle(cornerRadius: cornerRadius))
    }
}

enum AppFonts {
    static func largeTitle() -> Font {
        .largeTitle.weight(.bold)
    }

    static func title() -> Font {
        .title.weight(.bold)
    }

    static func title2() -> Font {
        .title2.weight(.semibold)
    }

    static func title3() -> Font {
        .title3.weight(.semibold)
    }

    static func headline() -> Font {
        .headline
    }

    static func body() -> Font {
        .body
    }

    static func callout() -> Font {
        .callout
    }

    static func subheadline() -> Font {
        .subheadline
    }

    static func footnote() -> Font {
        .footnote
    }

    static func caption() -> Font {
        .caption
    }

    static func caption2() -> Font {
        .caption2
    }
}

enum AppSpacing {
    static let xxs: CGFloat = 4
    static let xs: CGFloat = 8
    static let sm: CGFloat = 12
    static let md: CGFloat = 16
    static let lg: CGFloat = 20
    static let xl: CGFloat = 24
    static let xxl: CGFloat = 32
    static let xxxl: CGFloat = 48
}

enum AppRadius {
    static let xs: CGFloat = 6
    static let sm: CGFloat = 10
    static let md: CGFloat = 14
    static let lg: CGFloat = 20
    static let xl: CGFloat = 28
    static let full: CGFloat = 1000
}
