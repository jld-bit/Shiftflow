import SwiftUI

struct RootTabView: View {
    var body: some View {
        TabView {
            CalendarDashboardView()
                .tabItem {
                    Label("Calendar", systemImage: "calendar")
                }

            UpcomingShiftsView()
                .tabItem {
                    Label("Upcoming", systemImage: "list.bullet")
                }

            PremiumView()
                .tabItem {
                    Label("Premium", systemImage: "star.circle")
                }
        }
        .tint(.orange)
    }
}
