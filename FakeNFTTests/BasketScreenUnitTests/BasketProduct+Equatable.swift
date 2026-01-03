@testable import FakeNFT

extension BasketProduct: Equatable {
    public static func == (lhs: BasketProduct, rhs: BasketProduct) -> Bool {
        guard lhs.id == rhs.id,
              lhs.name == rhs.name,
              lhs.price == rhs.price,
              lhs.rating == rhs.rating,
              lhs.images == rhs.images
        else { return false }
        return true
    }
}
