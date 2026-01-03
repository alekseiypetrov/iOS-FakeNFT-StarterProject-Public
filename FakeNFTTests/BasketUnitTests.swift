@testable import FakeNFT
import XCTest

final class BasketUnitTests: XCTestCase {
    
    // MARK: - Private Properties
    
    private let mockProducts = [
        BasketProduct(id: "", name: "product1", rating: 0, price: 0.0, images: []),
        BasketProduct(id: "", name: "product2", rating: 0, price: 0.0, images: []),
        BasketProduct(id: "", name: "product3", rating: 0, price: 0.0, images: []),
    ]
    
    // MARK: - Testing Functions for BasketPresenterProtocol Methods
    
    func testLifecycleFunctions() {
        let presenter = BasketPresenterStub()
        let viewController = BasketViewController()
        viewController.configure(presenter)
        
        viewController.viewWillAppear(false)
        viewController.viewDidDisappear(false)
        
        XCTAssertTrue(presenter.viewWillAppearCalled)
        XCTAssertTrue(presenter.viewDidDisappearCalled)
    }
    
    func testEqualArrays() {
        let presenter = BasketPresenterStub()
        presenter.products = mockProducts
        
        let countGettingFromMethod = presenter.getCountOfProducts()
        let countGettingFromProperty = presenter.products.count
        let countInFact = mockProducts.count
        
        XCTAssertEqual(countGettingFromMethod, countGettingFromProperty)
        XCTAssertEqual(countGettingFromMethod, countInFact)
    }
    
    func testGettingProducts() {
        let presenter = BasketPresenterStub()
        presenter.products = mockProducts
        let index = 0
        
        let productFromPresenter = presenter.getCurrentProduct(at: index)
        let productInFact = mockProducts[index]
        
        XCTAssertEqual(productFromPresenter, productInFact)
    }
    
    func testSuccessFindProduct() {
        let presenter = BasketPresenterStub()
        presenter.products = mockProducts
        
        let product = presenter.findProduct(withName: "product3")
        
        XCTAssertNotNil(product)
    }
    
    func testFailureFindProduct() {
        let presenter = BasketPresenterStub()
        presenter.products = mockProducts
        
        let product = presenter.findProduct(withName: "banana")
        
        XCTAssertNil(product)
    }
    
    func testSuccessDeletingProductInPresenter() {
        let presenter = BasketPresenterStub()
        presenter.products = mockProducts
        presenter.chosenIndex = 1
        
        presenter.deleteProduct()
        let countGettingFromProperty = presenter.products.count
        let countInFact = mockProducts.count
        
        XCTAssertTrue(presenter.deleteProductCalledSuccessfull)
        XCTAssertNotEqual(countGettingFromProperty, countInFact)
    }
    
    func testFailureDeletingProductInPresenter() {
        let presenter = BasketPresenterStub()
        presenter.products = mockProducts
        presenter.chosenIndex = nil
        
        presenter.deleteProduct()
        let countGettingFromProperty = presenter.products.count
        let countInFact = mockProducts.count
        
        XCTAssertFalse(presenter.deleteProductCalledSuccessfull)
        XCTAssertEqual(countGettingFromProperty, countInFact)
    }
}

final class BasketPresenterStub: BasketPresenterProtocol {
    var viewWillAppearCalled: Bool = false
    var viewDidDisappearCalled: Bool = false
    var deleteProductCalledSuccessfull: Bool = false
    var chosenIndex: Int?
    var products: [BasketProduct] = []
    var viewController: BasketViewControllerProtocol?
    
    init() {
        viewController = nil
    }
    
    init(viewController: BasketViewControllerProtocol) {
        self.viewController = viewController
    }
    
    func viewWillAppear() {
        viewWillAppearCalled = true
    }
    
    func viewDidDisappear() {
        viewDidDisappearCalled = true
    }
    
    func getCountOfProducts() -> Int {
        products.count
    }
    
    func getCurrentProduct(at index: Int) -> BasketProduct {
        products[index]
    }
    
    func deleteProduct() {
        guard let chosenIndex,
              chosenIndex > -1
        else {
            print("[BasketPresenterStub/deleteProduct]. Тест провален.\nПричина: не присвоили значение chosenIndex для удаления определенного элемента.")
            return
        }
        products.remove(at: chosenIndex)
        deleteProductCalledSuccessfull = true
    }
    
    func findProduct(withName name: String) -> BasketProduct? {
        guard let index = products.firstIndex(where: { $0.name == name })
        else { return nil }
        return getCurrentProduct(at: index)
    }
    
    func countNewInfoForPaymentCard() { }
    func sortParameterChanged(to newParameter: String) { }
}

extension BasketProduct: Equatable {
    public static func == (lhs: BasketProduct, rhs: BasketProduct) -> Bool {
        guard lhs.id == rhs.id,
              lhs.name == rhs.name,
              lhs.price == rhs.price,
              lhs.rating == rhs.rating,
              lhs.images == rhs.images
        else { return false }
        return true
    }
}
