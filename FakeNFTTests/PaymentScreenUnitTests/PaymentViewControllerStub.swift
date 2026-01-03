@testable import FakeNFT

final class PaymentViewControllerStub: PaymentViewControllerProtocol {
    var showCollectionCalled: Bool = false
    var hideCollectionCalled: Bool = false
    
    func hideCollection() {
        hideCollectionCalled = true
    }
    
    func showCollection() {
        showCollectionCalled = true
    }
}
