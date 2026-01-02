import Foundation

final class NftCollectionPresenter: NftCollectionPresenterProtocol {

    // MARK: - Properties

    weak var view: NftCollectionViewProtocol?

    private let collectionId: String
    private var nfts: [Nft] = []

    // MARK: - Init

    init(collectionId: String) {
        self.collectionId = collectionId
    }

    // MARK: - NftCollectionPresenterProtocol

    func viewDidLoad() {
        view?.showLoading()
        
    }

    func numberOfItems() -> Int {
        nfts.count
    }

    func nft(at index: Int) -> Nft {
        nfts[index]
    }
}
