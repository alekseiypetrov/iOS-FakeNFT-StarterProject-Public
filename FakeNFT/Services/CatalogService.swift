import Foundation

final class CatalogService {

    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func loadCollections(completion: @escaping (Result<[Collection], Error>) -> Void) {
        let request = CollectionsRequest()

        networkClient.send(request: request, type: [Collection].self) { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
}
