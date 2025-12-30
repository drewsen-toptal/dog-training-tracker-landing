import SwiftUI
import SwiftData

struct CommandListView: View {
    @Query private var dogs: [Dog]
    @State private var searchText = ""
    @State private var selectedCategory: CommandCategory?

    private var currentDog: Dog? {
        dogs.first
    }

    private var filteredCommands: [Command] {
        var commands = Command.allCommands

        // Filter by category
        if let category = selectedCategory {
            commands = commands.filter { $0.category == category }
        }

        // Filter by search
        if !searchText.isEmpty {
            commands = commands.filter { command in
                command.name.localizedStandardContains(searchText) ||
                command.description.localizedStandardContains(searchText)
            }
        }

        return commands
    }

    private var commandsByCategory: [CommandCategory: [Command]] {
        Dictionary(grouping: filteredCommands, by: { $0.category })
    }

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.lg) {
                // Category filter
                categoryFilter

                // Commands list
                if selectedCategory != nil {
                    // Flat list when category selected
                    VStack(spacing: AppSpacing.sm) {
                        ForEach(filteredCommands) { command in
                            NavigationLink {
                                CommandDetailView(command: command)
                            } label: {
                                CommandCard(command: command, progress: nil)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                } else {
                    // Grouped by category
                    ForEach(CommandCategory.allCases) { category in
                        if let commands = commandsByCategory[category], !commands.isEmpty {
                            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                                HStack {
                                    Image(systemName: category.iconName)
                                        .foregroundStyle(AppColors.primary)

                                    Text(category.displayName)
                                        .font(AppFonts.headline())
                                        .foregroundStyle(AppColors.textPrimary)

                                    Spacer()

                                    Text("\(commands.count)")
                                        .font(AppFonts.subheadline())
                                        .foregroundStyle(AppColors.textSecondary)
                                }
                                .padding(.horizontal, AppSpacing.xs)

                                ForEach(commands) { command in
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
                }
            }
            .padding(.horizontal, AppSpacing.lg)
            .padding(.bottom, 100)
        }
        .background(AppColors.background)
        .navigationTitle("Commands")
        .searchable(text: $searchText, prompt: "Search commands...")
    }

    @ViewBuilder
    private var categoryFilter: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: AppSpacing.sm) {
                categoryChip(nil, title: "All")

                ForEach(CommandCategory.allCases) { category in
                    categoryChip(category, title: category.displayName)
                }
            }
            .padding(.horizontal, AppSpacing.xs)
        }
    }

    @ViewBuilder
    private func categoryChip(_ category: CommandCategory?, title: String) -> some View {
        let isSelected = selectedCategory == category

        Button {
            withAnimation(.spring(response: 0.3)) {
                selectedCategory = category
            }
        } label: {
            HStack(spacing: AppSpacing.xxs) {
                if let category {
                    Image(systemName: category.iconName)
                        .font(.caption)
                }
                Text(title)
                    .font(AppFonts.subheadline())
                    .fontWeight(.medium)
            }
            .foregroundStyle(isSelected ? .white : AppColors.textPrimary)
            .padding(.horizontal, AppSpacing.md)
            .padding(.vertical, AppSpacing.sm)
            .background(isSelected ? AppColors.primary : .white)
            .clipShape(.rect(cornerRadius: AppRadius.full))
            .shadow(color: .black.opacity(isSelected ? 0 : 0.05), radius: 4, y: 2)
        }
    }
}

#Preview {
    NavigationStack {
        CommandListView()
    }
    .modelContainer(for: Dog.self, inMemory: true)
}
