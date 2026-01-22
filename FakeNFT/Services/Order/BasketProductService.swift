import Foundation

typealias BasketProductCompletion = (Result<Nft, Error>) -> Void

protocol BasketProductService {
    func loadProduct(id: String, completion: @escaping BasketProductCompletion)
    func stopLoadingProducts()
    func clearTasks()
}

final class BasketProductLoader: BasketProductService {
    
    private let networkClient: NetworkClient
    private let storage: NftStorageImpl
    private var tasks: [NetworkTask?] = []

    init(networkClient: NetworkClient, storage: NftStorageImpl) {
        self.storage = storage
        self.networkClient = networkClient
    }
    
    func loadProduct(id: String, completion: @escaping BasketProductCompletion) {
        if let nft = storage.getNft(with: id) {
            completion(.success(nft))
            return
        }
        let request = NFTRequest(id: id)
        tasks
            .append(
                networkClient.send(request: request, type: Nft.self) { [weak storage] result in
                    switch result {
                    case .success(let nft):
                        storage?.saveNft(nft)
                        completion(.success(nft))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            )
    }
    
    func stopLoadingProducts() {
        tasks
            .forEach {
                $0?.cancel()
            }
        clearTasks()
    }
    
    func clearTasks() {
        tasks = []
    }
}
