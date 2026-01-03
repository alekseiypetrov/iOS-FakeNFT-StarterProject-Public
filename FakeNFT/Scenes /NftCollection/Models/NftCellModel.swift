import Foundation

struct NftCellModel {
    let id: String
    let name: String
    let imageURL: URL?
    let rating: Int
    let price: Double

    var isFavorite: Bool
    var isInCart: Bool
}
