@testable import FakeNFT

extension Currency: Equatable {
    public static func == (lhs: Currency, rhs: Currency) -> Bool {
        guard lhs.title == rhs.title,
              lhs.name == rhs.name,
              lhs.imageName == rhs.imageName
        else { return false }
        return true
    }
}
