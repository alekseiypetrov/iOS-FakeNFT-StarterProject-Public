import Foundation

struct BasketProduct: Decodable {
    let id: String
    let name: String
    let rating: Int
    let price: Double
    let images: [String]
}
