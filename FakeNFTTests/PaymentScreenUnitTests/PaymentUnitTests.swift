@testable import FakeNFT
import XCTest

final class PaymentUnitTests: XCTestCase {
    
    // MARK: - Private Properties
    
    private let mockCurrencies: [Currency] = [
        Currency(id: "", title: "", name: "Bitcoin", imageName: ""),
        Currency(id: "", title: "", name: "Ethereum", imageName: ""),
        Currency(id: "", title: "", name: "TON", imageName: ""),
        Currency(id: "", title: "", name: "BNB", imageName: ""),
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
        
        let countGettingFromMethod = presenter.currenciesAmount
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
    
    // MARK: - Testing Functions For Both Protocols
    
    func testSuccessPayment() {
        let presenter = PaymentPresenterStub()
        let viewController = PaymentViewControllerStub()
        presenter.viewController = viewController
        viewController.configure(presenter)
        presenter.currencies = mockCurrencies
        
        presenter.cellDidSelected(withIndex: 0)
        presenter.executePayment()
        
        XCTAssertNotNil(presenter.cellWasSelected)
        XCTAssertTrue(presenter.executePaymentCalled)
        XCTAssertTrue(viewController.showSuccessfulPaymentScreenCalled)
        XCTAssertFalse(viewController.showAlertCalled)
    }
    
    func testFailurePayment() {
        let presenter = PaymentPresenterStub()
        let viewController = PaymentViewControllerStub()
        presenter.viewController = viewController
        viewController.configure(presenter)
        presenter.currencies = mockCurrencies
        
        presenter.executePayment()
        
        XCTAssertNil(presenter.cellWasSelected)
        XCTAssertTrue(presenter.executePaymentCalled)
        XCTAssertFalse(viewController.showSuccessfulPaymentScreenCalled)
        XCTAssertTrue(viewController.showAlertCalled)
        
    }
}
