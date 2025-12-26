import Foundation

final class CatalogPresenter: CatalogPresenterProtocol {

    // MARK: - Properties

    weak var view: CatalogViewProtocol?
    
    private let catalogService: CatalogService
    private var collections: [Collection] = []
    
    // MARK: - Init

    init(catalogService: CatalogService) {
        self.catalogService = catalogService
    }

    // MARK: - CatalogPresenterProtocol

    func viewDidLoad() {
        view?.showLoading()

        catalogService.loadCollections { [weak self] result in
            guard let self else { return }

            self.view?.hideLoading()

            switch result {
            case .success(let collections):
                self.collections = collections
                self.view?.reloadData()

            case .failure:
                // обработка ошибок будет отдельной карточкой
                break
            }
        }
    }
    
    func numberOfItems() -> Int {
        collections.count
    }

    func collection(at index: Int) -> Collection {
        collections[index]
    }
}
