import SwiftUI
import SwiftData
import PhotosUI

struct AddDogView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var breed = ""
    @State private var birthDate = Date()
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var photoData: Data?
    @State private var showingBirthDatePicker = false

    private var isValid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: AppSpacing.xl) {
                    // Photo picker
                    photoSection

                    // Form fields
                    VStack(spacing: AppSpacing.md) {
                        // Name
                        VStack(alignment: .leading, spacing: AppSpacing.xs) {
                            Text("Name")
                                .font(AppFonts.caption())
                                .foregroundStyle(AppColors.textSecondary)
                                .textCase(.uppercase)

                            TextField("What's your pup's name?", text: $name)
                                .font(AppFonts.body())
                                .padding(AppSpacing.md)
                                .background(.white)
                                .clipShape(.rect(cornerRadius: AppRadius.md))
                        }

                        // Breed
                        VStack(alignment: .leading, spacing: AppSpacing.xs) {
                            Text("Breed")
                                .font(AppFonts.caption())
                                .foregroundStyle(AppColors.textSecondary)
                                .textCase(.uppercase)

                            TextField("Optional", text: $breed)
                                .font(AppFonts.body())
                                .padding(AppSpacing.md)
                                .background(.white)
                                .clipShape(.rect(cornerRadius: AppRadius.md))
                        }

                        // Birth Date
                        VStack(alignment: .leading, spacing: AppSpacing.xs) {
                            Text("Birthday")
                                .font(AppFonts.caption())
                                .foregroundStyle(AppColors.textSecondary)
                                .textCase(.uppercase)

                            Button {
                                showingBirthDatePicker.toggle()
                            } label: {
                                HStack {
                                    Text(birthDate, style: .date)
                                        .font(AppFonts.body())
                                        .foregroundStyle(AppColors.textPrimary)
                                    Spacer()
                                    Image(systemName: "calendar")
                                        .foregroundStyle(AppColors.primary)
                                }
                                .padding(AppSpacing.md)
                                .background(.white)
                                .clipShape(.rect(cornerRadius: AppRadius.md))
                            }

                            if showingBirthDatePicker {
                                DatePicker(
                                    "",
                                    selection: $birthDate,
                                    in: ...Date(),
                                    displayedComponents: .date
                                )
                                .datePickerStyle(.wheel)
                                .labelsHidden()
                            }
                        }
                    }

                    Spacer(minLength: AppSpacing.xxl)

                    // Save button
                    PrimaryButton(
                        title: "Add \(name.isEmpty ? "Dog" : name)",
                        icon: "plus.circle.fill",
                        isDisabled: !isValid
                    ) {
                        saveDog()
                    }
                }
                .padding(AppSpacing.lg)
            }
            .background(AppColors.background)
            .navigationTitle("Add Your Pup")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundStyle(AppColors.textSecondary)
                }
            }
        }
    }

    @ViewBuilder
    private var photoSection: some View {
        PhotosPicker(selection: $selectedPhoto, matching: .images) {
            VStack(spacing: AppSpacing.sm) {
                DogAvatar(
                    name: name.isEmpty ? "?" : name,
                    imageData: photoData,
                    size: 120,
                    showEditButton: true
                )

                Text("Add Photo")
                    .font(AppFonts.subheadline())
                    .foregroundStyle(AppColors.primary)
            }
        }
        .onChange(of: selectedPhoto) { _, newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                    photoData = data
                }
            }
        }
    }

    private func saveDog() {
        let dog = Dog(
            name: name.trimmingCharacters(in: .whitespaces),
            breed: breed.isEmpty ? nil : breed.trimmingCharacters(in: .whitespaces),
            birthDate: birthDate,
            photoData: photoData
        )

        modelContext.insert(dog)
        dismiss()
    }
}

#Preview {
    AddDogView()
        .modelContainer(for: Dog.self, inMemory: true)
}
