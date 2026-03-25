import CoreData
import Foundation

extension Shift {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Shift> {
        NSFetchRequest<Shift>(entityName: "Shift")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var shiftDate: Date?
    @NSManaged public var startTime: Date?
    @NSManaged public var endTime: Date?
    @NSManaged public var colorName: String?
    @NSManaged public var notificationIdentifier: String?
}

extension Shift: Identifiable {}
