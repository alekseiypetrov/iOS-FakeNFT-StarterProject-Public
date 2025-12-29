import UIKit

final class PaymentViewController: UIViewController {
    
    private enum Constants {
        static let heightOfCell: CGFloat = 46.0
        static let spacing: CGFloat = 7.0
    }
    
    // MARK: - UI-elements
    
    private lazy var backButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            image: UIImage(resource: .nbBack),
            style: .plain,
            target: self,
            action: #selector(backButtonPressed)
        )
        button.tintColor = UIColor(resource: .ypBlack)
        return button
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.backgroundColor = self.view.backgroundColor
        collection.allowsSelection = true
        collection.isScrollEnabled = false
        collection.delegate = self
        collection.dataSource = self
        collection.register(PaymentCollectionViewCell.self)
        return collection
    }()
    
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
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Actions
    
    @objc
    private func backButtonPressed() {
        dismiss(animated: true)
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        view.backgroundColor = UIColor(resource: .ypWhite)
        navigationItem.leftBarButtonItem = backButton
        navigationItem.title = NSLocalizedString("Payment.navigationTitle", comment: "")
        
        [collectionView]
            .forEach{
                view.addSubview($0)
                $0.translatesAutoresizingMaskIntoConstraints = false
            }
        NSLayoutConstraint.activate([
            
            // collectionView Constraints
            
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20.0),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0),
            // TODO: - will be fixed later (поменять на topAnchor "карточки" для подтверждения и выполнения оплаты)
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: - PaymentViewController + UICollectionViewDataSource

extension PaymentViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        currencies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: PaymentCollectionViewCell = collectionView.dequeueReusableCell(indexPath: indexPath)
        let currency = currencies[indexPath.row]
        cell.config(from: currency)
        return cell
    }
}

// MARK: - PaymentViewController + UICollectionViewDelegate

extension PaymentViewController: UICollectionViewDelegateFlowLayout {
    private func changeStateOfCell(_ collectionView: UICollectionView, atIndexPath indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? PaymentCollectionViewCell
        else { return }
        cell.changeBorder()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) { 
        changeStateOfCell(collectionView, atIndexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        changeStateOfCell(collectionView, atIndexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(
            width: (collectionView.frame.width - Constants.spacing) / 2,
            height: Constants.heightOfCell
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        Constants.spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        Constants.spacing
    }
}
