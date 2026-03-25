import Foundation
import StoreKit

@MainActor
final class PurchaseManager: ObservableObject {
    enum ProductID {
        static let premium = "com.shiftflow.premium.unlock"
    }

    @Published private(set) var products: [Product] = []
    @Published private(set) var hasPremium = false

    func loadProducts() async {
        do {
            products = try await Product.products(for: [ProductID.premium])
        } catch {
            print("Product load failed: \(error.localizedDescription)")
        }
    }

    func refreshPurchaseState() async {
        for await result in Transaction.currentEntitlements {
            if case .verified(let transaction) = result,
               transaction.productID == ProductID.premium {
                hasPremium = true
                return
            }
        }
        hasPremium = false
    }

    func purchasePremium() async {
        guard let product = products.first(where: { $0.id == ProductID.premium }) else { return }

        do {
            let result = try await product.purchase()
            switch result {
            case .success(let verificationResult):
                if case .verified(let transaction) = verificationResult {
                    await transaction.finish()
                    hasPremium = true
                }
            default:
                break
            }
        } catch {
            print("Purchase failed: \(error.localizedDescription)")
        }
    }
}
