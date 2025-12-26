protocol BasketPresenterProtocol {
    func viewDidLoad(viewController: BasketViewControllerProtocol)
    func getCountOfProducts() -> Int
    func getCurrentProduct(at index: Int) -> BasketProduct
    func deleteProduct()
    func findProduct(withName name: String) -> Bool
    func countNewInfoForPaymentCard()
}

final class BasketPresenter {
    
    // MARK: - Private Properties
    
    // TODO: - will be removed later (моковые данные)
    private var products: [BasketProduct] = [
        BasketProduct(name: "Title0", rating: 4, price: 12.0, imageUrl: "https://avatars.mds.yandex.net/i?id=8218634f6414d86b4a8c4f24146f8d5d06643f87-16441608-images-thumbs&n=13"),
        BasketProduct(name: "Title1", rating: 1, price: 1.0, imageUrl: "https://avatars.mds.yandex.net/i?id=8218634f6414d86b4a8c4f24146f8d5d06643f87-16441608-images-thumbs&n=13"),
        BasketProduct(name: "Title2", rating: 2, price: 2.0, imageUrl: "https://avatars.mds.yandex.net/i?id=8218634f6414d86b4a8c4f24146f8d5d06643f87-16441608-images-thumbs&n=13"),
        BasketProduct(name: "Title3", rating: 3, price: 121.0, imageUrl: "https://avatars.mds.yandex.net/i?id=8218634f6414d86b4a8c4f24146f8d5d06643f87-16441608-images-thumbs&n=13"),
        BasketProduct(name: "Title4", rating: 4, price: 21.0, imageUrl: "https://avatars.mds.yandex.net/i?id=8218634f6414d86b4a8c4f24146f8d5d06643f87-16441608-images-thumbs&n=13"),
        BasketProduct(name: "Title5", rating: 5, price: 22.0, imageUrl: "https://avatars.mds.yandex.net/i?id=8218634f6414d86b4a8c4f24146f8d5d06643f87-16441608-images-thumbs&n=13"),
        BasketProduct(name: "Title6", rating: 6, price: 11.0, imageUrl: "https://avatars.mds.yandex.net/i?id=8218634f6414d86b4a8c4f24146f8d5d06643f87-16441608-images-thumbs&n=13"),
    ]
    private var chosenProductIndex: Int?
    weak private var viewController: BasketViewControllerProtocol?
}

// MARK: - BasketPresenter + BasketPresenterProtocol

extension BasketPresenter: BasketPresenterProtocol {
    
    func viewDidLoad(viewController: BasketViewControllerProtocol) {
        self.viewController = viewController
        // TODO: - wll be done later (запрос в сеть за корзиной)
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
