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
            VStack(spacing: AppSpacing.xl) {
                // Header
                headerSection

                // Main toggle
                notificationToggle

                // Time picker (only if enabled)
                if notificationsEnabled {
                    timePickerSection
                }

                // Info section
                infoSection
            }
            .padding(AppSpacing.lg)
        }
        .background(AppColors.background)
        .navigationTitle("Notifications")
        .navigationBarTitleDisplayMode(.large)
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
    private var headerSection: some View {
        VStack(spacing: AppSpacing.md) {
            ZStack {
                Circle()
                    .fill(AppColors.warning.opacity(0.15))
                    .frame(width: 100, height: 100)

                PiAPIIcon(name: PiAPIIcons.bell, size: 56)
            }

            Text("Training Reminders")
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(AppColors.textPrimary)

            Text("Get daily reminders to keep your training consistent")
                .font(.system(size: 15))
                .foregroundStyle(AppColors.textSecondary)
                .multilineTextAlignment(.center)
        }
        .padding(.top, AppSpacing.lg)
    }

    @ViewBuilder
    private var notificationToggle: some View {
        HStack {
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
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.lg))
        .shadow(color: .black.opacity(0.05), radius: 10, y: 2)
    }

    @ViewBuilder
    private var timePickerSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text("Reminder Time")
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(AppColors.textPrimary)

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
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.lg))
        .shadow(color: .black.opacity(0.05), radius: 10, y: 2)
    }

    @ViewBuilder
    private var infoSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            HStack(spacing: AppSpacing.sm) {
                Image(systemName: "lightbulb.fill")
                    .font(.system(size: 16))
                    .foregroundStyle(AppColors.warning)

                Text("Why Reminders Help")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(AppColors.textPrimary)
            }

            Text("Consistent training is the key to success. Dogs learn best with short, daily practice sessions. A gentle reminder helps you and your pup build good habits together.")
                .font(.system(size: 14))
                .foregroundStyle(AppColors.textSecondary)
                .lineSpacing(4)
        }
        .padding(AppSpacing.lg)
        .background(AppColors.warning.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.lg))
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

#Preview {
    NavigationStack {
        NotificationsView()
    }
    .modelContainer(for: UserSettings.self, inMemory: true)
}
