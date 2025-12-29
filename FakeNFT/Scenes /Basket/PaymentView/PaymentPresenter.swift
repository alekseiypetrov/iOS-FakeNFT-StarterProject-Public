import Foundation

protocol PaymentPresenterProtocol {
    var heightOfCell: CGFloat { get }
    var spacing: CGFloat { get }
    func getNumberOfCurrencies() -> Int
    func getCurrency(at index: Int) -> Currency
    func viewDidLoad()
}

final class PaymentPresenter {
    
    // MARK: - Constants
    
    private enum Constants {
        static let heightOfCell: CGFloat = 46.0
        static let spacing: CGFloat = 7.0
    }
    
    // MARK: - Private Properties
    
    // TODO: - will be removed later (моковые данные)
    private var currencies: [Currency] = [
        Currency(
            title: "Shiba_Inu",
            name: "SHIB",
            image: "https://code.s3.yandex.net/Mobile/iOS/Currencies/Shiba_Inu_(SHIB).png"
        ),
        Currency(
            title: "Cardano",
            name: "ADA",
            image: "https://code.s3.yandex.net/Mobile/iOS/Currencies/Cardano_(ADA).png"
        ),
        Currency(title: "Tether",
                 name: "USDT",
                 image: "https://code.s3.yandex.net/Mobile/iOS/Currencies/Tether_(USDT).png"
        ),
        Currency(title: "ApeCoin",
                 name: "APE",
                 image: "https://code.s3.yandex.net/Mobile/iOS/Currencies/ApeCoin_(APE).png"
        ),
        Currency(
            title: "Solana",
            name: "SOL",
            image: "https://code.s3.yandex.net/Mobile/iOS/Currencies/Solana_(SOL).png"
        ),
    ]
    weak private var viewController: PaymentViewControllerProtocol?
    
    // MARK: - Initializers
    
    init(viewController: PaymentViewControllerProtocol?) {
        self.viewController = viewController
    }
    
    // MARK: - Private Methods
    
    private func currenciesDelivered() {
        
    }
    
    // TODO: - will be removed later (пока вместо сетевого запроса)
    private func returnMockData() {
        viewController?.showCollection()
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
    
    func viewDidLoad() {
        viewController?.hideCollection()
        // TODO: - will be done later (запрос в сеть)
        returnMockData()
    }
}

