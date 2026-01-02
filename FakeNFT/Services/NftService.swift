import Foundation

typealias NftCompletion = (Result<Nft, Error>) -> Void
typealias NftsCompletion = (Result<[Nft], Error>) -> Void

protocol NftService {
    func loadNft(id: String, completion: @escaping NftCompletion)
    func loadNfts(ids: [String], completion: @escaping NftsCompletion)
}

final class NftServiceImpl: NftService {

    private let networkClient: NetworkClient
    private let storage: NftStorage

    init(networkClient: NetworkClient, storage: NftStorage) {
        self.storage = storage
        self.networkClient = networkClient
    }

    func loadNft(id: String, completion: @escaping NftCompletion) {
        if let nft = storage.getNft(with: id) {
            completion(.success(nft))
            return
        }

        let request = NFTRequest(id: id)
        networkClient.send(request: request, type: Nft.self) { [weak storage] result in
            switch result {
            case .success(let nft):
                storage?.saveNft(nft)
                completion(.success(nft))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func loadNfts(ids: [String], completion: @escaping NftsCompletion) {
        var loadedNfts: [Nft] = []
        var currentIndex = 0

        func loadNext() {
            if currentIndex >= ids.count {
                completion(.success(loadedNfts))
                return
            }

            let id = ids[currentIndex]
            loadNft(id: id, completion: { result in
                switch result {
                case .success(let nft):
                    loadedNfts.append(nft)
                    currentIndex += 1
                    loadNext()
                case .failure(let error):
                    completion(.failure(error))
                }
            })
        }

        loadNext()
    }
}
