import Foundation

struct CollectionsRequest: NetworkRequest {

    let id: String?

    init(id: String? = nil) {
        self.id = id
    }

    var endpoint: URL? {
        if let id {
            return URL(string: "\(RequestConstants.baseURL)/api/v1/collections/\(id)")
        } else {
            return URL(string: "\(RequestConstants.baseURL)/api/v1/collections")
        }
    }

    var dto: Dto?
}
