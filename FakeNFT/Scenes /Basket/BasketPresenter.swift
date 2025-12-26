import Foundation

protocol BasketPresenterProtocol {
    func viewDidLoad()
    func getCountOfProducts() -> Int
    func getCurrentProduct(at index: Int) -> BasketProduct
    func deleteProduct()
    func findProduct(withName name: String) -> Bool
    func countNewInfoForPaymentCard()
}

final class BasketPresenter {
    
    // MARK: - Private Properties
    
    private var order: Order = Order(nfts: [])
    private var products: [BasketProduct] = []
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
            storage: NftStorageInBasket()
        )
    }
    
    // MARK: - Private Methods
    
    private func orderDelivered() {
        viewController?.showTable()
        let group = DispatchGroup()
        for nftId in order.nfts {
            group.enter()
            nftQueue.async {
                self.productsService.loadProduct(id: nftId) { [weak self] result in
                    defer { group.leave() }
                    print("[presenter/loadProduct]: продукт загружен")
                    switch result {
                    case .failure(let error):
                        print("[presenter/loadProduct]: error - \(error)")
                    case .success(let product):
                        print("[presenter/loadProduct]: product - \(product.name)")
                        self?.products.append(product)
                    }
                }
            }
        }
        group.notify(queue: .main) { [weak self] in
            self?.countNewInfoForPaymentCard()
            self?.viewController?.updateCellsFromTable()
        }
    }
}

// MARK: - BasketPresenter + BasketPresenterProtocol

extension BasketPresenter: BasketPresenterProtocol {
    
    func viewDidLoad() {
        viewController?.hideTable()
        orderService.loadOrder { [weak self] result in
            guard let self else { return }
            print("[presenter/loadOrder]: заказ загружен")
            switch result {
            case .failure(let error):
                print("[presenter/loadOrder]: error - \(error)")
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
                print("[presenter/loadOrder]: order - \(self.order)")
                if !self.order.nfts.isEmpty {
                    self.orderDelivered()
                }
            }
        }
    }
    
    func getCountOfProducts() -> Int {
        products.count
    }
    
    func getCurrentProduct(at index: Int) -> BasketProduct {
        products[index]
    }
    
    func deleteProduct() {
        guard let chosenProductIndex,
              chosenProductIndex > -1
        else { return }
        products.remove(at: chosenProductIndex)
        viewController?.deleteCellFromTable(at: chosenProductIndex)
        self.chosenProductIndex = nil
        // TODO: - wll be done later (запрос в сеть об изменении содержимого корзины)
    }
    
    func findProduct(withName name: String) -> Bool {
        guard let index = products.firstIndex(where: { $0.name == name })
        else { return false }
        chosenProductIndex = index
        return true
    }
    
    func countNewInfoForPaymentCard() {
        let count = getCountOfProducts()
        let cost = products.reduce(0.0, { $0 + $1.price })
        viewController?.updateInfoInPaymentCard(newCount: count, newCost: cost)
    }
}
