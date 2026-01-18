import Foundation

struct UserAgreementRequest: NetworkRequest {
    private let stringUrl = "https://yandex.ru/legal/practicum_termsofuse"
    
    var dto: Dto?
    
    var endpoint: URL? {
        URL(string: stringUrl)
    }
}
