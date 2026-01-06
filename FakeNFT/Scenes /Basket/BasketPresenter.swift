import Foundation

protocol BasketPresenterProtocol {
    var productsAmount: Int { get }
    func viewWillAppear()
    func viewDidDisappear()
    func getCurrentProduct(at index: Int) -> Nft
    func deleteProduct()
    func findProduct(withName name: String) -> Nft?
    func countNewInfoForPaymentCard()
    func sortParameterChanged(to newParameter: SortOption)
}

final class BasketPresenter {
    
    // MARK: - Private Properties
    
    private let storageKey = "basket.sortParameter"
    private var order: Order = Order(nfts: [])
    private var products: [Nft] = []
    private var chosenProductIndex: Int?
    private var nftQueue = DispatchQueue(label: "nft-loading-queue-async", attributes: .concurrent)
    private var orderService: OrderService
    private var productsService: BasketProductService
    weak private var viewController: BasketViewControllerProtocol?
    
    // MARK: - Initializers
    
    init(viewController: BasketViewControllerProtocol?) {
        self.viewController = viewController
        let networkClient = DefaultNetworkClient()
        orderService = OrderLoader(networkClient: networkClient)
        productsService = BasketProductLoader(
            networkClient: networkClient,
            storage: NftStorageImpl()
        )
    }
    
    // MARK: - Private Methods
    
    private func getParameterAndSort() {
        guard let stringParameter = SortingParametersStorage.getParameter(fromKey: storageKey),
              let sortParameter = SortOption(rawValue: stringParameter)
        else { return }
        sortProducts(by: sortParameter)
    }
    
    private func sortProducts(by parameter: SortOption) {
        var predicate: (Nft, Nft) -> Bool
        switch parameter {
        case .byPrice:
            predicate = { $0.price > $1.price }
        case .byRating:
            predicate = { $0.rating > $1.rating }
        default:
            predicate = { $0.name < $1.name }
        }
        products
            .sort(by: predicate)
    }
    
    private func orderDelivered() {
        viewController?.showTable()
        let group = DispatchGroup()
        var loadedProducts: [Nft] = []
        for nftId in order.nfts {
            group.enter()
            nftQueue.async {
                self.productsService.loadProduct(id: nftId) { [weak self] result in
                    defer { group.leave() }
                    guard let self else { return }
                    print("[BasketPresenter/loadProduct]: продукт загружен")
                    switch result {
                    case .failure(let error):
                        print("[BasketPresenter/loadProduct]: error - \(error)")
                    case .success(let product):
                        print("[BasketPresenter/loadProduct]: product - \(product.id)")
                        loadedProducts.append(product)
                    }
                }
            }
        }
        group.notify(queue: .main) { [weak self] in
            self?.products = loadedProducts
            self?.getParameterAndSort()
            self?.viewController?.updateCellsFromTable()
        }
        productsService.clearTasks()
    }
    
    private func loadOrder() {
        orderService.loadOrder { [weak self] result in
            guard let self else { return }
            print("[BasketPresenter/loadOrder]: заказ загружен")
            switch result {
            case .failure(let error):
                print("[BasketPresenter/loadOrder]: error - \(error)")
            case .success(let order):
                self.order = order
                // TODO: - will be removed later (для просмотра на моковом примере)
                self.order = Order(nfts: [
                    "ca34d35a-4507-47d9-9312-5ea7053994c0",
                    "7773e33c-ec15-4230-a102-92426a3a6d5a",
                    "739e293c-1067-43e5-8f1d-4377e744ddde",
                    "1e649115-1d4f-4026-ad56-9551a16763ee",
                    "28829968-8639-4e08-8853-2f30fcf09783",
                    "5093c01d-e79e-4281-96f1-76db5880ba70",
                    "594aaf01-5962-4ab7-a6b5-470ea37beb93",
                    "1fda6f0c-a615-4a1a-aa9c-a1cbd7cc76ae",
                    "3434c774-0e0f-476e-a314-24f4f0dfed86",
                    "cc74e9ab-2189-465f-a1a6-8405e07e9fe4"
                ])
                print("[BasketPresenter/loadOrder]: order - \(self.order.nfts.description)")
                if !self.order.nfts.isEmpty {
                    self.orderDelivered()
                }
            }
        }
    }
    
    private func saveOrder(_ nfts: [String]) {
        orderService.saveOrder(nfts) { [weak self] result in
            guard let self,
                  let chosenProductIndex = self.chosenProductIndex
            else { return }
            defer {
                self.chosenProductIndex = nil
            }
            switch result {
            case .failure(let error):
                print("[BasketPresenter/saveOrder]: заказ не сохранен")
                print("[BasketPresenter/saveOrder]: error - \(error)")
                self.viewController?.showUpdatingStatus(false)
            case .success(let order):
                print("[BasketPresenter/saveOrder]: заказ сохранен")
                print("[BasketPresenter/saveOrder]: order - \(order)")
                self.viewController?.showUpdatingStatus(true)
                self.order = order
                self.products.remove(at: chosenProductIndex)
                if self.products.isEmpty {
                    self.viewController?.hideTable()
                }
                self.viewController?.deleteCellFromTable(at: chosenProductIndex)
            }
        }
    }
}

// MARK: - BasketPresenter + BasketPresenterProtocol

extension BasketPresenter: BasketPresenterProtocol {
    var productsAmount: Int {
        products.count
    }
    
    func sortParameterChanged(to newParameter: SortOption) {
        SortingParametersStorage.save(parameter: newParameter.rawValue, forKey: storageKey)
        sortProducts(by: newParameter)
        viewController?.updateCellsFromTable()
    }
    
    func viewWillAppear() {
        print("[BasketPresenter/viewWillAppear]: запуск сетевых запросов")
        if order.nfts.isEmpty {
            viewController?.hideTable()
        }
        loadOrder()
    }
    
    func viewDidDisappear() {
        print("[BasketPresenter/viewDidDisappear]: приостановка сетевых запросов")
        orderService.stopTasks()
        productsService.stopLoadingProducts()
    }
    
    func getCurrentProduct(at index: Int) -> Nft {
        products[index]
    }
    
    func deleteProduct() {
        guard let chosenProductIndex,
              chosenProductIndex > -1
        else { return }
        var newNftsArray = order.nfts
        newNftsArray.remove(at: chosenProductIndex)
        saveOrder(newNftsArray)
    }
    
    func findProduct(withName name: String) -> Nft? {
        guard let index = products.firstIndex(where: { $0.name == name })
        else { return nil }
        chosenProductIndex = index
        return getCurrentProduct(at: index)
    }
    
    func countNewInfoForPaymentCard() {
        let cost = products.reduce(0.0, { $0 + $1.price })
        viewController?.updateInfoInPaymentCard(newCount: productsAmount, newCost: cost)
    }
}
