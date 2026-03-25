import CoreData
import SwiftUI

struct CalendarDashboardView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject private var purchaseManager: PurchaseManager
    @EnvironmentObject private var scheduler: NotificationScheduler

    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Shift.shiftDate, ascending: true)], animation: .snappy)
    private var shifts: FetchedResults<Shift>

    @State private var showAddShift = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                MonthlyCalendarGrid(shifts: Array(shifts))
                    .padding(.horizontal)

                HStack {
                    Text("Shift blocks are color-coded by type")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                    Spacer()
                }
                .padding(.horizontal)

                Spacer()
            }
            .navigationTitle("Shiftflow")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showAddShift = true
                    } label: {
                        Label("Add Shift", systemImage: "plus.circle.fill")
                            .font(.headline)
                    }
                }
            }
            .sheet(isPresented: $showAddShift) {
                AddShiftView(maxShiftsAllowed: purchaseManager.hasPremium ? nil : 15)
            }
        }
    }
}
