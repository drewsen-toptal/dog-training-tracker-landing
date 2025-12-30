import SwiftUI

struct DogAvatar: View {
    let name: String
    let imageData: Data?
    let size: CGFloat
    var showEditButton: Bool = false
    var onEditTap: (() -> Void)?

    init(
        name: String,
        imageData: Data? = nil,
        size: CGFloat = 64,
        showEditButton: Bool = false,
        onEditTap: (() -> Void)? = nil
    ) {
        self.name = name
        self.imageData = imageData
        self.size = size
        self.showEditButton = showEditButton
        self.onEditTap = onEditTap
    }

    private var initials: String {
        String(name.prefix(1)).uppercased()
    }

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Group {
                if let data = imageData, let uiImage = UIImage(data: data) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } else {
                    // Placeholder with gradient and initials
                    ZStack {
                        AppColors.primaryGradient

                        Text(initials)
                            .font(.system(size: size * 0.4, weight: .bold))
                            .foregroundStyle(.white)
                    }
                }
            }
            .frame(width: size, height: size)
            .clipShape(Circle())
            .shadow(color: AppColors.primary.opacity(0.3), radius: size * 0.1, y: size * 0.05)

            if showEditButton {
                Button {
                    onEditTap?()
                } label: {
                    Image(systemName: "camera.fill")
                        .font(.system(size: size * 0.15, weight: .semibold))
                        .foregroundStyle(AppColors.primary)
                        .frame(width: size * 0.3, height: size * 0.3)
                        .background(.white)
                        .clipShape(Circle())
                        .shadow(color: .black.opacity(0.15), radius: 4, y: 2)
                }
                .offset(x: size * 0.05, y: size * 0.05)
            }
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        DogAvatar(name: "Max", size: 80)
        DogAvatar(name: "Bella", size: 64, showEditButton: true)
        DogAvatar(name: "Charlie", size: 48)
    }
    .padding()
    .background(AppColors.background)
}
