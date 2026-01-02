import Foundation

struct NFTCollection: Decodable {
    let id: String
    let name: String
    let cover: URL
    let description: String
    let author: String
    let authorURL: URL
    let nfts: [String]
}
