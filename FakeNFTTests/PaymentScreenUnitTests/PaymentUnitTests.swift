@testable import FakeNFT
import XCTest

final class PaymentUnitTests: XCTestCase {
    
    // MARK: - Private Properties
    
    private let mockCurrencies: [Currency] = [
        Currency(title: "", name: "Bitcoin", image: ""),
        Currency(title: "", name: "Ethereum", image: ""),
        Currency(title: "", name: "TON", image: ""),
        Currency(title: "", name: "BNB", image: ""),
    ]
    
    // MARK: - Testing Functions for PaymentPresenterProtocol Methods
    
    func testLifecycleFunctions() {
        let presenter = PaymentPresenterStub()
        let viewController = PaymentViewController()
        viewController.configure(presenter)
        
        viewController.viewWillAppear(false)
        viewController.viewDidDisappear(false)
        
        XCTAssertTrue(presenter.viewWillAppearCalled)
        XCTAssertTrue(presenter.viewDidDisappearCalled)
    }
    
    func testEqualArrays() {
        let presenter = PaymentPresenterStub()
        presenter.currencies = mockCurrencies
        
        let countGettingFromMethod = presenter.getNumberOfCurrencies()
        let countGettingFromProperty = presenter.currencies.count
        let countInFact = mockCurrencies.count
        
        XCTAssertEqual(countGettingFromMethod, countGettingFromProperty)
        XCTAssertEqual(countGettingFromMethod, countInFact)
    }
    
    func testGettingCurrencies() {
        let presenter = PaymentPresenterStub()
        presenter.currencies = mockCurrencies
        let index = 2
        
        let currencyFromPresenter = presenter.getCurrency(at: index)
        let currencyInFact = mockCurrencies[index]
        
        XCTAssertEqual(currencyFromPresenter, currencyInFact)
    }
    
    // MARK: - Testing Functions for PaymentViewControllerProtocol Methods
    
    func testHidingCollection() {
        let viewController = PaymentViewControllerStub()
        let presenter = PaymentPresenter(viewController: viewController)
        
        presenter.viewWillAppear()
        presenter.viewDidDisappear() // для остановки сетевых запросов
        
        XCTAssertTrue(viewController.hideCollectionCalled)
    }
    
    func testShowingCollection() {
        let viewController = PaymentViewControllerStub()
        let presenter = PaymentPresenterStub(viewController: viewController)
        
        presenter.currencies = mockCurrencies
        
        XCTAssertTrue(viewController.showCollectionCalled)
    }
}
