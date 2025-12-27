import Foundation

final class CatalogPresenter: CatalogPresenterProtocol {

    // MARK: - Properties

    weak var view: CatalogViewProtocol?
    
    private let catalogService: CatalogService
    private var collections: [NFTCollection] = []
    
    var itemsAmount: Int { collections.count }
    
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

    func collection(at index: Int) -> NFTCollection {
        collections[index]
    }
}
