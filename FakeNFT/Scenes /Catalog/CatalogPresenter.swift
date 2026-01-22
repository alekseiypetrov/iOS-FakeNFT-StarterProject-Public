import Foundation

final class CatalogPresenter: CatalogPresenterProtocol {
    
    // MARK: - Private properties
    
    private weak var view: CatalogViewProtocol?
    private let catalogService: CatalogService
    private let nftService: NftService
    private var collections: [NFTCollection] = []
    private var currentSort: SortOption = .byNftsAmount
    
    // MARK: - Public properties
    
    var itemsAmount: Int {
        collections.count
    }
    
    // MARK: - Init
    
    init(catalogService: CatalogService, nftService: NftService) {
        self.catalogService = catalogService
        self.nftService = nftService
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
            
            DispatchQueue.main.async {
                self.view?.hideLoading()
                
                switch result {
                case .success(let collections):
                    self.collections = collections
                    self.applySorting()
                    self.view?.reloadData()
                    
                case .failure(let error):
                    print("❌ [CatalogPresenter/loadCollections]: \(error)")
                    self.view?.showError(message: "Не удалось загрузить каталог. Проверьте соединение с интернетом.")
                }
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
    
    func loadPreviewImages(
        for collectionIndex: Int,
        completion: @escaping ([URL?]) -> Void
    ) {
        guard collections.indices.contains(collectionIndex) else {
            completion([])
            return
        }

        let nftIds = Array(collections[collectionIndex].nfts.prefix(3))

        var imageURLs: [URL?] = Array(repeating: nil, count: nftIds.count)
        let group = DispatchGroup()

        for (index, nftId) in nftIds.enumerated() {
            group.enter()

            nftService.loadNft(id: nftId) { result in
                defer { group.leave() }

                switch result {
                case .success(let nft):
                    imageURLs[index] = URL(string: nft.images.first ?? "")

                case .failure:
                    imageURLs[index] = nil
                }
            }
        }

        group.notify(queue: .main) {
            completion(imageURLs)
        }
    }
}
