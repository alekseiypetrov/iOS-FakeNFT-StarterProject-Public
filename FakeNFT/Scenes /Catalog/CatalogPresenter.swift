import Foundation

final class CatalogPresenter: CatalogPresenterProtocol {

    // MARK: - Private properties

    private weak var view: CatalogViewProtocol?
    private let catalogService: CatalogService
    private var collections: [NFTCollection] = []
    private var currentSort: SortOption = .byNftsAmount

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
        
        restoreSorting()
        
        view?.showLoading()

        catalogService.loadCollections { [weak self] result in
            guard let self else { return }

            self.view?.hideLoading()

            switch result {
            case .success(let collections):
                self.collections = collections
                self.applySorting()
                self.view?.reloadData()

            case .failure(let error):
                print("❌ [CatalogPresenter/loadCollections]: failure — \(error)")
            }
        }
    }

    func collection(at index: Int) -> NFTCollection {
        collections[index]
    }
    
    // MARK: Метод сохранения сортировки
    private func restoreSorting() {
        guard
            let rawValue = SortingParametersStorage.getParameter(fromKey: SortKeys.catalog),
            let savedSort = SortOption(rawValue: rawValue)
        else {
            currentSort = .byNftsAmount // сортировка по умолчанию
            return
        }

        currentSort = savedSort
    }
    
    // MARK: Метод изменения сортировки
    func didSelectSort(_ option: SortOption) {
        currentSort = option

        SortingParametersStorage.save(
            parameter: option.rawValue,
            forKey: SortKeys.catalog
        )

        applySorting()
        view?.reloadData()
    }
    
    private func applySorting() {
        switch currentSort {
        case .byName:
            collections.sort { $0.name < $1.name }

        case .byNftsAmount:
            collections.sort { $0.nfts.count > $1.nfts.count }

        default:
            break
        }
    }
}
