import Foundation

typealias OrderCompletion = (Result<Order, Error>) -> Void

protocol OrderService {
    func loadOrder(completion: @escaping OrderCompletion)
    func stopLoading()
}

final class OrderLoader: OrderService {
    private let networkClient: NetworkClient
    private var task: NetworkTask?

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func loadOrder(completion: @escaping OrderCompletion) {
        if let task { return }
        
        let request = OrderRequest()
        task = networkClient.send(request: request, type: Order.self) { result in
            defer {
                self.task = nil
            }
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let order):
                completion(.success(order))
            }
        }
    }
    
    func stopLoading() {
        task?.cancel()
        task = nil
    }
}
