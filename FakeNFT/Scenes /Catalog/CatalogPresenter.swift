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
        print("🚀 CatalogPresenter viewDidLoad")
        view?.showLoading()

        catalogService.loadCollections { [weak self] result in
            guard let self else { return }
            
            print("📦 CatalogPresenter got result:", result)

            self.view?.hideLoading()

            switch result {
            case .success(let collections):
                
                print("✅ collections.count =", collections.count)
                
                self.collections = collections
                self.view?.reloadData()

            case .failure(let error):
                
                print("❌ error =", error)
            }
        }
    }

    func collection(at index: Int) -> NFTCollection {
        collections[index]
    }
}
