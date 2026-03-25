import CoreData
import Foundation

@objc(Shift)
public class Shift: NSManagedObject {
    var wrappedDate: Date { shiftDate ?? Date() }
    var wrappedStartTime: Date { startTime ?? Date() }
    var wrappedEndTime: Date { endTime ?? Date() }

    var durationText: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .abbreviated
        return formatter.string(from: wrappedStartTime, to: wrappedEndTime) ?? "-"
    }
}
