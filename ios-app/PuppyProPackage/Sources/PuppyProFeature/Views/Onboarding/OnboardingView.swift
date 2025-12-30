import SwiftUI
import SwiftData

struct OnboardingView: View {
    @Environment(\.modelContext) private var modelContext
    @Binding var hasCompletedOnboarding: Bool

    @State private var currentPage = 0
    @State private var dogName = ""
    @State private var dogBreed = ""
    @State private var dogBirthDate = Date()

    private let pages = [
        OnboardingPage(
            icon: nil,
            customImage: "PuppyMascot",
            title: "Welcome to\nPuppy PRO",
            description: "The science-backed way to train your dog using positive reinforcement and spaced repetition.",
            color: AppColors.primary
        ),
        OnboardingPage(
            icon: nil,
            customImage: "TargetClicker",
            title: "Click & Reward",
            description: "Use our built-in clicker to mark good behavior instantly, then reward with treats.",
            color: AppColors.success
        ),
        OnboardingPage(
            icon: nil,
            customImage: "Lightning",
            title: "Smart Scheduling",
            description: "We use spaced repetition to remind you when it's time to practice each command.",
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
                            onboardingPageView(pages[index])
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
                        title: currentPage == pages.count - 1 ? "Get Started" : "Next",
                        icon: currentPage == pages.count - 1 ? "arrow.right" : nil
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
    }

    @ViewBuilder
    private func onboardingPageView(_ page: OnboardingPage) -> some View {
        VStack(spacing: AppSpacing.xxl) {
            Spacer()

            // Icon - supports both SF Symbols and custom images
            ZStack {
                Circle()
                    .fill(page.color.opacity(0.15))
                    .frame(width: 180, height: 180)

                Circle()
                    .fill(page.color.opacity(0.25))
                    .frame(width: 140, height: 140)

                if let customImage = page.customImage {
                    Image(customImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                } else if let icon = page.icon {
                    Image(systemName: icon)
                        .font(.system(size: 56))
                        .foregroundStyle(page.color)
                }
            }

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

            Spacer()
            Spacer()
        }
    }

    @ViewBuilder
    private var dogSetupView: some View {
        VStack(spacing: AppSpacing.xl) {
            Spacer()

            // Header
            VStack(spacing: AppSpacing.sm) {
                Image("PuppyMascot")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .shadow(color: AppColors.primary.opacity(0.3), radius: 10, y: 5)

                Text("Add Your Pup")
                    .font(.title.bold())
                    .foregroundStyle(AppColors.textPrimary)

                Text("Let's get to know your furry friend")
                    .font(AppFonts.body())
                    .foregroundStyle(AppColors.textSecondary)
            }

            // Form
            VStack(spacing: AppSpacing.md) {
                VStack(alignment: .leading, spacing: AppSpacing.xs) {
                    Text("NAME")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(AppColors.textSecondary)
                        .tracking(0.5)

                    TextField("What's your pup's name?", text: $dogName)
                        .font(AppFonts.body())
                        .padding(AppSpacing.md)
                        .background(.white)
                        .clipShape(.rect(cornerRadius: AppRadius.md))
                        .shadow(color: .black.opacity(0.05), radius: 4, y: 2)
                }

                VStack(alignment: .leading, spacing: AppSpacing.xs) {
                    Text("BREED (OPTIONAL)")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(AppColors.textSecondary)
                        .tracking(0.5)

                    TextField("e.g., Golden Retriever", text: $dogBreed)
                        .font(AppFonts.body())
                        .padding(AppSpacing.md)
                        .background(.white)
                        .clipShape(.rect(cornerRadius: AppRadius.md))
                        .shadow(color: .black.opacity(0.05), radius: 4, y: 2)
                }
            }
            .padding(.horizontal, AppSpacing.xl)

            Spacer()

            // Complete button
            VStack(spacing: AppSpacing.sm) {
                PrimaryButton(
                    title: "Start Training!",
                    icon: "play.fill",
                    isDisabled: dogName.trimmingCharacters(in: .whitespaces).isEmpty
                ) {
                    completeOnboarding()
                }

                Button("Skip for now") {
                    hasCompletedOnboarding = true
                }
                .font(AppFonts.subheadline())
                .foregroundStyle(AppColors.textSecondary)
                .padding(.vertical, AppSpacing.sm)
            }
            .padding(.horizontal, AppSpacing.xl)
            .padding(.bottom, AppSpacing.xxxl)
        }
    }

    private func completeOnboarding() {
        let dog = Dog(
            name: dogName.trimmingCharacters(in: .whitespaces),
            breed: dogBreed.isEmpty ? nil : dogBreed.trimmingCharacters(in: .whitespaces),
            birthDate: nil
        )

        modelContext.insert(dog)
        hasCompletedOnboarding = true
    }
}

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
    OnboardingView(hasCompletedOnboarding: .constant(false))
        .modelContainer(for: Dog.self, inMemory: true)
}
