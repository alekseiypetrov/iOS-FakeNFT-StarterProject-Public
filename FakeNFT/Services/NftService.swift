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
        print("🧩 [NftService/loadNft]: start loading from API, id = \(id)")
        
        networkClient.send(request: request, type: Nft.self) { [weak storage] result in
            switch result {
            case .success(let nft):
                print("✅ [NftService/loadNft]: loaded successfully, id = \(id)")
                storage?.saveNft(nft)
                completion(.success(nft))
                
            case .failure(let error):
                print("❌ [NftService/loadNft]: failed, id = \(id), error = \(error)")
                completion(.failure(error))
            }
        }
    }
    
    func loadNfts(ids: [String], completion: @escaping NftsCompletion) {
        var loadedNfts: [Nft] = []
        var currentIndex = 0
        
        print("🧩 [NftService/loadNfts]: start loading \(ids.count) NFTs")
        
        func loadNext() {
            guard currentIndex < ids.count else {
                print("✅ [NftService/loadNfts]: finished loading \(loadedNfts.count) NFTs")
                completion(.success(loadedNfts))
                return
            }
            
            let id = ids[currentIndex]
            loadNft(id: id) { result in
                switch result {
                case .success(let nft):
                    print("📦 [NftService/loadNfts]: appended NFT, id = \(nft.id)")
                    loadedNfts.append(nft)
                    currentIndex += 1
                    loadNext()
                    
                case .failure(let error):
                    print("❌ [NftService/loadNfts]: failed on id = \(id), error = \(error)")
                    completion(.failure(error))
                }
            }
        }
        
        loadNext()
    }
}

