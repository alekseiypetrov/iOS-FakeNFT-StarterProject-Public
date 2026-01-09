@testable import FakeNFT

final class BasketPresenterStub: BasketPresenterProtocol {
    var viewWillAppearCalled: Bool = false
    var viewDidDisappearCalled: Bool = false
    var deleteProductCalledSuccessfull: Bool = false
    var changedParameter: SortOption?
    var chosenIndex: Int?
    var products: [Nft] = [] {
        didSet {
            viewController?.updateCellsFromTable()
            viewController?.showTable()
        }
    }
    var viewController: BasketViewControllerProtocol?
    
    init() {
        viewController = nil
    }
    
    init(viewController: BasketViewControllerProtocol) {
        self.viewController = viewController
    }
    
    func sortParameterChanged(to newParameter: FakeNFT.SortOption) { 
        changedParameter = newParameter
    }
    
    func viewWillAppear() {
        viewWillAppearCalled = true
    }
    
    func viewDidDisappear() {
        viewDidDisappearCalled = true
    }
    
    var productsAmount: Int {
        products.count
    }
    
    func getCurrentProduct(at index: Int) -> Nft {
        products[index]
    }
    
    func deleteProduct() {
        guard let chosenIndex,
              chosenIndex > -1
        else {
            print("[BasketPresenterStub/deleteProduct]. Тест провален.\nПричина: не присвоили значение chosenIndex для удаления определенного элемента.")
            viewController?.showUpdatingStatus(false)
            return
        }
        products.remove(at: chosenIndex)
        deleteProductCalledSuccessfull = true
        viewController?.showUpdatingStatus(true)
        viewController?.deleteCellFromTable(at: chosenIndex)
    }
    
    func findProduct(withName name: String) -> Nft? {
        guard let index = products.firstIndex(where: { $0.name == name })
        else { return nil }
        return getCurrentProduct(at: index)
    }
    
    func countNewInfoForPaymentCard() {
        viewController?.updateInfoInPaymentCard(newCount: 0, newCost: 0.0)
    }
    
    func sortParameterChanged(to newParameter: String) {
        viewController?.updateCellsFromTable()
    }
    
    // Временно
    func viewDidLoad() { }
}
