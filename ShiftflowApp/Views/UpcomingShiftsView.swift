import CoreData
import SwiftUI

struct UpcomingShiftsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject private var scheduler: NotificationScheduler

    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Shift.startTime, ascending: true)], animation: .snappy)
    private var shifts: FetchedResults<Shift>

    var upcoming: [Shift] {
        shifts.filter { $0.wrappedEndTime >= Date() }
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(upcoming, id: \.objectID) { shift in
                    HStack(spacing: 12) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(ShiftColor(rawValue: shift.colorName ?? "")?.color ?? .blue)
                            .frame(width: 8)

                        VStack(alignment: .leading, spacing: 4) {
                            Text(shift.wrappedDate.formatted(date: .abbreviated, time: .omitted))
                                .font(.headline)
                            Text("\(shift.wrappedStartTime.formatted(date: .omitted, time: .shortened)) - \(shift.wrappedEndTime.formatted(date: .omitted, time: .shortened)) • \(shift.durationText)")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.vertical, 4)
                }
                .onDelete(perform: deleteShifts)
            }
            .navigationTitle("Upcoming Shifts")
            .animation(.easeInOut, value: upcoming.count)
        }
    }

    private func deleteShifts(at offsets: IndexSet) {
        offsets.map { upcoming[$0] }.forEach { shift in
            scheduler.removeReminder(identifier: shift.notificationIdentifier)
            viewContext.delete(shift)
        }

        do {
            try viewContext.save()
        } catch {
            viewContext.rollback()
            print("Delete failed: \(error.localizedDescription)")
        }
    }
}
