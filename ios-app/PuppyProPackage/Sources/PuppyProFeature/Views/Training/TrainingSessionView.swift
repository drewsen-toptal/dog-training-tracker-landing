import SwiftUI
import SwiftData

struct TrainingSessionView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    let dog: Dog

    @State private var session: TrainingSession?
    @State private var currentCommandIndex = 0
    @State private var successCount = 0
    @State private var failCount = 0
    @State private var targetReps = 10
    @State private var elapsedSeconds = 0
    @State private var timerTask: Task<Void, Never>?
    @State private var showingSessionComplete = false

    private let commands: [Command] = Array(Command.allCommands.prefix(5))

    private var currentCommand: Command? {
        guard currentCommandIndex < commands.count else { return nil }
        return commands[currentCommandIndex]
    }

    private var totalReps: Int {
        successCount + failCount
    }

    private var progress: Double {
        Double(currentCommandIndex) / Double(commands.count)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                // Dark background
                Color(red: 0.15, green: 0.15, blue: 0.17)
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    // Header
                    headerView

                    // Main content
                    ScrollView {
                        VStack(spacing: AppSpacing.xl) {
                            if let command = currentCommand {
                                // Command display
                                commandDisplayView(command)

                                // Rep counter
                                repCounterView

                                // Clicker button
                                clickerSection

                                // Response buttons
                                responseButtonsSection
                            }
                        }
                        .padding(AppSpacing.lg)
                    }

                    // Progress dots
                    progressDotsView
                        .padding(.bottom, AppSpacing.md)

                    // Skip button
                    Button("Skip this command") {
                        nextCommand()
                    }
                    .font(AppFonts.subheadline())
                    .foregroundStyle(.white.opacity(0.5))
                    .padding(.bottom, AppSpacing.xxl)
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                startSession()
            }
            .onDisappear {
                timerTask?.cancel()
            }
            .fullScreenCover(isPresented: $showingSessionComplete) {
                if let session {
                    SessionCompleteView(session: session) {
                        dismiss()
                    }
                }
            }
        }
    }

    @ViewBuilder
    private var headerView: some View {
        HStack {
            Button {
                endSession()
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.body.weight(.semibold))
                    .foregroundStyle(.white)
                    .frame(width: 36, height: 36)
                    .background(.white.opacity(0.15))
                    .clipShape(Circle())
            }

            Spacer()

            VStack(spacing: 2) {
                Text("TRAINING SESSION")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white.opacity(0.7))
                    .tracking(0.5)

                Text(currentCommand?.name ?? "")
                    .font(.title2.weight(.bold))
                    .foregroundStyle(.white)
            }

            Spacer()

            // Timer badge
            Text(formattedTime)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(Color(red: 0.15, green: 0.15, blue: 0.17))
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(.white)
                .clipShape(.rect(cornerRadius: 20))
        }
        .padding(.horizontal, AppSpacing.lg)
        .padding(.vertical, AppSpacing.md)
    }

    private var formattedTime: String {
        let minutes = elapsedSeconds / 60
        let seconds = elapsedSeconds % 60
        return String(format: "%d:%02d", minutes, seconds)
    }

    @ViewBuilder
    private func commandDisplayView(_ command: Command) -> some View {
        VStack(spacing: AppSpacing.lg) {
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
                            .font(.system(size: 40))
                            .foregroundStyle(.white)
                    }
                }
            }
            .frame(width: 100, height: 100)
            .clipShape(.rect(cornerRadius: AppRadius.lg))
            .shadow(color: AppColors.primary.opacity(0.3), radius: 16, y: 8)

            // Command name
            Text(command.name.uppercased())
                .font(.system(size: 36, weight: .bold))
                .foregroundStyle(.white)

            // Command hint
            if let firstStep = command.steps.first {
                Text(firstStep.instruction)
                    .font(AppFonts.body())
                    .foregroundStyle(.white.opacity(0.6))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
        }
        .padding(AppSpacing.xl)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: AppRadius.xl)
                .fill(Color(red: 0.2, green: 0.2, blue: 0.22))
        )
    }

    @ViewBuilder
    private var repCounterView: some View {
        HStack(spacing: AppSpacing.lg) {
            VStack(spacing: AppSpacing.xxs) {
                Text("\(successCount)")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundStyle(AppColors.success)
                Text("SUCCESS")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white.opacity(0.5))
                    .tracking(0.5)
            }

            Divider()
                .frame(height: 48)
                .background(.white.opacity(0.15))

            VStack(spacing: AppSpacing.xxs) {
                Text("\(failCount)")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundStyle(AppColors.warning)
                Text("NEEDS WORK")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white.opacity(0.5))
                    .tracking(0.5)
            }

            Divider()
                .frame(height: 48)
                .background(.white.opacity(0.15))

            VStack(spacing: AppSpacing.xxs) {
                Text("\(targetReps)")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundStyle(.white)
                Text("TARGET")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white.opacity(0.5))
                    .tracking(0.5)
            }
        }
    }

    @ViewBuilder
    private var clickerSection: some View {
        ClickerButton(onTap: {
            // Just haptic feedback - don't count as success/fail
            let impact = UIImpactFeedbackGenerator(style: .heavy)
            impact.impactOccurred()
        }, size: 160)
        .padding(.vertical, AppSpacing.md)
    }

    @ViewBuilder
    private var responseButtonsSection: some View {
        HStack(spacing: AppSpacing.md) {
            FailButton(title: "Needs Work", icon: "xmark") {
                recordRep(success: false)
            }

            SuccessButton(title: "Success!", icon: "checkmark") {
                recordRep(success: true)
            }
        }
    }

    @ViewBuilder
    private var progressDotsView: some View {
        HStack(spacing: 8) {
            ForEach(0..<commands.count, id: \.self) { index in
                if index < currentCommandIndex {
                    // Completed
                    Circle()
                        .fill(AppColors.success)
                        .frame(width: 8, height: 8)
                } else if index == currentCommandIndex {
                    // Current
                    Capsule()
                        .fill(AppColors.primary)
                        .frame(width: 24, height: 8)
                } else {
                    // Upcoming
                    Circle()
                        .fill(.white.opacity(0.3))
                        .frame(width: 8, height: 8)
                }
            }
        }
    }

    private func startSession() {
        session = TrainingSession(
            dog: dog,
            commandIds: commands.map { $0.id }
        )

        if let session {
            modelContext.insert(session)
        }

        // Start timer using Task
        timerTask = Task { @MainActor in
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(1))
                if !Task.isCancelled {
                    elapsedSeconds += 1
                }
            }
        }
    }

    private func recordRep(success: Bool) {
        if success {
            successCount += 1
        } else {
            failCount += 1
        }

        session?.recordRep(wasSuccessful: success)

        // Check if target reached
        if totalReps >= targetReps {
            nextCommand()
        }

        // Haptic feedback
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(success ? .success : .warning)
    }

    private func nextCommand() {
        if currentCommandIndex < commands.count - 1 {
            currentCommandIndex += 1
            successCount = 0
            failCount = 0
        } else {
            // Session complete
            endSession()
            showingSessionComplete = true
        }
    }

    private func endSession() {
        timerTask?.cancel()
        session?.endSession()
        try? modelContext.save()
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Dog.self, TrainingSession.self, configurations: config)

    let dog = Dog(name: "Max", breed: "Golden Retriever")
    container.mainContext.insert(dog)

    return TrainingSessionView(dog: dog)
        .modelContainer(container)
}
