import Foundation

typealias CurrencyCompletion = (Result<[Currency], Error>) -> Void

protocol CurrencyService {
    func loadCurrency(completion: @escaping CurrencyCompletion)
    func stopLoading()
}

final class CurrencyLoader: CurrencyService {
    private let networkClient: NetworkClient
    private var task: NetworkTask?

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func loadCurrency(completion: @escaping CurrencyCompletion) {
        guard task == nil else { return }
        
        let request = CurrencyRequest()
        task = networkClient.send(request: request, type: [Currency].self) { result in
            defer {
                self.task = nil
            }
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let currencies):
                completion(.success(currencies))
            }
        }
    }
    
    func stopLoading() {
        task?.cancel()
        task = nil
    }
}
