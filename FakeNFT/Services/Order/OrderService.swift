import Foundation

typealias OrderCompletion = (Result<Order, Error>) -> Void

protocol OrderService {
    func loadOrder(completion: @escaping OrderCompletion)
}

final class OrderLoader: OrderService {
    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func loadOrder(completion: @escaping OrderCompletion) {
        let request = OrderRequest()
        networkClient.send(request: request, type: Order.self) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let order):
                completion(.success(order))
            }
        }
    }
}
