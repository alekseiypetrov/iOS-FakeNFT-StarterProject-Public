@testable import FakeNFT

extension Nft: Equatable {
    public static func == (lhs: Nft, rhs: Nft) -> Bool {
        guard lhs.id == rhs.id,
              lhs.name == rhs.name,
              lhs.price == rhs.price,
              lhs.rating == rhs.rating,
              lhs.images == rhs.images
        else { return false }
        return true
    }
}
