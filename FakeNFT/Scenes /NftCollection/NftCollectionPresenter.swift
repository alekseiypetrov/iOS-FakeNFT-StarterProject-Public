import Foundation

final class NftCollectionPresenter: NftCollectionPresenterProtocol {

    // MARK: - Dependencies

    weak var view: NftCollectionViewProtocol?

    private let collectionId: String
    private let catalogService: CatalogService
    private let nftService: NftService

    // MARK: - Data

    private var collection: NFTCollectionDetails?
    private var cellModels: [NftCellModel] = []

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

    // MARK: - Collection

    func numberOfItems() -> Int {
        cellModels.count
    }

    func cellModel(at index: Int) -> NftCellModel {
        cellModels[index]
    }

    // MARK: - Header

    func collectionName() -> String {
        collection?.name ?? ""
    }

    func collectionAuthorName() -> String {
        collection?.author ?? ""
    }

    func collectionDescription() -> String {
        collection?.description ?? ""
    }

    func collectionCoverURL() -> URL? {
        collection?.cover
    }
    
    func collectionAuthorWebsite() -> URL? {
        collection?.website
    }
    
    func headerViewModel() -> NftCollectionHeaderViewModel {
        let previewURLs = cellModels
            .prefix(3)
            .compactMap { $0.imageURL }

        return NftCollectionHeaderViewModel(
            title: collection?.name ?? "",
            authorName: collection?.author ?? "",
            description: collection?.description ?? "",
            previewImageURLs: previewURLs
        )
    }

    // MARK: - Actions

    func didTapFavorite(at index: Int) {
        guard cellModels.indices.contains(index) else { return }
        cellModels[index].isFavorite.toggle()
    }

    func didTapCart(at index: Int) {
        guard cellModels.indices.contains(index) else { return }
        cellModels[index].isInCart.toggle()
    }

    // MARK: - Private

    private func loadNfts(ids: [String]) {
        nftService.loadNfts(ids: ids) { [weak self] result in
            guard let self else { return }

            self.view?.hideLoading()

            switch result {
            case .success(let nfts):
                self.cellModels = nfts.map { nft in
                    NftCellModel(
                        id: nft.id,
                        name: nft.name,
                        imageURL: nft.images.first.flatMap(URL.init(string:)),
                        rating: nft.rating,
                        price: nft.price,
                        isFavorite: false,
                        isInCart: false
                    )
                }
                self.view?.reloadData()

            case .failure(let error):
                self.view?.showError(error)
            }
        }
    }
}
