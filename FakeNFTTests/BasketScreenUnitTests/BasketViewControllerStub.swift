@testable import FakeNFT

final class BasketViewControllerStub: BasketViewControllerProtocol {
    var updateInfoInPaymentCardCalled: Bool = false
    var updateCellsFromTableCalled: Bool = false
    var deleteCellFromTableCalled: Bool = false
    var deletingIndex: Int = -1
    var showTableCalled: Bool = false
    var hideTableCalled: Bool = false
    var showUpdatingStatusCalled: Bool = false
    var updatingStatus: Bool?
    var presenter: BasketPresenterProtocol?
    
    func configure(_ presenter: BasketPresenterProtocol) {
        self.presenter = presenter
    }
    
    func updateInfoInPaymentCard(newCount: Int, newCost: Double) {
        updateInfoInPaymentCardCalled = true
    }
    
    func updateCellsFromTable() {
        updateCellsFromTableCalled = true
        presenter?.countNewInfoForPaymentCard()
    }
    
    func deleteCellFromTable(at index: Int) {
        deletingIndex = index
        deleteCellFromTableCalled = true
        presenter?.countNewInfoForPaymentCard()
    }
    
    func showTable() {
        showTableCalled = true
    }
    
    func hideTable() {
        hideTableCalled = true
    }
    
    func showUpdatingStatus(_ isSuccessfull: Bool) {
        updatingStatus = isSuccessfull
        showUpdatingStatusCalled = true
    }
}
