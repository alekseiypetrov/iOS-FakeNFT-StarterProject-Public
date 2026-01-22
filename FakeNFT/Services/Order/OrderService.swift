import Foundation

typealias OrderCompletion = (Result<Order, Error>) -> Void

protocol OrderService {
    func makeOrderRequest(ofType httpMethod: HttpMethod, withNfts nfts: [String]?, completion: @escaping OrderCompletion)
    func stopTasks()
}

final class OrderLoader: OrderService {
    private let logger = StatusLogger.shared
    private let networkClient: NetworkClient
    private var tasks: [HttpMethod: NetworkTask?] = [.get: nil, .put: nil, .post: nil]

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func makeOrderRequest(ofType httpMethod: HttpMethod, withNfts nfts: [String]?, completion: @escaping OrderCompletion) {
        tasks[httpMethod]??.cancel()
        var dto: Dto?
        if let nfts,
           httpMethod == .put || httpMethod == .post {
            dto = OrderDto(nfts: nfts)
        }
        let request = OrderRequest(dto: dto, httpMethod: httpMethod)
        logger.sendCommonMessage(withText: "[OrderLoader/makeOrderRequest (\(httpMethod.rawValue)-request)]: \(request)")
        tasks[httpMethod] = networkClient.send(request: request, type: Order.self) { [weak self] result in
            defer { self?.tasks[httpMethod] = nil }
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let order):
                completion(.success(order))
            }
        }
    }
    
    func stopTasks() {
        for (key, value) in tasks {
            value?.cancel()
            tasks[key] = nil
        }
    }
}
