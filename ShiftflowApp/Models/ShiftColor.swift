import SwiftUI

enum ShiftColor: String, CaseIterable, Identifiable {
    case blue
    case green
    case orange

    var id: String { rawValue }

    var displayName: String { rawValue.capitalized }

    var color: Color {
        switch self {
        case .blue: return .blue
        case .green: return .green
        case .orange: return .orange
        }
    }
}
