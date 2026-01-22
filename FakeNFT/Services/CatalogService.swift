import Foundation

final class CatalogService {

    // MARK: - Properties

    private let networkClient: NetworkClient

    // MARK: - Init

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    // MARK: - Public methods

    /// Загрузка списка коллекций (экран каталога)
    func loadCollections(
        completion: @escaping (Result<[NFTCollection], Error>) -> Void
    ) {
        let request = CollectionsRequest()

        networkClient.send(
            request: request,
            type: [NFTCollection].self
        ) { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }

    /// Загрузка одной коллекции с деталями (экран коллекции)
    func loadCollection(
        id: String,
        completion: @escaping (Result<NFTCollectionDetails, Error>) -> Void
    ) {
        let request = CollectionsRequest(id: id)

        networkClient.send(
            request: request,
            type: NFTCollectionDetails.self
        ) { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
}
