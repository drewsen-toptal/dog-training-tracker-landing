import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var dogs: [Dog]
    @Query(sort: \TrainingSession.startTime, order: .reverse) private var sessions: [TrainingSession]

    @State private var showingTrainingSheet = false
    @State private var showingAddDogSheet = false

    private var currentDog: Dog? {
        dogs.first
    }

    private var todaysSessions: [TrainingSession] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        return sessions.filter { session in
            calendar.isDate(session.startTime, inSameDayAs: today)
        }
    }

    private var currentStreak: Int {
        // Calculate streak from sessions
        var streak = 0
        let calendar = Calendar.current
        var checkDate = calendar.startOfDay(for: Date())

        while true {
            let hasSessionOnDate = sessions.contains { session in
                calendar.isDate(session.startTime, inSameDayAs: checkDate)
            }

            if hasSessionOnDate {
                streak += 1
                guard let previousDay = calendar.date(byAdding: .day, value: -1, to: checkDate) else { break }
                checkDate = previousDay
            } else if streak == 0 {
                // Check if today has no sessions yet - that's ok, check yesterday
                guard let yesterday = calendar.date(byAdding: .day, value: -1, to: checkDate) else { break }
                checkDate = yesterday
            } else {
                break
            }
        }

        return streak
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: AppSpacing.lg) {
                    // Dog Profile Header
                    if let dog = currentDog {
                        dogProfileHeader(dog)
                    } else {
                        noDogPlaceholder
                    }

                    // Stats Cards
                    statsSection

                    // Today's Progress
                    todayProgressSection

                    // Quick Actions
                    quickActionsSection

                    // Commands to Review
                    if currentDog != nil {
                        commandsToReviewSection
                    }
                }
                .padding(.horizontal, AppSpacing.lg)
                .padding(.bottom, 100)
            }
            .background(AppColors.background)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Puppy PRO")
                        .font(AppFonts.headline())
                        .foregroundStyle(AppColors.textPrimary)
                }

                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        SettingsView()
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .font(.body)
                            .foregroundStyle(AppColors.textSecondary)
                    }
                }
            }
            .sheet(isPresented: $showingTrainingSheet) {
                if let dog = currentDog {
                    TrainingSessionView(dog: dog)
                }
            }
            .sheet(isPresented: $showingAddDogSheet) {
                AddDogView()
            }
        }
    }

    @ViewBuilder
    private func dogProfileHeader(_ dog: Dog) -> some View {
        HStack(spacing: AppSpacing.md) {
            DogAvatar(
                name: dog.name,
                imageData: dog.photoData,
                size: 64
            )

            VStack(alignment: .leading, spacing: AppSpacing.xxs) {
                Text("Hey, \(dog.name)!")
                    .font(AppFonts.title2())
                    .foregroundStyle(AppColors.textPrimary)

                if let breed = dog.breed {
                    Text("\(breed) • \(dog.ageDescription)")
                        .font(AppFonts.subheadline())
                        .foregroundStyle(AppColors.textSecondary)
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
    private var noDogPlaceholder: some View {
        VStack(spacing: AppSpacing.md) {
            Image(systemName: "pawprint.fill")
                .font(.system(size: 48))
                .foregroundStyle(AppColors.primary)

            Text("Add Your First Pup!")
                .font(AppFonts.title3())
                .foregroundStyle(AppColors.textPrimary)

            Text("Get started by adding your dog's profile")
                .font(AppFonts.subheadline())
                .foregroundStyle(AppColors.textSecondary)
                .multilineTextAlignment(.center)

            Button("Add Dog") {
                showingAddDogSheet = true
            }
            .font(AppFonts.headline())
            .foregroundStyle(.white)
            .padding(.horizontal, AppSpacing.xl)
            .padding(.vertical, AppSpacing.sm)
            .background(AppColors.primaryGradient)
            .clipShape(.rect(cornerRadius: AppRadius.md))
        }
        .padding(AppSpacing.xxl)
        .frame(maxWidth: .infinity)
        .background(.white)
        .clipShape(.rect(cornerRadius: AppRadius.lg))
        .shadow(color: .black.opacity(0.04), radius: 8, y: 2)
    }

    @ViewBuilder
    private var statsSection: some View {
        HStack(spacing: AppSpacing.md) {
            StatCard(
                title: "Success Rate",
                value: successRateText,
                iconSystemName: "checkmark.circle.fill",
                valueColor: AppColors.success
            )

            StatCard(
                title: "Day Streak",
                value: "\(currentStreak)",
                iconSystemName: "flame.fill",
                valueColor: AppColors.warning
            )
        }
    }

    private var successRateText: String {
        let totalReps = sessions.reduce(0) { $0 + $1.totalReps }
        let successReps = sessions.reduce(0) { $0 + $1.successCount }
        guard totalReps > 0 else { return "—" }
        return "\(Int(Double(successReps) / Double(totalReps) * 100))%"
    }

    @ViewBuilder
    private var todayProgressSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text("Today's Progress")
                .font(AppFonts.headline())
                .foregroundStyle(AppColors.textPrimary)

            HStack(spacing: AppSpacing.lg) {
                VStack(spacing: AppSpacing.xxs) {
                    Text("\(todaysSessions.count)")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundStyle(AppColors.primary)
                    Text("Sessions")
                        .font(AppFonts.caption())
                        .foregroundStyle(AppColors.textSecondary)
                }

                Divider()
                    .frame(height: 40)

                VStack(spacing: AppSpacing.xxs) {
                    Text("\(todaysSessions.reduce(0) { $0 + $1.totalReps })")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundStyle(AppColors.textPrimary)
                    Text("Reps")
                        .font(AppFonts.caption())
                        .foregroundStyle(AppColors.textSecondary)
                }

                Divider()
                    .frame(height: 40)

                VStack(spacing: AppSpacing.xxs) {
                    Text(todaysDuration)
                        .font(.system(size: 32, weight: .bold))
                        .foregroundStyle(AppColors.textPrimary)
                    Text("Minutes")
                        .font(AppFonts.caption())
                        .foregroundStyle(AppColors.textSecondary)
                }

                Spacer()
            }
        }
        .padding(AppSpacing.lg)
        .background(.white)
        .clipShape(.rect(cornerRadius: AppRadius.lg))
        .shadow(color: .black.opacity(0.04), radius: 8, y: 2)
    }

    private var todaysDuration: String {
        let totalSeconds = todaysSessions.reduce(0) { $0 + $1.durationSeconds }
        let minutes = totalSeconds / 60
        return "\(minutes)"
    }

    @ViewBuilder
    private var quickActionsSection: some View {
        VStack(spacing: AppSpacing.sm) {
            PrimaryButton(
                title: "Start Training Session",
                icon: "play.fill",
                isDisabled: currentDog == nil
            ) {
                showingTrainingSheet = true
            }

            NavigationLink {
                ClickerView()
            } label: {
                HStack(spacing: AppSpacing.sm) {
                    Image(systemName: "hand.tap.fill")
                        .font(.body.weight(.semibold))
                    Text("Quick Clicker")
                        .font(AppFonts.headline())
                }
                .foregroundStyle(AppColors.textPrimary)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(.white)
                .clipShape(.rect(cornerRadius: AppRadius.lg))
                .overlay(
                    RoundedRectangle(cornerRadius: AppRadius.lg)
                        .stroke(AppColors.background, lineWidth: 2)
                )
            }
        }
    }

    @ViewBuilder
    private var commandsToReviewSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            HStack {
                Text("Commands to Practice")
                    .font(AppFonts.headline())
                    .foregroundStyle(AppColors.textPrimary)

                Spacer()

                NavigationLink {
                    CommandListView()
                } label: {
                    Text("See All")
                        .font(AppFonts.subheadline())
                        .foregroundStyle(AppColors.primary)
                }
            }

            ForEach(Command.allCommands.prefix(3)) { command in
                NavigationLink {
                    CommandDetailView(command: command)
                } label: {
                    CommandCard(command: command, progress: nil)
                }
                .buttonStyle(.plain)
            }
        }
    }
}

#Preview {
    HomeView()
        .modelContainer(for: [Dog.self, TrainingSession.self, CommandProgress.self], inMemory: true)
}
