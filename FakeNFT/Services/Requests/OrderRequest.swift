import Foundation

struct OrderRequest: NetworkRequest {
    var dto: Dto?
    var httpMethod: HttpMethod = .get
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1")
    }
}

struct OrderDto: Dto {
    let nfts: [String]
    
    enum CodingKeys: String, CodingKey {
        case nfts = "nfts"
    }
    
    func asDictionary() -> [String : String] {
        [
            CodingKeys.nfts.rawValue: nfts.joined(separator: ",")
        ]
    }
}
