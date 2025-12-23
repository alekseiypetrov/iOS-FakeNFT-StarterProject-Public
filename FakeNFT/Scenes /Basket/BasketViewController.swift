import UIKit

final class BasketViewController: UIViewController {
    
    // MARK: - Constants
    
    private enum Constants {
        static let sortingButtonImage = UIImage(resource: .nbSort)
        static let heightOfCardView: CGFloat = 76.0
    }
    
    // MARK: - UI-elements
    
    private lazy var sortingButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            image: Constants.sortingButtonImage,
            style: .plain,
            target: self,
            action: #selector(sortingButtonPressed)
        )
        button.tintColor = UIColor(resource: .ypBlack)
        return button
    }()
    
    private lazy var paymentCard: PaymentCardView = {
        PaymentCardView { [weak self] in
            let paymentController = PaymentViewController()
            let navigationController = UINavigationController(rootViewController: paymentController)
            navigationController.modalPresentationStyle = .fullScreen
            self?.present(navigationController, animated: true)
        }
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Actions
    
    @objc
    private func sortingButtonPressed() { }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        view.backgroundColor = UIColor(resource: .ypWhite)
        navigationItem.rightBarButtonItem = sortingButton
        
        [paymentCard]
            .forEach({
                view.addSubview($0)
                $0.translatesAutoresizingMaskIntoConstraints = false
            })
        NSLayoutConstraint.activate([
            
            // paymentCard Constraints
            
            paymentCard.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            paymentCard.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            paymentCard.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            paymentCard.heightAnchor.constraint(equalToConstant: Constants.heightOfCardView)
        ])
    }
}
