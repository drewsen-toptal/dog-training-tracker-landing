import SwiftUI

struct ProgressRing: View {
    let progress: Double
    let size: CGFloat
    var lineWidth: CGFloat = 8
    var backgroundColor: Color = AppColors.background
    var foregroundColor: Color = AppColors.primary

    private var clampedProgress: Double {
        min(max(progress, 0), 1)
    }

    var body: some View {
        ZStack {
            // Background ring
            Circle()
                .stroke(backgroundColor, lineWidth: lineWidth)

            // Progress ring
            Circle()
                .trim(from: 0, to: clampedProgress)
                .stroke(
                    foregroundColor,
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(.spring(response: 0.6), value: clampedProgress)
        }
        .frame(width: size, height: size)
    }
}

struct ProgressRingWithLabel: View {
    let progress: Double
    let size: CGFloat
    var lineWidth: CGFloat = 8
    var label: String?
    var showPercentage: Bool = true

    var body: some View {
        ZStack {
            ProgressRing(
                progress: progress,
                size: size,
                lineWidth: lineWidth
            )

            VStack(spacing: 2) {
                if showPercentage {
                    Text("\(Int(progress * 100))%")
                        .font(.system(size: size * 0.25, weight: .bold))
                        .foregroundStyle(AppColors.textPrimary)
                }

                if let label {
                    Text(label)
                        .font(.system(size: size * 0.1, weight: .medium))
                        .foregroundStyle(AppColors.textSecondary)
                }
            }
        }
    }
}

#Preview {
    VStack(spacing: 24) {
        ProgressRing(progress: 0.75, size: 100)

        ProgressRingWithLabel(
            progress: 0.68,
            size: 120,
            lineWidth: 10,
            label: "Mastery"
        )

        HStack(spacing: 20) {
            ProgressRing(progress: 0.25, size: 50, lineWidth: 5, foregroundColor: AppColors.warning)
            ProgressRing(progress: 0.5, size: 50, lineWidth: 5, foregroundColor: AppColors.primary)
            ProgressRing(progress: 0.9, size: 50, lineWidth: 5, foregroundColor: AppColors.success)
        }
    }
    .padding()
    .background(Color.white)
}
