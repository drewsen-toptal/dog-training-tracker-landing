import SwiftUI
import SwiftData

struct CommandListView: View {
    @Query private var dogs: [Dog]
    @Query private var commandProgress: [CommandProgress]
    @Query private var sessions: [TrainingSession]
    @State private var searchText = ""

    private var filteredCommands: [Command] {
        if searchText.isEmpty {
            return Command.allCommands
        }

        return Command.allCommands.filter { command in
            command.name.localizedStandardContains(searchText) ||
            command.description.localizedStandardContains(searchText)
        }
    }

    private func progressFor(command: Command) -> CommandProgress? {
        commandProgress.first { $0.commandId == command.id }
    }

    private func sessionCountFor(command: Command) -> Int {
        sessions.filter { session in
            session.commandsPracticed.contains(command.id)
        }.count
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // Header
                VStack(alignment: .leading, spacing: 4) {
                    Text("Commands")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundStyle(AppColors.textPrimary)

                    Text("Track progress for each command")
                        .font(.system(size: 15))
                        .foregroundStyle(AppColors.textSecondary)
                }
                .padding(.horizontal, 24)
                .padding(.top, 24)
                .padding(.bottom, 16)

                // Search Bar
                searchBar
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)

                // Commands List
                VStack(spacing: 12) {
                    ForEach(filteredCommands) { command in
                        NavigationLink {
                            CommandDetailView(command: command)
                        } label: {
                            CommandCard(
                                command: command,
                                progress: progressFor(command: command),
                                sessionCount: sessionCountFor(command: command)
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 100)
            }
        }
        .background(AppColors.background)
        .navigationBarHidden(true)
    }

    @ViewBuilder
    private var searchBar: some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(AppColors.textTertiary)

            TextField("Search commands...", text: $searchText)
                .font(.system(size: 16))
                .foregroundStyle(AppColors.textPrimary)
                .accessibilityLabel("Search commands")
                .accessibilityHint("Enter text to filter the commands list")
        }
        .padding(.horizontal, 16)
        .frame(height: 52)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay {
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color(red: 0.92, green: 0.92, blue: 0.92), lineWidth: 1)
        }
    }
}

#Preview {
    NavigationStack {
        CommandListView()
    }
    .modelContainer(for: [Dog.self, CommandProgress.self, TrainingSession.self], inMemory: true)
}
