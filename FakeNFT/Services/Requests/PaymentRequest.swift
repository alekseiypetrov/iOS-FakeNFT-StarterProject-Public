import Foundation

struct PaymentRequest: NetworkRequest {
    let id: String
    var dto: Dto?
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1/payment/\(id)")
    }
}
