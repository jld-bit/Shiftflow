import CoreData
import SwiftUI

struct AddShiftView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject private var scheduler: NotificationScheduler

    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Shift.shiftDate, ascending: true)])
    private var shifts: FetchedResults<Shift>

    @StateObject private var vm = ShiftFormViewModel()

    let maxShiftsAllowed: Int?

    var body: some View {
        NavigationStack {
            Form {
                Section("Shift Details") {
                    DatePicker("Date", selection: $vm.shiftDate, displayedComponents: .date)
                    DatePicker("Start", selection: $vm.startTime, displayedComponents: .hourAndMinute)
                    DatePicker("End", selection: $vm.endTime, displayedComponents: .hourAndMinute)

                    Picker("Color", selection: $vm.selectedColor) {
                        ForEach(ShiftColor.allCases) { color in
                            Label(color.displayName, systemImage: "circle.fill")
                                .foregroundStyle(color.color)
                                .tag(color)
                        }
                    }

                    Toggle("Reminder 30 min before", isOn: $vm.reminderEnabled)
                }

                if let maxShiftsAllowed,
                   shifts.count >= maxShiftsAllowed {
                    Text("Free plan reached (\(maxShiftsAllowed) shifts). Upgrade to premium for unlimited scheduling.")
                        .font(.footnote)
                        .foregroundStyle(.orange)
                }
            }
            .navigationTitle("New Shift")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        Task { await saveShift() }
                    }
                    .disabled(!vm.validTimeRange || (maxShiftsAllowed != nil && shifts.count >= (maxShiftsAllowed ?? 0)))
                }
            }
        }
    }

    private func saveShift() async {
        let shift = Shift(context: viewContext)
        shift.id = UUID()
        shift.shiftDate = vm.shiftDate
        shift.startTime = combine(date: vm.shiftDate, with: vm.startTime)
        shift.endTime = combine(date: vm.shiftDate, with: vm.endTime)
        shift.colorName = vm.selectedColor.rawValue

        if vm.reminderEnabled,
           let reminderID = await scheduler.scheduleReminder(for: shift) {
            shift.notificationIdentifier = reminderID
        }

        do {
            try viewContext.save()
            dismiss()
        } catch {
            viewContext.rollback()
            print("Could not save shift: \(error.localizedDescription)")
        }
    }

    private func combine(date: Date, with time: Date) -> Date {
        let dateParts = Calendar.current.dateComponents([.year, .month, .day], from: date)
        let timeParts = Calendar.current.dateComponents([.hour, .minute], from: time)

        var final = DateComponents()
        final.year = dateParts.year
        final.month = dateParts.month
        final.day = dateParts.day
        final.hour = timeParts.hour
        final.minute = timeParts.minute

        return Calendar.current.date(from: final) ?? date
    }
}
