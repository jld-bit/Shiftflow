import Foundation
import UserNotifications

@MainActor
final class NotificationScheduler: ObservableObject {
    private let center = UNUserNotificationCenter.current()

    func requestAuthorizationIfNeeded() async {
        do {
            _ = try await center.requestAuthorization(options: [.alert, .badge, .sound])
        } catch {
            print("Notification authorization failed: \(error.localizedDescription)")
        }
    }

    func scheduleReminder(for shift: Shift, leadTime: TimeInterval = 30 * 60) async -> String? {
        guard let id = shift.id else { return nil }
        let triggerDate = shift.wrappedStartTime.addingTimeInterval(-leadTime)
        guard triggerDate > Date() else { return nil }

        let identifier = "shift-reminder-\(id.uuidString)"
        let content = UNMutableNotificationContent()
        content.title = "Upcoming Shift"
        content.body = "Your shift starts at \(shift.wrappedStartTime.formatted(date: .omitted, time: .shortened))."
        content.sound = .default

        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: triggerDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

        do {
            try await center.add(request)
            return identifier
        } catch {
            print("Could not schedule reminder: \(error.localizedDescription)")
            return nil
        }
    }

    func removeReminder(identifier: String?) {
        guard let identifier else { return }
        center.removePendingNotificationRequests(withIdentifiers: [identifier])
    }
}
