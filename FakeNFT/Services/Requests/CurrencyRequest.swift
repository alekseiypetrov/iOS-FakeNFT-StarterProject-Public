import Foundation

struct CurrencyRequest: NetworkRequest {
    var dto: Dto?
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/currencies")
    }
}
