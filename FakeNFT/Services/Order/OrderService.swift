import Foundation

typealias OrderCompletion = (Result<Order, Error>) -> Void

protocol OrderService {
    func loadOrder(completion: @escaping OrderCompletion)
    func saveOrder(_ nfts: [String], completion: @escaping OrderCompletion)
    func stopTasks()
}

final class OrderLoader: OrderService {
    private let networkClient: NetworkClient
    private var tasks: [HttpMethod: NetworkTask?] = [.get: nil, .put: nil]

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func loadOrder(completion: @escaping OrderCompletion) {
        guard let task = tasks[.get],
              task == nil
        else { return }
        
        let request = OrderRequest(httpMethod: .get)
        tasks[.get] = networkClient.send(request: request, type: Order.self) { result in
            defer {
                self.tasks[.get] = nil
            }
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let order):
                completion(.success(order))
            }
        }
    }
    
    func saveOrder(_ nfts: [String], completion: @escaping OrderCompletion) {
        guard let task = tasks[.put],
              task == nil 
        else { return }
        let dto = OrderDto(nfts: nfts)
        let request = OrderRequest(dto: dto, httpMethod: .put)
        tasks[.put] = networkClient.send(request: request, type: Order.self) { result in
            defer {
                self.tasks[.put] = nil
            }
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let order):
                completion(.success(order))
            }
        }
    }
    
    func stopTasks() {
        tasks
            .forEach {
                $0.value?.cancel()
            }
        tasks = [.get: nil, .put: nil]
    }
}
