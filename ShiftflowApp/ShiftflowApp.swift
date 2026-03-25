import SwiftUI

@main
struct ShiftflowApp: App {
    @StateObject private var persistenceController = PersistenceController.shared
    @StateObject private var purchaseManager = PurchaseManager()
    @StateObject private var scheduler = NotificationScheduler()

    var body: some Scene {
        WindowGroup {
            RootTabView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(purchaseManager)
                .environmentObject(scheduler)
                .task {
                    await purchaseManager.loadProducts()
                    await purchaseManager.refreshPurchaseState()
                    await scheduler.requestAuthorizationIfNeeded()
                }
        }
    }
}
