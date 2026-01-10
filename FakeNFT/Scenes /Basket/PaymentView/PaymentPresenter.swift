import Foundation

protocol PaymentPresenterProtocol {
    var heightOfCell: CGFloat { get }
    var spacing: CGFloat { get }
    var currenciesAmount: Int { get }
    func getCurrency(at index: Int) -> Currency
    func viewWillAppear()
    func viewDidDisappear()
    func cellDidSelected(withIndex index: Int)
    func executePayment()
}

enum AlertReason: String {
    case notSelectedCurrency
    case notSuccessfulPayment
    case networkError
}

final class PaymentPresenter {
    
    // MARK: - Constants
    
    private enum Constants {
        static let heightOfCell: CGFloat = 46.0
        static let spacing: CGFloat = 7.0
    }
    
    // MARK: - Private Properties
    
    weak private var viewController: PaymentViewControllerProtocol?
    private var currencies: [Currency] = []
    private var currencyService: CurrencyService
    private var chosenCurrency: Int?
    private var paymentService: PaymentService
    
    // MARK: - Initializers
    
    init(viewController: PaymentViewControllerProtocol?) {
        self.viewController = viewController
        let networkClient = DefaultNetworkClient()
        currencyService = CurrencyLoader(networkClient: networkClient)
        paymentService = PaymentSender(networkClient: networkClient)
        self.viewController?.configure(self)
    }
    
    // MARK: - Private Methods
    
    private func uploadData() {
        currencyService.loadCurrency() { [weak self] result in
            print("[PaymentPresenter/uploadData]: валюты загружены")
            switch result {
            case .failure(let error):
                print("[PaymentPresenter/uploadData]: error - \(error)")
            case .success(let currencies):
                print("[PaymentPresenter/uploadData]: amount of currencies - \(currencies.count)")
                self?.currencies = currencies
                self?.viewController?.showCollection()
                self?.chosenCurrency = nil
            }
        }
    }
    
    private func stopUploadingData() {
        currencyService.stopLoading()
    }
}

// MARK: - PaymentPresenter + PaymentPresenterProtocol

extension PaymentPresenter: PaymentPresenterProtocol {
    var heightOfCell: CGFloat {
        Constants.heightOfCell
    }
    
    var spacing: CGFloat {
        Constants.spacing
    }
    
    var currenciesAmount: Int {
        currencies.count
    }
    
    func getCurrency(at index: Int) -> Currency {
        currencies[index]
    }
    
    func viewWillAppear() {
        print("[PaymentPresenter/viewWillAppear]: запуск сетевых запросов")
        DispatchQueue.global().async {
            self.uploadData()
        }
        viewController?.hideCollection()
    }
    
    func viewDidDisappear() {
        print("[PaymentPresenter/viewDidDisappear]: приостановка сетевых запросов")
        stopUploadingData()
    }
    
    func cellDidSelected(withIndex index: Int) {
        chosenCurrency = index
    }
    
    func executePayment() {
        guard let chosenCurrency
        else {
            viewController?.showAlert(forReason: .notSelectedCurrency)
            return
        }
        let id = currencies[chosenCurrency].id
        paymentService.payForOrder(byCurrencyWithId: id) { [weak self] result in
            switch result {
            case .failure:
                self?.viewController?.showAlert(forReason: .networkError)
            case .success(let response) where !response.success:
                self?.viewController?.showAlert(forReason: .notSuccessfulPayment)
            default:
                self?.viewController?.showSuccessfulPaymentScreen()
            }
        }
    }
}
