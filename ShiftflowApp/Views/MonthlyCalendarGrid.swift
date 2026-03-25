import SwiftUI

struct MonthlyCalendarGrid: View {
    private let calendar = Calendar.current
    private let days: [Date]
    private let monthStart: Date
    private let shiftsByDay: [Date: [Shift]]

    init(shifts: [Shift]) {
        let now = Date()
        let monthStart = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: now)) ?? now
        self.monthStart = monthStart

        let range = Calendar.current.range(of: .day, in: .month, for: monthStart) ?? 1..<31
        self.days = range.compactMap {
            Calendar.current.date(byAdding: .day, value: $0 - 1, to: monthStart)
        }

        self.shiftsByDay = Dictionary(grouping: shifts) {
            Calendar.current.startOfDay(for: $0.wrappedDate)
        }
    }

    var body: some View {
        let columns = Array(repeating: GridItem(.flexible(), spacing: 10), count: 7)
        VStack(alignment: .leading, spacing: 8) {
            Text(monthStart.formatted(.dateTime.month(.wide).year()))
                .font(.title3.bold())

            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(calendar.shortWeekdaySymbols, id: \.self) { symbol in
                    Text(symbol)
                        .font(.caption.bold())
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(.secondary)
                }

                ForEach(days, id: \.self) { day in
                    VStack(alignment: .leading, spacing: 3) {
                        Text(day.formatted(.dateTime.day()))
                            .font(.caption2.bold())
                            .foregroundStyle(.primary)

                        ForEach(shiftsByDay[calendar.startOfDay(for: day)] ?? [], id: \.objectID) { shift in
                            RoundedRectangle(cornerRadius: 4)
                                .fill(color(for: shift.colorName))
                                .frame(height: 8)
                        }

                        Spacer(minLength: 0)
                    }
                    .padding(6)
                    .frame(height: 52)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(uiColor: .secondarySystemBackground))
                    )
                }
            }
        }
    }

    private func color(for rawValue: String?) -> Color {
        ShiftColor(rawValue: rawValue ?? "")?.color ?? .blue
    }
}
