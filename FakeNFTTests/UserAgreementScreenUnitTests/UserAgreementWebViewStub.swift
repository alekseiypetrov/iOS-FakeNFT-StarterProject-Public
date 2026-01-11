@testable import FakeNFT
import Foundation

final class UserAgreementWebViewStub: UserAgreementWebViewProtocol {
    
    var pageStartedToLoad: Bool = false
    var pageStoppedToLoad: Bool = false
    var wasNoMistake: Bool = true
    var progressHidden: Bool = false
    var newProgressValue: CGFloat?
    
    private var presenter: UserAgreementPresenterProtocol?
    
    func configure(_ presenter: UserAgreementPresenterProtocol) {
        self.presenter = presenter
    }
    
    func startLoadingPage(withRequest request: URLRequest) { 
        pageStartedToLoad = true
    }
    
    func stopLoadingPage() {
        pageStoppedToLoad = true
    }
    
    func setNewProgressValue(_ newValue: CGFloat) {
        newProgressValue = newValue
    }
    
    func hideProgress() {
        progressHidden = true
    }
    
    func showError() {
        wasNoMistake = false
    }
}
