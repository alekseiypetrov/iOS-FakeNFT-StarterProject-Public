import Foundation

final class CatalogPresenter: CatalogPresenterProtocol {

    // MARK: - Private properties

    private weak var view: CatalogViewProtocol?
    private let catalogService: CatalogService
    private var collections: [NFTCollection] = []

    // MARK: - Public properties

    var itemsAmount: Int {
        collections.count
    }

    // MARK: - Init

    init(catalogService: CatalogService) {
        self.catalogService = catalogService
    }

    // MARK: - Configuration

    func configure(_ view: CatalogViewProtocol) {
        self.view = view
    }

    // MARK: - CatalogPresenterProtocol

    func viewDidLoad() {
        print("🚀 [CatalogPresenter/viewDidLoad]: view loaded")
        view?.showLoading()

        catalogService.loadCollections { [weak self] result in
            guard let self else { return }

            self.view?.hideLoading()

            switch result {
            case .success(let collections):
                self.collections = collections
                self.view?.reloadData()

            case .failure(let error):
                print("❌ [CatalogPresenter/loadCollections]: failure — \(error)")
            }
        }
    }

    func collection(at index: Int) -> NFTCollection {
        collections[index]
    }
}
