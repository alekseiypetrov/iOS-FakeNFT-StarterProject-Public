@testable import FakeNFT

extension Currency: Equatable {
    public static func == (lhs: Currency, rhs: Currency) -> Bool {
        guard lhs.title == rhs.title,
              lhs.name == rhs.name,
              lhs.image == rhs.image
        else { return false }
        return true
    }
}
