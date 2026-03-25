import CoreData
import Foundation

final class PersistenceController: ObservableObject {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        let model = Self.makeModel()
        container = NSPersistentContainer(name: "ShiftflowModel", managedObjectModel: model)
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores { _, error in
            if let error {
                fatalError("Unable to load persistent stores: \(error.localizedDescription)")
            }
        }

        container.viewContext.automaticallyMergesChangesFromParent = true
    }

    static func makeModel() -> NSManagedObjectModel {
        let model = NSManagedObjectModel()

        let shiftEntity = NSEntityDescription()
        shiftEntity.name = "Shift"
        shiftEntity.managedObjectClassName = NSStringFromClass(Shift.self)

        let id = NSAttributeDescription()
        id.name = "id"
        id.attributeType = .UUIDAttributeType
        id.isOptional = false

        let shiftDate = NSAttributeDescription()
        shiftDate.name = "shiftDate"
        shiftDate.attributeType = .dateAttributeType
        shiftDate.isOptional = false

        let startTime = NSAttributeDescription()
        startTime.name = "startTime"
        startTime.attributeType = .dateAttributeType
        startTime.isOptional = false

        let endTime = NSAttributeDescription()
        endTime.name = "endTime"
        endTime.attributeType = .dateAttributeType
        endTime.isOptional = false

        let colorName = NSAttributeDescription()
        colorName.name = "colorName"
        colorName.attributeType = .stringAttributeType
        colorName.isOptional = false

        let notificationIdentifier = NSAttributeDescription()
        notificationIdentifier.name = "notificationIdentifier"
        notificationIdentifier.attributeType = .stringAttributeType
        notificationIdentifier.isOptional = true

        shiftEntity.properties = [id, shiftDate, startTime, endTime, colorName, notificationIdentifier]
        model.entities = [shiftEntity]

        return model
    }
}
