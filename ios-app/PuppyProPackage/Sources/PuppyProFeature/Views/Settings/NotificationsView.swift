import SwiftUI
import SwiftData
import UserNotifications

struct NotificationsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var userSettings: [UserSettings]

    private var settings: UserSettings? {
        userSettings.first
    }

    @State private var notificationsEnabled: Bool = true
    @State private var reminderTime: Date = Calendar.current.date(bySettingHour: 9, minute: 0, second: 0, of: Date()) ?? Date()
    @State private var showingPermissionAlert = false
    @State private var permissionStatus: UNAuthorizationStatus = .notDetermined

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Premium animated header
                PremiumNotificationsHeader()
                    .padding(.bottom, AppSpacing.xl)

                VStack(spacing: AppSpacing.lg) {
                    // Main toggle card
                    notificationToggleCard

                    // Time picker (only if enabled)
                    if notificationsEnabled {
                        timePickerCard
                    }

                    // Info section
                    infoCard
                }
                .padding(.horizontal, AppSpacing.lg)
                .padding(.bottom, 100)
            }
        }
        .background(AppColors.background)
        .navigationTitle("Notifications")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            loadSettings()
            checkNotificationPermission()
        }
        .alert("Enable Notifications", isPresented: $showingPermissionAlert) {
            Button("Open Settings") {
                if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsUrl)
                }
            }
            Button("Cancel", role: .cancel) {
                notificationsEnabled = false
            }
        } message: {
            Text("Please enable notifications in Settings to receive training reminders.")
        }
    }

    @ViewBuilder
    private var notificationToggleCard: some View {
        HStack(spacing: AppSpacing.md) {
            // Icon
            ZStack {
                Circle()
                    .fill(notificationsEnabled ? AppColors.primary.opacity(0.12) : AppColors.textTertiary.opacity(0.1))
                    .frame(width: 48, height: 48)

                PiAPIIcon(name: PiAPIIcons.bell, size: 28)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text("Daily Reminder")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(AppColors.textPrimary)

                Text(notificationsEnabled ? "You'll be reminded daily" : "Reminders are off")
                    .font(.system(size: 14))
                    .foregroundStyle(AppColors.textSecondary)
            }

            Spacer()

            Toggle("", isOn: $notificationsEnabled)
                .tint(AppColors.primary)
                .onChange(of: notificationsEnabled) { _, newValue in
                    handleToggleChange(newValue)
                }
        }
        .padding(AppSpacing.lg)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.white)
                .shadow(color: AppColors.primary.opacity(0.08), radius: 16, y: 4)
        )
    }

    @ViewBuilder
    private var timePickerCard: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            HStack(spacing: AppSpacing.sm) {
                ZStack {
                    Circle()
                        .fill(AppColors.warning.opacity(0.12))
                        .frame(width: 36, height: 36)

                    Image(systemName: "clock.fill")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(AppColors.warning)
                }

                Text("Reminder Time")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(AppColors.textPrimary)
            }

            DatePicker(
                "Select time",
                selection: $reminderTime,
                displayedComponents: .hourAndMinute
            )
            .datePickerStyle(.wheel)
            .labelsHidden()
            .onChange(of: reminderTime) { _, newValue in
                updateReminderTime(newValue)
            }
        }
        .padding(AppSpacing.lg)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.white)
                .shadow(color: AppColors.primary.opacity(0.08), radius: 16, y: 4)
        )
    }

    @ViewBuilder
    private var infoCard: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            HStack(spacing: AppSpacing.sm) {
                ZStack {
                    Circle()
                        .fill(AppColors.success.opacity(0.12))
                        .frame(width: 36, height: 36)

                    Image(systemName: "lightbulb.fill")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(AppColors.success)
                }

                Text("Why Reminders Help")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(AppColors.textPrimary)
            }

            Text("Consistent training is the key to success. Dogs learn best with short, daily practice sessions. A gentle reminder helps you and your pup build good habits together.")
                .font(.system(size: 14))
                .foregroundStyle(AppColors.textSecondary)
                .lineSpacing(4)
        }
        .padding(AppSpacing.lg)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(AppColors.success.opacity(0.08))
        )
    }

    private func loadSettings() {
        if let settings = settings {
            notificationsEnabled = settings.dailyReminderEnabled
            if let time = settings.dailyReminderTime {
                reminderTime = time
            }
        }
    }

    private func checkNotificationPermission() {
        Task { @MainActor in
            let settings = await UNUserNotificationCenter.current().notificationSettings()
            permissionStatus = settings.authorizationStatus
        }
    }

    private func handleToggleChange(_ enabled: Bool) {
        if enabled {
            requestNotificationPermission()
        } else {
            cancelNotifications()
            updateSettings(enabled: false)
        }
    }

    private func requestNotificationPermission() {
        Task { @MainActor in
            do {
                let granted = try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])
                if granted {
                    updateSettings(enabled: true)
                    scheduleNotification()
                } else {
                    showingPermissionAlert = true
                }
            } catch {
                showingPermissionAlert = true
            }
        }
    }

    private func scheduleNotification() {
        cancelNotifications()

        let content = UNMutableNotificationContent()
        content.title = "Time to Train!"
        content.body = "A quick training session keeps your pup sharp. Let's practice!"
        content.sound = .default

        let components = Calendar.current.dateComponents([.hour, .minute], from: reminderTime)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)

        let request = UNNotificationRequest(
            identifier: "daily-training-reminder",
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request)
    }

    private func cancelNotifications() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["daily-training-reminder"])
    }

    private func updateSettings(enabled: Bool) {
        if let settings = settings {
            settings.dailyReminderEnabled = enabled
        } else {
            let newSettings = UserSettings()
            newSettings.dailyReminderEnabled = enabled
            modelContext.insert(newSettings)
        }
    }

    private func updateReminderTime(_ time: Date) {
        if let settings = settings {
            settings.dailyReminderTime = time
        }
        if notificationsEnabled {
            scheduleNotification()
        }
    }
}

// MARK: - Premium Animated Header

private struct PremiumNotificationsHeader: View {
    @State private var isFloating = false
    @State private var iconScale: CGFloat = 0.5
    @State private var iconOffset: CGFloat = 30
    @State private var textOpacity: Double = 0
    @State private var textOffset: CGFloat = 20

    var body: some View {
        VStack(spacing: 20) {
            // Animated icon with premium rings
            ZStack {
                // Outer pulsing ring
                Circle()
                    .fill(AppColors.warning.opacity(0.08))
                    .frame(width: 160, height: 160)
                    .scaleEffect(isFloating ? 1.05 : 0.95)
                    .animation(
                        .easeInOut(duration: 2.0)
                        .repeatForever(autoreverses: true),
                        value: isFloating
                    )

                // Middle ring
                Circle()
                    .fill(AppColors.warning.opacity(0.12))
                    .frame(width: 130, height: 130)
                    .scaleEffect(iconScale)

                // Inner ring
                Circle()
                    .fill(AppColors.warning.opacity(0.18))
                    .frame(width: 100, height: 100)
                    .scaleEffect(iconScale)

                // Bell icon with bounce and float
                PiAPIIcon(name: PiAPIIcons.bell, size: 56)
                    .scaleEffect(iconScale)
                    .offset(y: iconOffset + (isFloating ? -6 : 0))
            }
            .animation(
                .easeInOut(duration: 1.5)
                .repeatForever(autoreverses: true),
                value: isFloating
            )

            // Premium text
            VStack(spacing: 8) {
                Text("Training Reminders")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundStyle(AppColors.textPrimary)

                Text("Get daily reminders to keep\nyour training consistent")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
            }
            .opacity(textOpacity)
            .offset(y: textOffset)
        }
        .padding(.top, AppSpacing.xl)
        .onAppear {
            startEntranceAnimation()
        }
    }

    private func startEntranceAnimation() {
        // Icon bounces in
        withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
            iconScale = 1.0
            iconOffset = 0
        }

        // Text fades up after icon
        withAnimation(.easeOut(duration: 0.5).delay(0.2)) {
            textOpacity = 1.0
            textOffset = 0
        }

        // Start floating animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            isFloating = true
        }
    }
}

#Preview {
    NavigationStack {
        NotificationsView()
    }
    .modelContainer(for: UserSettings.self, inMemory: true)
}
