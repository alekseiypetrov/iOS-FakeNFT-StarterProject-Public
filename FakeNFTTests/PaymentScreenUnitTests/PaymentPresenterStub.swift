@testable import FakeNFT
import Foundation

final class PaymentPresenterStub: PaymentPresenterProtocol {
    var viewWillAppearCalled: Bool = false
    var viewDidDisappearCalled: Bool = false
    
    var heightOfCell: CGFloat = 0.0
    var spacing: CGFloat = 0.0
    var viewController: PaymentViewControllerProtocol?
    var currencies: [Currency] = [] {
        didSet {
            viewController?.showCollection()
        }
    }
    
    init() {
        viewController = nil
    }
    
    init(viewController: PaymentViewControllerProtocol) {
        self.viewController = viewController
    }
    
    func viewWillAppear() {
        viewWillAppearCalled = true
        viewController?.hideCollection()
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
