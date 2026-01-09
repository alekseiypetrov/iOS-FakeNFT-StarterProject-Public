@testable import FakeNFT
import Foundation

final class PaymentPresenterStub: PaymentPresenterProtocol {
    var viewWillAppearCalled: Bool = false
    var viewDidDisappearCalled: Bool = false
    var executePaymentCalled: Bool = false
    var cellWasSelected: Int? = nil
    
    var heightOfCell: CGFloat = 0.0
    var spacing: CGFloat = 0.0
    weak var viewController: PaymentViewControllerProtocol?
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
    
    var currenciesAmount: Int {
        currencies.count
    }
    
    func getCurrency(at index: Int) -> Currency {
        currencies[index]
    }
    
    func cellDidSelected(withIndex index: Int) { 
        cellWasSelected = index
    }
    
    func executePayment() { 
        executePaymentCalled = true
        if cellWasSelected != nil {
            viewController?.showSuccessfulPaymentScreen()
        } else {
            viewController?.showAlert(forReason: .notSelectedCurrency)
        }
    }
}
