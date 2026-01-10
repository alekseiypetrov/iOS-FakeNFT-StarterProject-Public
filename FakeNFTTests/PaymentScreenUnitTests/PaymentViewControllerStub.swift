@testable import FakeNFT

final class PaymentViewControllerStub: PaymentViewControllerProtocol {
    var showCollectionCalled: Bool = false
    var hideCollectionCalled: Bool = false
    var showAlertCalled: Bool = false
    var showSuccessfulPaymentScreenCalled: Bool = false
    
    private var presenter: PaymentPresenterProtocol?
    
    func hideCollection() {
        hideCollectionCalled = true
    }
    
    func showCollection() {
        showCollectionCalled = true
    }
    
    func configure(_ presenter: FakeNFT.PaymentPresenterProtocol) { 
        self.presenter = presenter
    }
    
    func showAlert(forReason reason: FakeNFT.AlertReason) {
        showAlertCalled = true
    }
    func showSuccessfulPaymentScreen() { 
        showSuccessfulPaymentScreenCalled = true
    }
}
