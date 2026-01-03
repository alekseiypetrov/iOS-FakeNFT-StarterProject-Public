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
}

final class PaymentPresenterStub: PaymentPresenterProtocol {
    var viewWillAppearCalled: Bool = false
    var viewDidDisappearCalled: Bool = false
    
    var heightOfCell: CGFloat = 0.0
    var spacing: CGFloat = 0.0
    var currencies: [Currency] = []
    
    func viewWillAppear() {
        viewWillAppearCalled = true
    }
    
    func viewDidDisappear() {
        viewDidDisappearCalled = true
    }
    
    func getNumberOfCurrencies() -> Int {
        currencies.count
    }
    
    func getCurrency(at index: Int) -> Currency {
        currencies[index]
    }
}

extension Currency: Equatable {
    public static func == (lhs: Currency, rhs: Currency) -> Bool {
        guard lhs.title == rhs.title,
              lhs.name == rhs.name,
              lhs.image == rhs.image
        else { return false }
        return true
    }
}
