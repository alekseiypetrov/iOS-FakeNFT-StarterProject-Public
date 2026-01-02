import Foundation

struct CollectionDetails: Decodable {
    let id: String
    let name: String
    let description: String
    let cover: String
    let author: String
    let nfts: [String]
}
