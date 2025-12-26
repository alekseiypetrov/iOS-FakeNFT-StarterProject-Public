import Foundation

typealias BasketProductCompletion = (Result<BasketProduct, Error>) -> Void

protocol BasketProductService {
    func loadProduct(id: String, completion: @escaping BasketProductCompletion)
}

final class BasketProductLoader: BasketProductService {
    
    private let networkClient: NetworkClient
    private let storage: NftStorageInBasket

    init(networkClient: NetworkClient, storage: NftStorageInBasket) {
        self.storage = storage
        self.networkClient = networkClient
    }
    
    func loadProduct(id: String, completion: @escaping BasketProductCompletion) {
        if let nft = storage.getNft(with: id) {
            completion(.success(nft))
            return
        }
        let request = NFTRequest(id: id)
        networkClient.send(request: request, type: BasketProduct.self) { [weak storage] result in
            switch result {
            case .success(let nft):
                storage?.saveNft(nft)
                completion(.success(nft))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
