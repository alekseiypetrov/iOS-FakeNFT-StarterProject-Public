import Foundation

protocol UserAgreementPresenterProtocol: AnyObject {
    func viewWillAppear()
    func viewDidDisappear()
    func updateProgress(toValue value: Double)
}

final class UserAgreementPresenter {
    
    // MARK: - Private Properties
    
    private weak var viewController: UserAgreementWebViewProtocol?
    private let userAgreementRequest: NetworkRequest
    
    // MARK: - Initializers
    
    init(_ viewController: UserAgreementWebViewProtocol) {
        userAgreementRequest = UserAgreementRequest()
        self.viewController = viewController
        self.viewController?.configure(self)
    }
    
    // MARK: - Private Methods
    
    private func makeRequest() -> URLRequest? {
        guard let url = userAgreementRequest.endpoint else { return nil }
        return URLRequest(url: url)
    }
}

// MARK: - UserAgreementPresenter + UserAgreementPresenterProtocol

extension UserAgreementPresenter: UserAgreementPresenterProtocol {
    func viewWillAppear() {
        guard let request = makeRequest()
        else {
            viewController?.showError()
            return
        }
        updateProgress(toValue: 0.0)
        viewController?.startLoadingPage(withRequest: request)
    }
    
    func viewDidDisappear() {
        viewController?.stopLoadingPage()
    }
    
    func updateProgress(toValue value: Double) {
        viewController?.setNewProgressValue(CGFloat(value))
        if abs(value - 1.0) <= 0.001 {
            viewController?.hideProgress()
        }
    }
}
