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

    // MARK: - Init
    init(networkClient: NetworkClient, storage: NftStorage) {
        self.storage = storage
        self.networkClient = networkClient
    }

    // MARK: - NftService
    func loadNft(id: String, completion: @escaping NftCompletion) {
        if let nft = storage.getNft(with: id) {
            print("📦 [NftServiceImpl/loadNft]: cache hit for id = \(id)")
            completion(.success(nft))
            return
        }
        

        let request = NFTRequest(id: id)
        networkClient.send(request: request, type: Nft.self) { [weak storage] result in
            print("🧩 [NftServiceImpl/loadNft]: loading NFT from API, id = \(id)")
            switch result {
            case .success(let nft):
                print("🧩 [NftServiceImpl/loadNft]: successfully loaded NFT, id = \(id)")
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
                    print("✅ Added NFT to collection:", nft.name)
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

