import SwiftUI

struct DogAvatar: View {
    let name: String
    let breed: String?
    let imageData: Data?
    let size: CGFloat
    var showEditButton: Bool = false
    var onEditTap: (() -> Void)?

    init(
        name: String,
        breed: String? = nil,
        imageData: Data? = nil,
        size: CGFloat = 64,
        showEditButton: Bool = false,
        onEditTap: (() -> Void)? = nil
    ) {
        self.name = name
        self.breed = breed
        self.imageData = imageData
        self.size = size
        self.showEditButton = showEditButton
        self.onEditTap = onEditTap
    }

    /// Maps breed to a cartoon dog avatar from our 3D avatar set
    private var breedAvatarIcon: String {
        guard let breed = breed?.lowercased() else {
            return PiAPIIcons.dogDefault
        }

        // Map breed categories to cartoon dog breed avatars
        switch breed {
        case let b where b.contains("golden") || b.contains("retriever"):
            return PiAPIIcons.dogGoldenRetriever
        case let b where b.contains("labrador") || b.contains("lab"):
            return PiAPIIcons.dogLabrador
        case let b where b.contains("german shepherd") || b.contains("shepherd"):
            return PiAPIIcons.dogGermanShepherd
        case let b where b.contains("husky") || b.contains("malamute"):
            return PiAPIIcons.dogHusky
        case let b where b.contains("corgi"):
            return PiAPIIcons.dogCorgi
        case let b where b.contains("poodle"):
            return PiAPIIcons.dogPoodle
        case let b where b.contains("bulldog") || b.contains("boxer") || b.contains("mastiff"):
            return PiAPIIcons.dogBulldog
        case let b where b.contains("beagle") || b.contains("hound"):
            return PiAPIIcons.dogBeagle
        case let b where b.contains("pomeranian") || b.contains("spitz"):
            return PiAPIIcons.dogPomeranian
        default:
            return PiAPIIcons.dogDefault
        }
    }

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Group {
                if let data = imageData, let uiImage = UIImage(data: data) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: size, height: size)
                        .clipShape(Circle())
                } else {
                    // Use breed-specific cartoon dog avatar
                    PiAPIIcon(name: breedAvatarIcon, size: size, clipToCircle: true)
                }
            }
            .shadow(color: AppColors.primary.opacity(0.3), radius: size * 0.1, y: size * 0.05)

            if showEditButton {
                Button {
                    onEditTap?()
                } label: {
                    PiAPIIcon(name: PiAPIIcons.camera, size: size * 0.2)
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
        DogAvatar(name: "Max", breed: "Golden Retriever", size: 80)
        DogAvatar(name: "Bella", breed: "Pomeranian", size: 64, showEditButton: true)
        DogAvatar(name: "Charlie", breed: "Corgi", size: 64)
        DogAvatar(name: "Luna", breed: "Husky", size: 64)
        DogAvatar(name: "Rocky", breed: "Bulldog", size: 48)
    }
    .padding()
    .background(AppColors.background)
}
