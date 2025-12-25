import Foundation

struct Collection: Decodable {
    let id: String
    let name: String
    let cover: URL
    let nfts: [String]
}
