import Foundation

struct OrderRequest: NetworkRequest {
    var dto: Dto?
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1")
    }
}
