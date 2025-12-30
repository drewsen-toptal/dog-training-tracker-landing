import SwiftUI
import SwiftData

struct CommandDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Query private var dogs: [Dog]

    let command: Command

    @State private var showingTraining = false

    private var currentDog: Dog? {
        dogs.first
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                VStack(spacing: AppSpacing.lg) {
                    // Command hero
                    commandHero

                    // Progress card
                    progressCard

                    // Video section
                    videoSection

                    // Instructions
                    instructionsCard

                    // Tips
                    tipsCard

                    // Spacer for bottom button
                    Spacer()
                        .frame(height: 100)
                }
                .padding(.horizontal, AppSpacing.lg)
            }
            .background(AppColors.background)

            // Bottom CTA
            bottomButton
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Edit") {
                    // Edit action
                }
                .foregroundStyle(AppColors.primary)
            }
        }
        .sheet(isPresented: $showingTraining) {
            if let dog = currentDog {
                TrainingSessionView(dog: dog)
            }
        }
    }

    @ViewBuilder
    private var commandHero: some View {
        HStack(spacing: AppSpacing.lg) {
            // Command icon
            AsyncImage(url: URL(string: command.iconUrl ?? "")) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                default:
                    ZStack {
                        AppColors.primaryGradient
                        Image(systemName: command.category.iconName)
                            .font(.system(size: 36))
                            .foregroundStyle(.white)
                    }
                }
            }
            .frame(width: 72, height: 72)
            .clipShape(.rect(cornerRadius: AppRadius.lg))
            .shadow(color: AppColors.primary.opacity(0.3), radius: 12, y: 6)

            VStack(alignment: .leading, spacing: AppSpacing.xxs) {
                Text(command.name)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(AppColors.textPrimary)

                HStack(spacing: AppSpacing.xs) {
                    // Difficulty badge
                    Text(command.difficulty.displayName)
                        .font(AppFonts.caption())
                        .fontWeight(.semibold)
                        .foregroundStyle(AppColors.warning)
                        .padding(.horizontal, AppSpacing.sm)
                        .padding(.vertical, AppSpacing.xxs)
                        .background(AppColors.warning.opacity(0.15))
                        .clipShape(.rect(cornerRadius: AppRadius.xs))

                    // Category badge
                    Text(command.category.displayName)
                        .font(AppFonts.caption())
                        .fontWeight(.semibold)
                        .foregroundStyle(AppColors.primary)
                        .padding(.horizontal, AppSpacing.sm)
                        .padding(.vertical, AppSpacing.xxs)
                        .background(AppColors.primary.opacity(0.1))
                        .clipShape(.rect(cornerRadius: AppRadius.xs))
                }
            }

            Spacer()
        }
        .padding(AppSpacing.lg)
        .background(.white)
        .clipShape(.rect(cornerRadius: AppRadius.lg))
        .shadow(color: .black.opacity(0.04), radius: 8, y: 2)
    }

    @ViewBuilder
    private var progressCard: some View {
        VStack(spacing: AppSpacing.md) {
            HStack {
                Text("Mastery Progress")
                    .font(AppFonts.headline())
                    .foregroundStyle(AppColors.textPrimary)

                Spacer()

                Text("68%")
                    .font(.title2.weight(.bold))
                    .foregroundStyle(AppColors.primary)
            }

            // Progress bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 5)
                        .fill(AppColors.background)
                        .frame(height: 10)

                    RoundedRectangle(cornerRadius: 5)
                        .fill(AppColors.primaryGradient)
                        .frame(width: geometry.size.width * 0.68, height: 10)
                }
            }
            .frame(height: 10)

            // Stats
            HStack {
                statColumn(value: "24", label: "Sessions")
                Spacer()
                statColumn(value: "87%", label: "Success Rate")
                Spacer()
                statColumn(value: "2d", label: "Last Trained")
            }
        }
        .padding(AppSpacing.lg)
        .background(.white)
        .clipShape(.rect(cornerRadius: AppRadius.lg))
        .shadow(color: .black.opacity(0.04), radius: 8, y: 2)
    }

    @ViewBuilder
    private func statColumn(value: String, label: String) -> some View {
        VStack(spacing: AppSpacing.xxs) {
            Text(value)
                .font(.title3.weight(.bold))
                .foregroundStyle(AppColors.textPrimary)

            Text(label.uppercased())
                .font(.caption2)
                .fontWeight(.semibold)
                .foregroundStyle(AppColors.textSecondary)
        }
    }

    @ViewBuilder
    private var videoSection: some View {
        VStack(spacing: 0) {
            ZStack {
                // Dark background
                LinearGradient(
                    colors: [Color(red: 0.2, green: 0.2, blue: 0.22), Color(red: 0.15, green: 0.15, blue: 0.17)],
                    startPoint: .top,
                    endPoint: .bottom
                )

                VStack(spacing: AppSpacing.sm) {
                    // Play button
                    ZStack {
                        Circle()
                            .fill(.white)
                            .frame(width: 64, height: 64)
                            .shadow(color: .black.opacity(0.3), radius: 12, y: 4)

                        Image(systemName: "play.fill")
                            .font(.title2)
                            .foregroundStyle(AppColors.primary)
                            .offset(x: 2)
                    }

                    Text("Watch Training Video")
                        .font(AppFonts.subheadline())
                        .fontWeight(.semibold)
                        .foregroundStyle(.white.opacity(0.8))
                }

                // Duration badge
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Text("1:24")
                            .font(AppFonts.caption())
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                            .padding(.horizontal, AppSpacing.sm)
                            .padding(.vertical, AppSpacing.xxs)
                            .background(Color.black.opacity(0.8))
                            .clipShape(.rect(cornerRadius: AppRadius.xs))
                            .padding(AppSpacing.sm)
                    }
                }
            }
            .frame(height: 200)
        }
        .clipShape(.rect(cornerRadius: AppRadius.lg))
        .shadow(color: .black.opacity(0.04), radius: 8, y: 2)
    }

    @ViewBuilder
    private var instructionsCard: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text("How to Train \"\(command.name)\"")
                .font(AppFonts.headline())
                .foregroundStyle(AppColors.textPrimary)

            ForEach(command.steps) { step in
                HStack(alignment: .top, spacing: AppSpacing.sm) {
                    // Step number
                    Text("\(step.order)")
                        .font(AppFonts.subheadline())
                        .fontWeight(.bold)
                        .foregroundStyle(AppColors.primary)
                        .frame(width: 28, height: 28)
                        .background(AppColors.primary.opacity(0.12))
                        .clipShape(Circle())

                    Text(step.instruction)
                        .font(AppFonts.body())
                        .foregroundStyle(AppColors.textSecondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        .padding(AppSpacing.lg)
        .background(.white)
        .clipShape(.rect(cornerRadius: AppRadius.lg))
        .shadow(color: .black.opacity(0.04), radius: 8, y: 2)
    }

    @ViewBuilder
    private var tipsCard: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            HStack(spacing: AppSpacing.sm) {
                Image(systemName: "lightbulb.fill")
                    .foregroundStyle(AppColors.warning)

                Text("Pro Tips")
                    .font(AppFonts.headline())
                    .foregroundStyle(AppColors.textPrimary)
            }

            ForEach(command.tips, id: \.self) { tip in
                HStack(alignment: .top, spacing: AppSpacing.sm) {
                    Circle()
                        .fill(AppColors.warning)
                        .frame(width: 6, height: 6)
                        .padding(.top, 8)

                    Text(tip)
                        .font(AppFonts.subheadline())
                        .foregroundStyle(AppColors.textSecondary)
                }
            }
        }
        .padding(AppSpacing.lg)
        .background(AppColors.warning.opacity(0.12))
        .clipShape(.rect(cornerRadius: AppRadius.lg))
    }

    @ViewBuilder
    private var bottomButton: some View {
        VStack {
            LinearGradient(
                colors: [AppColors.background.opacity(0), AppColors.background],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 40)

            PrimaryButton(
                title: "Start Training \(command.name)",
                icon: "play.fill",
                isDisabled: currentDog == nil
            ) {
                showingTraining = true
            }
            .padding(.horizontal, AppSpacing.xl)
            .padding(.bottom, AppSpacing.xxxl)
            .background(AppColors.background)
        }
    }
}

#Preview {
    NavigationStack {
        CommandDetailView(command: Command.allCommands[1])
    }
    .modelContainer(for: Dog.self, inMemory: true)
}
