import SwiftUI
import SwiftData

struct TrainingSessionView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Environment(SubscriptionManager.self) private var subscriptionManager

    let dog: Dog

    /// Optional initial command - if provided, training starts with this command
    let initialCommand: Command?

    /// When true, only train the single initial command (from command detail view)
    let singleCommandMode: Bool

    @State private var session: TrainingSession?
    @State private var currentCommandIndex = 0
    @State private var successCount = 0
    @State private var failCount = 0
    @State private var targetReps = 10
    @State private var elapsedSeconds = 0
    @State private var timerTask: Task<Void, Never>?
    @State private var showingSessionComplete = false
    @State private var hasStartedSession = false
    @State private var showingMiniCelebration = false
    @State private var completedCommandName = ""

    /// Commands for this session - stored as @State to prevent reshuffling on each access
    @State private var commands: [Command] = []

    init(dog: Dog, initialCommand: Command? = nil, singleCommandMode: Bool = false) {
        self.dog = dog
        self.initialCommand = initialCommand
        self.singleCommandMode = singleCommandMode
    }

    /// Generate session commands based on subscription tier
    private static func generateCommands(initialCommand: Command?, tier: SubscriptionTier, singleCommandMode: Bool) -> [Command] {
        // Single command mode: only train the specified command
        if singleCommandMode, let command = initialCommand, command.isAccessible(with: tier) {
            return [command]
        }

        // Filter commands based on subscription tier
        let accessibleCommands = Command.allCommands.filter { $0.isAccessible(with: tier) }

        // Command count per session based on tier
        let commandCount: Int
        switch tier {
        case .free:
            commandCount = 3  // Free: 3 commands per session
        case .goodBoy, .bestFriend, .packLeader:
            commandCount = 5  // Paid: 5 commands per session
        }

        if let initial = initialCommand, initial.isAccessible(with: tier) {
            // Start with the selected command, then add others from same category
            var sessionCommands = [initial]
            let relatedCommands = accessibleCommands
                .filter { $0.id != initial.id && $0.category == initial.category }
                .shuffled()
                .prefix(2)
            sessionCommands.append(contentsOf: relatedCommands)

            // Fill remaining slots with random other accessible commands
            let remainingCommands = accessibleCommands
                .filter { cmd in !sessionCommands.contains { $0.id == cmd.id } }
                .shuffled()
                .prefix(commandCount - sessionCommands.count)
            sessionCommands.append(contentsOf: remainingCommands)

            return Array(sessionCommands.prefix(commandCount))
        } else {
            // No specific command - shuffle accessible commands and pick based on tier
            return Array(accessibleCommands.shuffled().prefix(commandCount))
        }
    }

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

                    // Main content (scrollable)
                    ScrollView {
                        VStack(spacing: AppSpacing.lg) {
                            if let command = currentCommand {
                                // Command display
                                commandDisplayView(command)
                            }
                        }
                        .padding(.horizontal, AppSpacing.lg)
                        .padding(.top, AppSpacing.lg)
                    }

                    // Fixed bottom section - always visible
                    VStack(spacing: AppSpacing.md) {
                        // Rep counter - always visible
                        if currentCommand != nil {
                            repCounterView
                                .padding(.horizontal, AppSpacing.lg)
                                .padding(.bottom, AppSpacing.xs)
                        }

                        // Response buttons - always visible
                        responseButtonsSection
                            .padding(.horizontal, AppSpacing.lg)

                        // Progress dots
                        progressDotsView

                        // Skip button
                        Button("Skip this command") {
                            nextCommand()
                        }
                        .font(AppFonts.subheadline())
                        .foregroundStyle(.white.opacity(0.5))
                        .accessibilityLabel("Skip Command")
                        .accessibilityHint("Double-tap to skip to the next command")
                    }
                    .padding(.top, AppSpacing.sm)
                    .padding(.bottom, AppSpacing.xl)
                }

                // Mini celebration overlay
                if showingMiniCelebration {
                    MiniCelebrationOverlay(commandName: completedCommandName)
                        .transition(.scale.combined(with: .opacity))
                }
            }
            .animation(.spring(response: 0.4, dampingFraction: 0.7), value: showingMiniCelebration)
            .navigationBarHidden(true)
            .onAppear {
                // Initialize commands and session only once
                guard !hasStartedSession else { return }
                hasStartedSession = true

                if commands.isEmpty {
                    commands = Self.generateCommands(
                        initialCommand: initialCommand,
                        tier: subscriptionManager.currentTier,
                        singleCommandMode: singleCommandMode
                    )
                }
                startSession()
            }
            .onDisappear {
                timerTask?.cancel()
            }
            .fullScreenCover(isPresented: $showingSessionComplete) {
                // Always show celebration - use session if available, otherwise create summary
                if let session {
                    SessionCompleteView(session: session) {
                        dismiss()
                    }
                } else {
                    // Fallback: create a temporary session for display
                    SessionCompleteView(
                        session: TrainingSession(dog: dog, commandIds: commands.map { $0.id })
                    ) {
                        dismiss()
                    }
                }
            }
        }
    }

    @ViewBuilder
    private var headerView: some View {
        HStack {
            // Close button - glass effect with X icon
            Button {
                endSession()
                dismiss()
            } label: {
                ZStack {
                    Circle()
                        .fill(.ultraThinMaterial)
                        .frame(width: 44, height: 44)
                    Circle()
                        .stroke(.white.opacity(0.2), lineWidth: 1)
                        .frame(width: 44, height: 44)
                    Image(systemName: "xmark")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.white)
                }
            }
            .accessibilityLabel("End Session")
            .accessibilityHint("Double-tap to end the training session and return")

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

            // Timer badge - premium design with clock icon
            HStack(spacing: 6) {
                Image(systemName: "clock.fill")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(AppColors.primary)
                Text(formattedTime)
                    .font(.system(size: 15, weight: .bold, design: .monospaced))
                    .foregroundStyle(Color(red: 0.15, green: 0.15, blue: 0.17))
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(
                Capsule()
                    .fill(.white)
                    .shadow(color: .black.opacity(0.15), radius: 8, y: 4)
            )
        }
        .padding(.horizontal, AppSpacing.lg)
        .padding(.vertical, AppSpacing.md)
    }

    private var formattedTime: String {
        let minutes = elapsedSeconds / 60
        let seconds = elapsedSeconds % 60
        return String(format: "%d:%02d", minutes, seconds)
    }

    /// Get mastery progress for the current command
    private func getMasteryProgress(for command: Command) -> Double {
        guard let progress = dog.commandProgress?.first(where: { $0.commandId == command.id }) else {
            return 0
        }
        return progress.status.progressPercentage
    }

    @ViewBuilder
    private func commandDisplayView(_ command: Command) -> some View {
        let masteryProgress = getMasteryProgress(for: command)

        VStack(spacing: AppSpacing.sm) {
            // Top row: Difficulty badge
            HStack {
                DifficultyBadge(difficulty: command.difficulty)
                Spacer()
                VoiceToneBadge(voiceTone: command.voiceTone)
            }

            // Hero icon with mastery ring - cohesive circular design
            ZStack {
                // Mastery progress ring (outer)
                Circle()
                    .stroke(Color.white.opacity(0.1), lineWidth: 5)
                    .frame(width: 140, height: 140)

                Circle()
                    .trim(from: 0, to: masteryProgress)
                    .stroke(
                        AppColors.success,
                        style: StrokeStyle(lineWidth: 5, lineCap: .round)
                    )
                    .frame(width: 140, height: 140)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeOut(duration: 0.5), value: masteryProgress)

                // Command icon - circular to match mastery ring
                ZStack {
                    AppColors.primaryGradient
                    PiAPIIcon(name: command.piAPIIconName, size: 56)
                }
                .frame(width: 116, height: 116)
                .clipShape(Circle())
                .shadow(color: AppColors.primary.opacity(0.4), radius: 16, y: 6)
            }
            .padding(.vertical, AppSpacing.xs)

            // Command name with motivational phrase
            VStack(spacing: 2) {
                Text(command.name.uppercased())
                    .font(.system(size: 26, weight: .bold))
                    .foregroundStyle(.white)

                Text(command.motivationalPhrase)
                    .font(AppFonts.caption())
                    .foregroundStyle(.white.opacity(0.5))
                    .italic()
            }

            // Hand signal section
            HandSignalView(handSignal: command.handSignal)

            // Training tip
            if let firstStep = command.steps.first {
                HStack(spacing: AppSpacing.sm) {
                    Image(systemName: "lightbulb.fill")
                        .font(.system(size: 14))
                        .foregroundStyle(.yellow)
                    Text(firstStep.instruction)
                        .font(AppFonts.subheadline())
                        .foregroundStyle(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                }
                .padding(.horizontal, AppSpacing.md)
                .padding(.vertical, AppSpacing.sm)
                .background(
                    RoundedRectangle(cornerRadius: AppRadius.md)
                        .fill(.white.opacity(0.08))
                )
            }
        }
        .padding(.horizontal, AppSpacing.md)
        .padding(.vertical, AppSpacing.sm)
        .frame(maxWidth: .infinity)
        .background(
            ZStack {
                // Glassmorphism background
                RoundedRectangle(cornerRadius: AppRadius.xl)
                    .fill(.ultraThinMaterial)
                    .environment(\.colorScheme, .dark)

                // Gradient border
                RoundedRectangle(cornerRadius: AppRadius.xl)
                    .stroke(
                        LinearGradient(
                            colors: [
                                AppColors.primary.opacity(0.6),
                                AppColors.primary.opacity(0.2),
                                .white.opacity(0.1)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1.5
                    )
            }
        )
    }
}

// MARK: - Premium Component Views

struct DifficultyBadge: View {
    let difficulty: Difficulty

    private var badgeColor: Color {
        switch difficulty {
        case .beginner: return AppColors.success
        case .intermediate: return AppColors.warning
        case .advanced: return AppColors.error
        }
    }

    var body: some View {
        HStack(spacing: 4) {
            Circle()
                .fill(badgeColor)
                .frame(width: 6, height: 6)
            Text(difficulty.displayName.uppercased())
                .font(.system(size: 10, weight: .bold))
                .tracking(0.5)
        }
        .foregroundStyle(.white.opacity(0.8))
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(
            Capsule()
                .fill(badgeColor.opacity(0.2))
        )
    }
}

struct VoiceToneBadge: View {
    let voiceTone: VoiceTone

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: voiceTone.icon)
                .font(.system(size: 10, weight: .semibold))
            Text(voiceTone.displayName)
                .font(.system(size: 10, weight: .bold))
                .tracking(0.3)
        }
        .foregroundStyle(.white.opacity(0.8))
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(
            Capsule()
                .fill(.white.opacity(0.1))
        )
    }
}

struct HandSignalView: View {
    let handSignal: HandSignal

    var body: some View {
        HStack(spacing: AppSpacing.md) {
            // Hand signal icon
            ZStack {
                Circle()
                    .fill(AppColors.primary.opacity(0.15))
                    .frame(width: 44, height: 44)
                Image(systemName: handSignal.icon)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(AppColors.primary)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text("HAND SIGNAL")
                    .font(.system(size: 9, weight: .bold))
                    .tracking(0.5)
                    .foregroundStyle(.white.opacity(0.5))
                Text(handSignal.description)
                    .font(AppFonts.subheadline())
                    .fontWeight(.medium)
                    .foregroundStyle(.white)
            }

            Spacer()
        }
        .padding(AppSpacing.sm)
        .background(
            RoundedRectangle(cornerRadius: AppRadius.md)
                .fill(.white.opacity(0.05))
        )
    }
}

// MARK: - TrainingSessionView Continued

extension TrainingSessionView {
    @ViewBuilder
    var repCounterView: some View {
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
        }, size: 120, showPulseRing: false)
        .padding(.vertical, AppSpacing.sm)
    }

    @ViewBuilder
    private var responseButtonsSection: some View {
        HStack(spacing: AppSpacing.md) {
            FailButton(title: "Needs Work", iconName: PiAPIIcons.close) {
                recordRep(success: false)
            }

            SuccessButton(title: "Success!", iconName: PiAPIIcons.checkmark) {
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

        // Update CommandProgress for the current command
        if let command = currentCommand {
            let progress = getOrCreateCommandProgress(for: command)
            progress.recordPractice(wasSuccessful: success)
        }

        // Save immediately so data persists
        try? modelContext.save()

        // Check if target reached
        if totalReps >= targetReps {
            nextCommand()
        }

        // Haptic feedback
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(success ? .success : .warning)
    }

    /// Gets existing CommandProgress for the given command, or creates a new one
    private func getOrCreateCommandProgress(for command: Command) -> CommandProgress {
        // Check if progress already exists for this command
        if let existingProgress = dog.commandProgress?.first(where: { $0.commandId == command.id }) {
            return existingProgress
        }

        // Create new CommandProgress
        let newProgress = CommandProgress(commandId: command.id, dog: dog)
        modelContext.insert(newProgress)

        // Add to dog's commandProgress array
        if dog.commandProgress == nil {
            dog.commandProgress = []
        }
        dog.commandProgress?.append(newProgress)

        return newProgress
    }

    private func nextCommand() {
        if currentCommandIndex < commands.count - 1 {
            // Show mini celebration for completing this command
            completedCommandName = currentCommand?.name ?? "Command"
            showingMiniCelebration = true

            // Haptic feedback
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)

            // Move to next command after celebration
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                showingMiniCelebration = false
                currentCommandIndex += 1
                successCount = 0
                failCount = 0
            }
        } else {
            // Session complete - end first, then show celebration
            endSession()
            // Small delay to ensure state is saved before showing celebration
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                showingSessionComplete = true
            }
        }
    }

    private func endSession() {
        timerTask?.cancel()
        session?.endSession()
        try? modelContext.save()
    }
}

// MARK: - Mini Celebration Overlay

struct MiniCelebrationOverlay: View {
    let commandName: String

    @State private var scale: CGFloat = 0.5
    @State private var showStars = false
    @State private var showLottie = false

    var body: some View {
        ZStack {
            // Semi-transparent background
            Color.black.opacity(0.6)
                .ignoresSafeArea()

            VStack(spacing: AppSpacing.lg) {
                // Animated checkmark with Lottie
                ZStack {
                    Circle()
                        .fill(AppColors.success)
                        .frame(width: 100, height: 100)
                        .shadow(color: AppColors.success.opacity(0.5), radius: 20, y: 8)

                    if showLottie {
                        LottieView.checkmark(size: 70)
                    }
                }
                .scaleEffect(scale)

                VStack(spacing: AppSpacing.xs) {
                    Text("\(commandName) Complete!")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundStyle(.white)

                    Text("Great job! Moving to next command...")
                        .font(AppFonts.body())
                        .foregroundStyle(.white.opacity(0.8))
                }

                // Mini stars
                if showStars {
                    HStack(spacing: AppSpacing.md) {
                        ForEach(0..<5) { i in
                            Image(systemName: "star.fill")
                                .font(.system(size: 20))
                                .foregroundStyle(.yellow)
                                .scaleEffect(showStars ? 1 : 0)
                                .animation(
                                    .spring(response: 0.4, dampingFraction: 0.5)
                                        .delay(Double(i) * 0.1),
                                    value: showStars
                                )
                        }
                    }
                }
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                scale = 1.0
            }
            // Show Lottie checkmark
            showLottie = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                showStars = true
            }
        }
    }
}

#Preview("Random Commands") {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Dog.self, TrainingSession.self, configurations: config)

    let dog = Dog(name: "Max", breed: "Golden Retriever")
    container.mainContext.insert(dog)

    return TrainingSessionView(dog: dog)
        .modelContainer(container)
        .environment(SubscriptionManager())
}

#Preview("Specific Command - Sit") {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Dog.self, TrainingSession.self, configurations: config)

    let dog = Dog(name: "Max", breed: "Golden Retriever")
    container.mainContext.insert(dog)

    return TrainingSessionView(dog: dog, initialCommand: Command.allCommands.first { $0.name == "Sit" })
        .modelContainer(container)
        .environment(SubscriptionManager())
}
