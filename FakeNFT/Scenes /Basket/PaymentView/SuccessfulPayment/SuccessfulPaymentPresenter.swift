protocol SuccessfulPaymentPresenterProtocol {
    func cleanOrder()
}

final class SuccessfulPaymentPresenter {
    
    // MARK: - Private Properties
    
    weak private var viewController: SuccessfulPaymentViewControllerProtocol?
    private var orderService: OrderService
    private let logger = StatusLogger.shared
    
    // MARK: - Initializers
    
    init(viewController: SuccessfulPaymentViewControllerProtocol?) {
        self.viewController = viewController
        let networkClient = DefaultNetworkClient()
        orderService = OrderLoader(networkClient: networkClient)
        self.viewController?.configure(self)
    }
}

// MARK: - SuccessfulPaymentPresenter + SuccessfulPaymentPresenterProtocol

extension SuccessfulPaymentPresenter: SuccessfulPaymentPresenterProtocol {
    func cleanOrder() {
        orderService.makeOrderRequest(ofType: .put, withNfts: []) { [weak self] result in
            switch result {
            case .failure(let error):
                self?.logger.sendErrorMessage(
                    withText: "[SuccessfulPaymentPresenter/cleanOrder]: возникла ошибка при очистке заказа",
                    andError: error
                )
                self?.viewController?.showError()
            case .success:
                self?.logger.sendCommonMessage(
                    withText: "[SuccessfulPaymentPresenter/cleanOrder]: заказ очищен, возвращение в корзину"
                )
                self?.viewController?.returnToBasket()
            }
        }
    }
}
