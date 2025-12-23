import UIKit

final class PaymentViewController: UIViewController {
    
    // MARK: - Constants
    
    private enum Constants {
        static let backButtonImage = UIImage(resource: .nbBack)
        static let navigationBarTitle = NSLocalizedString("Payment.navigationTitle", comment: "")
    }
    
    // MARK: - UI-elements
    
    private lazy var backButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            image: Constants.backButtonImage,
            style: .plain,
            target: self,
            action: #selector(backButtonPressed)
        )
        button.tintColor = UIColor(resource: .ypBlack)
        return button
    }()
    
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
        navigationItem.title = Constants.navigationBarTitle
    }
}
