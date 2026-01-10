@testable import FakeNFT
import Foundation

final class UserAgreementPresenterStub: UserAgreementPresenterProtocol {
    
    var viewWillAppearCalled: Bool = false
    var viewDidDisappearCalled: Bool = false
    
    weak var viewController: UserAgreementWebViewProtocol?
    
    func viewWillAppear() {
        viewWillAppearCalled = true
        viewController?.startLoadingPage(withRequest: URLRequest(url: URL.trashDirectory))
    }
    
    func viewDidDisappear() {
        viewDidDisappearCalled = true
        viewController?.stopLoadingPage()
    }
    
    func updateProgress(toValue value: Double) {
        viewController?.setNewProgressValue(value)
    }
}
