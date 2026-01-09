@testable import FakeNFT
import XCTest

final class BasketUnitTests: XCTestCase {
    
    // MARK: - Private Properties
    
    private let mockProducts = [
        Nft(id: "", name: "product1", images: [], rating: 0, price: 0.0),
        Nft(id: "", name: "product2", images: [], rating: 0, price: 0.0),
        Nft(id: "", name: "product3", images: [], rating: 0, price: 0.0),
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
        
        let countGettingFromMethod = presenter.productsAmount
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
    
    func testChangingSortParameter() {
        let presenter = BasketPresenterStub()
        
        presenter.sortParameterChanged(to: .byName)
        
        XCTAssertNotNil(presenter.changedParameter)
    }
    
    // MARK: - Testing Functions For BasketViewControllerProtocol Methods
    
    func testUpdatingInfoInPaymentCard() {
        let viewController = BasketViewControllerStub()
        let presenter = BasketPresenter(viewController: viewController)
        
        presenter.countNewInfoForPaymentCard()
        
        XCTAssertTrue(viewController.updateInfoInPaymentCardCalled)
    }
    
    func testHidingTable() {
        let viewController = BasketViewControllerStub()
        let presenter = BasketPresenter(viewController: viewController)
        
        presenter.viewWillAppear()
        presenter.viewDidDisappear() // для остановки сетевых запросов
        
        XCTAssertTrue(viewController.hideTableCalled)
    }
    
    func testShowingAndUpdatingTableWhenOrderLoaded() {
        let viewController = BasketViewControllerStub()
        let presenter = BasketPresenterStub(viewController: viewController)
        viewController.configure(presenter)
        
        presenter.products = mockProducts
        
        XCTAssertTrue(viewController.showTableCalled)
        XCTAssertTrue(viewController.updateCellsFromTableCalled)
        XCTAssertTrue(viewController.updateInfoInPaymentCardCalled)
    }
    
    func testUpdatingTableWhenSortingParameterChanged() {
        let viewController = BasketViewControllerStub()
        let presenter = BasketPresenterStub(viewController: viewController)
        viewController.configure(presenter)
        
        presenter.products = mockProducts
        
        XCTAssertTrue(viewController.updateCellsFromTableCalled)
        XCTAssertTrue(viewController.updateInfoInPaymentCardCalled)
    }
    
    // MARK: - Testing Functions For Both Protocols
    
    func testSuccessDeletingProduct() {
        let viewController = BasketViewControllerStub()
        let presenter = BasketPresenterStub(viewController: viewController)
        viewController.configure(presenter)
        presenter.products = mockProducts
        presenter.chosenIndex = 1
        
        presenter.deleteProduct()
        let countGettingFromProperty = presenter.products.count
        let countInFact = mockProducts.count
        
        XCTAssertTrue(presenter.deleteProductCalledSuccessfull)
        XCTAssertNotEqual(countGettingFromProperty, countInFact)
        XCTAssertTrue(viewController.deleteCellFromTableCalled)
        XCTAssertTrue(viewController.showUpdatingStatusCalled)
        XCTAssertEqual(presenter.deleteProductCalledSuccessfull, viewController.updatingStatus)
        XCTAssertEqual(presenter.chosenIndex, viewController.deletingIndex)
    }
    
    func testFailureDeletingProduct() {
        let viewController = BasketViewControllerStub()
        let presenter = BasketPresenterStub(viewController: viewController)
        viewController.configure(presenter)
        presenter.products = mockProducts
        presenter.chosenIndex = nil
        
        presenter.deleteProduct()
        let countGettingFromProperty = presenter.products.count
        let countInFact = mockProducts.count
        
        XCTAssertFalse(presenter.deleteProductCalledSuccessfull)
        XCTAssertEqual(countGettingFromProperty, countInFact)
        XCTAssertFalse(viewController.deleteCellFromTableCalled)
        XCTAssertTrue(viewController.showUpdatingStatusCalled)
        XCTAssertEqual(presenter.deleteProductCalledSuccessfull, viewController.updatingStatus)
        XCTAssertNotEqual(presenter.chosenIndex, viewController.deletingIndex)
    }
    
}
