import Foundation

protocol PaymentPresenterProtocol {
    var heightOfCell: CGFloat { get }
    var spacing: CGFloat { get }
    func getNumberOfCurrencies() -> Int
    func getCurrency(at index: Int) -> Currency
    func viewWillAppear()
    func viewDidDisappear()
}

final class PaymentPresenter {
    
    // MARK: - Constants
    
    private enum Constants {
        static let heightOfCell: CGFloat = 46.0
        static let spacing: CGFloat = 7.0
    }
    
    // MARK: - Private Properties
    
    private var currencies: [Currency] = []
    weak private var viewController: PaymentViewControllerProtocol?
    private var currencyService: CurrencyService
    
    // MARK: - Initializers
    
    init(viewController: PaymentViewControllerProtocol?) {
        self.viewController = viewController
        let networkClient = DefaultNetworkClient()
        currencyService = CurrencyLoader(networkClient: networkClient)
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
            }
        }
    }
    
    private func stopUploadingData() {
        currencyService.stopLoading()
    }
}

extension PaymentPresenter: PaymentPresenterProtocol {
    var heightOfCell: CGFloat {
        Constants.heightOfCell
    }
    
    var spacing: CGFloat {
        Constants.spacing
    }
    
    func getNumberOfCurrencies() -> Int {
        currencies.count
    }
    
    func getCurrency(at index: Int) -> Currency {
        currencies[index]
    }
    
    func viewWillAppear() {
        DispatchQueue.global().async {
            self.uploadData()
        }
        viewController?.hideCollection()
    }
    
    func viewDidDisappear() {
        stopUploadingData()
    }
}
