import Foundation

struct NFTCollection: Decodable {
    let id: String
    let name: String
    let cover: URL
    let nfts: [String]
}
