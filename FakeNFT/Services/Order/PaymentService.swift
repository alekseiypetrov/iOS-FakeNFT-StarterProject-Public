typealias PaymentCompletion = (Result<PaymentResponse, Error>) -> Void

protocol PaymentService {
    func payForOrder(byCurrencyWithId id: String, completion: @escaping PaymentCompletion)
}

final class PaymentSender: PaymentService {
    let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func payForOrder(byCurrencyWithId id: String, completion: @escaping PaymentCompletion) {
        let request = PaymentRequest(id: id)
        networkClient.send(request: request, type: PaymentResponse.self) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let response):
                completion(.success(response))
            }
        }
    }
}
