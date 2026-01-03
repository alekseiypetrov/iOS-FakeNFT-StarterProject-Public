import Foundation

final class CatalogService {

    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

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

    func loadCollection(
        id: String,
        completion: @escaping (Result<NFTCollection, Error>) -> Void
    ) {
        let request = CollectionsRequest(id: id)

        networkClient.send(
            request: request,
            type: NFTCollection.self
        ) { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
}
