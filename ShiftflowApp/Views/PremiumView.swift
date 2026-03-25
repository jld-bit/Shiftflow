import SwiftUI

struct PremiumView: View {
    @EnvironmentObject private var purchaseManager: PurchaseManager

    var body: some View {
        NavigationStack {
            VStack(spacing: 18) {
                Image(systemName: purchaseManager.hasPremium ? "checkmark.seal.fill" : "star.circle.fill")
                    .font(.system(size: 54))
                    .foregroundStyle(.orange)

                Text(purchaseManager.hasPremium ? "Premium Unlocked" : "Shiftflow Premium")
                    .font(.title2.bold())

                Text("Unlock unlimited shifts, advanced reminders, and shift export with Apple In-App Purchase.")
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal)

                if purchaseManager.hasPremium {
                    Label("Unlimited shifts enabled", systemImage: "infinity")
                    Label("Custom reminders enabled", systemImage: "bell.badge")
                    Label("Export enabled", systemImage: "square.and.arrow.up")
                } else {
                    Button {
                        Task { await purchaseManager.purchasePremium() }
                    } label: {
                        Text("Unlock Premium")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.orange)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    .padding(.horizontal)
                }

                Spacer()
            }
            .padding(.top, 24)
            .navigationTitle("Premium")
        }
    }
}
