import Foundation

final class NftCollectionPresenter: NftCollectionPresenterProtocol {

    // MARK: - Properties

    weak var view: NftCollectionViewProtocol?

    private let collectionId: String
    private let catalogService: CatalogService
    private let nftService: NftService

    private var collection: NFTCollectionDetails?
    private var nfts: [Nft] = []

    // MARK: - Init

    init(
        collectionId: String,
        catalogService: CatalogService,
        nftService: NftService
    ) {
        self.collectionId = collectionId
        self.catalogService = catalogService
        self.nftService = nftService
    }

    // MARK: - Lifecycle

    func viewDidLoad() {
        view?.showLoading()

        catalogService.loadCollection(id: collectionId) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let collection):
                self.collection = collection
                self.loadNfts(ids: collection.nfts)

            case .failure(let error):
                self.view?.hideLoading()
                self.view?.showError(error)
            }
        }
    }

    // MARK: - CollectionView

    func numberOfItems() -> Int {
        nfts.count
    }

    func nft(at index: Int) -> Nft {
        nfts[index]
    }

    // MARK: - HeaderView

    func collectionName() -> String {
        collection?.name ?? ""
    }

    func collectionDescription() -> String {
        collection?.description ?? ""
    }

    func collectionAuthorName() -> String {
        collection?.author ?? ""
    }

    func collectionCoverURL() -> URL? {
        collection?.cover
    }
    
    func collectionAuthorWebsite() -> URL? {
        collection?.website
    }

    // MARK: - Private

    private func loadNfts(ids: [String]) {
        nftService.loadNfts(ids: ids) { [weak self] result in
            guard let self else { return }

            self.view?.hideLoading()

            switch result {
            case .success(let nfts):
                self.nfts = nfts
                self.view?.reloadData()

            case .failure(let error):
                self.view?.showError(error)
            }
        }
    }
}
