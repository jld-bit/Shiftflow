import Foundation

@MainActor
final class ShiftFormViewModel: ObservableObject {
    @Published var shiftDate = Date()
    @Published var startTime = Date()
    @Published var endTime = Date().addingTimeInterval(4 * 60 * 60)
    @Published var selectedColor: ShiftColor = .blue
    @Published var reminderEnabled = true

    var validTimeRange: Bool {
        endTime > startTime
    }
}
