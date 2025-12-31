import SwiftUI
import SwiftData
import os.log

private let logger = Logger(subsystem: "com.drewsen.PuppyPro", category: "Onboarding")

struct OnboardingView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(AppState.self) private var appState

    @State private var currentPage = 0
    @State private var dogName = ""
    @State private var dogBreed = ""
    @State private var dogBirthDate = Date()
    @State private var showingCelebration = false
    @FocusState private var focusedField: Field?

    private enum Field {
        case name, breed
    }

    private let pages = [
        OnboardingPage(
            icon: nil,
            customImage: "PuppyMascot",
            title: "Train Smarter,\nNot Harder",
            description: "Transform your pup into a well-behaved companion with proven positive reinforcement techniques.",
            color: AppColors.primary
        ),
        OnboardingPage(
            icon: nil,
            customImage: "TargetClicker",
            title: "Perfect Timing,\nEvery Time",
            description: "Our precision clicker marks the exact moment your dog gets it right — building faster, lasting results.",
            color: AppColors.success
        ),
        OnboardingPage(
            icon: nil,
            customImage: "Lightning",
            title: "Your Personal\nTraining Coach",
            description: "Smart reminders ensure you practice at the optimal time for maximum retention and progress.",
            color: AppColors.warning
        )
    ]

    var body: some View {
        ZStack {
            AppColors.background
                .ignoresSafeArea()

            VStack(spacing: 0) {
                if currentPage < pages.count {
                    // Onboarding pages
                    TabView(selection: $currentPage) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            OnboardingPageContent(page: pages[index])
                                .tag(index)
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .animation(.easeInOut, value: currentPage)

                    // Page indicators
                    HStack(spacing: 8) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            Circle()
                                .fill(index == currentPage ? AppColors.primary : AppColors.textTertiary)
                                .frame(width: index == currentPage ? 10 : 8, height: index == currentPage ? 10 : 8)
                                .animation(.spring(response: 0.3), value: currentPage)
                        }
                    }
                    .padding(.bottom, AppSpacing.xl)

                    // Next button
                    PrimaryButton(
                        title: currentPage == pages.count - 1 ? "Get Started" : "Next"
                    ) {
                        withAnimation {
                            if currentPage < pages.count - 1 {
                                currentPage += 1
                            } else {
                                currentPage = pages.count // Move to dog setup
                            }
                        }
                    }
                    .padding(.horizontal, AppSpacing.xl)
                    .padding(.bottom, AppSpacing.xxxl)
                } else {
                    // Dog setup page
                    dogSetupView
                }
            }
        }
        .fullScreenCover(isPresented: $showingCelebration) {
            OnboardingCompleteView(dogName: dogName) {
                // Dismiss celebration and complete onboarding
                showingCelebration = false
                withAnimation(.easeInOut(duration: 0.3)) {
                    appState.hasCompletedOnboarding = true
                }
            }
        }
    }

    @ViewBuilder
    private var dogSetupView: some View {
        VStack(spacing: 0) {
            Spacer()

            // Header with animated mascot
            DogSetupHeader()

            Spacer()
                .frame(height: 32)

            // Premium Form Card
            VStack(spacing: 20) {
                // Name field with premium styling
                PremiumTextField(
                    label: "Your Pup's Name",
                    placeholder: "What should we call them?",
                    text: $dogName,
                    iconName: PiAPIIcons.heart,
                    isFocused: focusedField == .name
                )
                .focused($focusedField, equals: .name)
                .submitLabel(.next)
                .onSubmit { focusedField = .breed }

                // Breed field with premium styling
                PremiumTextField(
                    label: "Breed",
                    placeholder: "e.g., Golden Retriever",
                    text: $dogBreed,
                    iconName: PiAPIIcons.dogDefault,
                    isOptional: true,
                    isFocused: focusedField == .breed
                )
                .focused($focusedField, equals: .breed)
                .submitLabel(.done)
                .onSubmit { focusedField = nil }
            }
            .padding(24)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(.white)
                    .shadow(color: AppColors.primary.opacity(0.08), radius: 24, y: 8)
            )
            .padding(.horizontal, 20)

            Spacer()

            // Premium Complete button
            VStack(spacing: 16) {
                Button {
                    completeOnboarding()
                } label: {
                    HStack(spacing: 12) {
                        PiAPIIcon(name: PiAPIIcons.play, size: 24)

                        Text("Start Training")
                            .font(.system(size: 18, weight: .bold))
                    }
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(
                        Group {
                            if dogName.trimmingCharacters(in: .whitespaces).isEmpty {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(AppColors.textTertiary.opacity(0.4))
                            } else {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(
                                        LinearGradient(
                                            colors: [AppColors.primary, AppColors.primaryDark],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .shadow(color: AppColors.primary.opacity(0.4), radius: 16, y: 6)
                            }
                        }
                    )
                }
                .disabled(dogName.trimmingCharacters(in: .whitespaces).isEmpty)
                .animation(.easeInOut(duration: 0.2), value: dogName.isEmpty)

                // Skip link with subtle styling
                Button {
                    skipOnboarding()
                } label: {
                    HStack(spacing: 6) {
                        Text("Skip for now")
                            .font(.system(size: 15, weight: .medium))

                        Image(systemName: "arrow.right")
                            .font(.system(size: 12, weight: .semibold))
                    }
                    .foregroundStyle(AppColors.textTertiary)
                }
                .padding(.vertical, 8)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 48)
        }
    }

    private func completeOnboarding() {
        logger.info("🐕 completeOnboarding() CALLED - dogName: \(self.dogName)")

        // Dismiss keyboard
        focusedField = nil

        // Create and save dog
        let dog = Dog(
            name: dogName.trimmingCharacters(in: .whitespaces),
            breed: dogBreed.isEmpty ? nil : dogBreed.trimmingCharacters(in: .whitespaces),
            birthDate: nil
        )
        modelContext.insert(dog)

        do {
            try modelContext.save()
            logger.info("🐕 Dog saved successfully")
        } catch {
            logger.error("🐕 ERROR saving dog: \(error.localizedDescription)")
        }

        // Show celebration screen with happy dog animation
        showingCelebration = true
    }

    private func skipOnboarding() {
        // Dismiss keyboard
        focusedField = nil

        // Create a placeholder dog so app has required data
        let dog = Dog(name: "My Pup")
        modelContext.insert(dog)
        try? modelContext.save()

        // Set flag to complete onboarding
        appState.hasCompletedOnboarding = true
    }
}

// MARK: - Animated Page Content

/// Animated onboarding page content with entrance animations
private struct OnboardingPageContent: View {
    let page: OnboardingPage

    @State private var iconScale: CGFloat = 0.5
    @State private var iconOffset: CGFloat = 30
    @State private var textOpacity: Double = 0
    @State private var textOffset: CGFloat = 20
    @State private var isFloating = false

    var body: some View {
        VStack(spacing: AppSpacing.xxl) {
            Spacer()

            // Icon with animated rings and floating effect
            ZStack {
                // Outer pulsing ring
                Circle()
                    .fill(page.color.opacity(0.1))
                    .frame(width: 200, height: 200)
                    .scaleEffect(isFloating ? 1.05 : 0.95)
                    .animation(
                        .easeInOut(duration: 2.0)
                        .repeatForever(autoreverses: true),
                        value: isFloating
                    )

                // Middle ring
                Circle()
                    .fill(page.color.opacity(0.15))
                    .frame(width: 180, height: 180)
                    .scaleEffect(iconScale)

                // Inner ring
                Circle()
                    .fill(page.color.opacity(0.25))
                    .frame(width: 140, height: 140)
                    .scaleEffect(iconScale)

                // Icon with bounce
                Group {
                    if let customImage = page.customImage {
                        PiAPIIcon(name: customImage, size: 100)
                            .clipShape(Circle())
                    } else if let icon = page.icon {
                        PiAPIIcon(name: icon, size: 56)
                    }
                }
                .scaleEffect(iconScale)
                .offset(y: iconOffset + (isFloating ? -8 : 0))
            }
            .animation(
                .easeInOut(duration: 1.5)
                .repeatForever(autoreverses: true),
                value: isFloating
            )

            // Text content with fade-up animation
            VStack(spacing: AppSpacing.md) {
                Text(page.title)
                    .font(.largeTitle.bold())
                    .foregroundStyle(AppColors.textPrimary)
                    .multilineTextAlignment(.center)

                Text(page.description)
                    .font(.body)
                    .foregroundStyle(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, AppSpacing.xl)
            }
            .opacity(textOpacity)
            .offset(y: textOffset)

            Spacer()
            Spacer()
        }
        .onAppear {
            startEntranceAnimation()
        }
    }

    private func startEntranceAnimation() {
        // Icon bounces in
        withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
            iconScale = 1.0
            iconOffset = 0
        }

        // Text fades up after icon
        withAnimation(.easeOut(duration: 0.5).delay(0.2)) {
            textOpacity = 1.0
            textOffset = 0
        }

        // Start floating animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            isFloating = true
        }
    }
}

// MARK: - Dog Setup Header

/// Premium animated header for dog setup page with matching onboarding style
private struct DogSetupHeader: View {
    @State private var isFloating = false
    @State private var iconScale: CGFloat = 0.5
    @State private var iconOffset: CGFloat = 30
    @State private var textOpacity: Double = 0
    @State private var textOffset: CGFloat = 20

    var body: some View {
        VStack(spacing: 24) {
            // Animated icon with premium rings (matching onboarding style)
            ZStack {
                // Outer pulsing ring
                Circle()
                    .fill(AppColors.primary.opacity(0.08))
                    .frame(width: 180, height: 180)
                    .scaleEffect(isFloating ? 1.05 : 0.95)
                    .animation(
                        .easeInOut(duration: 2.0)
                        .repeatForever(autoreverses: true),
                        value: isFloating
                    )

                // Middle ring
                Circle()
                    .fill(AppColors.primary.opacity(0.12))
                    .frame(width: 150, height: 150)
                    .scaleEffect(iconScale)

                // Inner ring
                Circle()
                    .fill(AppColors.primary.opacity(0.18))
                    .frame(width: 120, height: 120)
                    .scaleEffect(iconScale)

                // Mascot icon with bounce and float
                PiAPIIcon(name: PiAPIIcons.puppyMascot, size: 90)
                    .clipShape(Circle())
                    .shadow(color: AppColors.primary.opacity(0.25), radius: 12, y: 6)
                    .scaleEffect(iconScale)
                    .offset(y: iconOffset + (isFloating ? -8 : 0))
            }
            .animation(
                .easeInOut(duration: 1.5)
                .repeatForever(autoreverses: true),
                value: isFloating
            )

            // Premium text with gradient and better typography
            VStack(spacing: 8) {
                Text("Meet Your Pup")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [AppColors.textPrimary, AppColors.textPrimary.opacity(0.8)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )

                Text("Tell us a little about your best friend")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(AppColors.textSecondary)
            }
            .opacity(textOpacity)
            .offset(y: textOffset)
        }
        .onAppear {
            startEntranceAnimation()
        }
    }

    private func startEntranceAnimation() {
        // Icon bounces in
        withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
            iconScale = 1.0
            iconOffset = 0
        }

        // Text fades up after icon
        withAnimation(.easeOut(duration: 0.5).delay(0.2)) {
            textOpacity = 1.0
            textOffset = 0
        }

        // Start floating animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            isFloating = true
        }
    }
}

/// Premium styled text field with icon and label
private struct PremiumTextField: View {
    let label: String
    let placeholder: String
    @Binding var text: String
    var iconName: String = PiAPIIcons.heart
    var isOptional: Bool = false
    var isFocused: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Label row
            HStack(spacing: 4) {
                Text(label)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(AppColors.textPrimary)

                if isOptional {
                    Text("(optional)")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(AppColors.textTertiary)
                }
            }

            // Input field with icon
            HStack(spacing: 14) {
                // Icon
                ZStack {
                    Circle()
                        .fill(isFocused ? AppColors.primary.opacity(0.12) : AppColors.background)
                        .frame(width: 44, height: 44)

                    PiAPIIcon(name: iconName, size: 28)
                }
                .animation(.easeInOut(duration: 0.2), value: isFocused)

                // Text field
                TextField(placeholder, text: $text)
                    .font(.system(size: 17, weight: .medium))
                    .foregroundStyle(AppColors.textPrimary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(AppColors.background)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(
                                isFocused ? AppColors.primary : Color.clear,
                                lineWidth: 2
                            )
                    )
            )
            .animation(.easeInOut(duration: 0.2), value: isFocused)
        }
    }
}

// MARK: - Data Types

struct OnboardingPage {
    let icon: String?
    let customImage: String?
    let title: String
    let description: String
    let color: Color

    init(icon: String? = nil, customImage: String? = nil, title: String, description: String, color: Color) {
        self.icon = icon
        self.customImage = customImage
        self.title = title
        self.description = description
        self.color = color
    }
}

#Preview {
    OnboardingView()
        .environment(AppState())
        .modelContainer(for: Dog.self, inMemory: true)
}
