import Foundation

protocol NftCollectionPresenterProtocol: AnyObject {

    // Lifecycle
    func viewDidLoad()

    // Collection
    func numberOfItems() -> Int
    func nft(at index: Int) -> Nft

    // Header
    func collectionName() -> String
    func collectionAuthorName() -> String
    func collectionDescription() -> String
    func collectionCoverURL() -> URL?
}
