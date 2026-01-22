import Foundation

protocol NftCollectionPresenterProtocol: AnyObject {

    // MARK: - Lifecycle
    func viewDidLoad()

    // MARK: - Collection
    func numberOfItems() -> Int
    func cellModel(at index: Int) -> NftCellModel

    // MARK: - Header
    func collectionName() -> String
    func collectionAuthorName() -> String
    func collectionDescription() -> String
    func collectionCoverURL() -> URL?
    func collectionAuthorWebsite() -> URL?
    func headerViewModel() -> NftCollectionHeaderViewModel

    // MARK: - Actions
    func didTapFavorite(at index: Int)
    func didTapCart(at index: Int)
}
