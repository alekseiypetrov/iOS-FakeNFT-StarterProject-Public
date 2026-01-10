import UIKit

protocol SuccessfulPaymentViewControllerProtocol: AnyObject {
    func configure(_ presenter: SuccessfulPaymentPresenterProtocol)
    func showError()
    func returnToBasket()
}

final class SuccessfulPaymentViewController: UIViewController {
    
    // MARK: - Constants
    
    private enum Constants {
        static let imageSize = CGSize(width: 278, height: 278)
        static let cornerRadius: CGFloat = 16.0
        static let buttonHeight: CGFloat = 60.0
        static let buttonTitle = NSAttributedString(
            string: NSLocalizedString("SuccessfulPayment.button", comment: ""),
            attributes: [
                .font: UIFont.bodyBold,
                .foregroundColor: UIColor(resource: .ypWhite)
            ]
        )
    }
    
    // MARK: - UI-elements
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(resource: .copSuccessfulPayment))
        imageView.widthAnchor.constraint(equalToConstant: Constants.imageSize.width).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: Constants.imageSize.height).isActive = true
        imageView.accessibilityIdentifier = AccessibilityIdentifier.SuccessfulPaymentView.imageView
        return imageView
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = UIFont.headline3
        label.textColor = UIColor(resource: .ypBlack)
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.text = NSLocalizedString("SuccessfulPayment.label", comment: "")
        label.accessibilityIdentifier = AccessibilityIdentifier.SuccessfulPaymentView.label
        return label
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = Constants.cornerRadius
        button.clipsToBounds = true
        button.setAttributedTitle(Constants.buttonTitle,
                                  for: .normal)
        button.backgroundColor = UIColor(resource: .ypBlack)
        button.addTarget(self, action: #selector(backToBasket), for: .touchUpInside)
        button.heightAnchor.constraint(equalToConstant: Constants.buttonHeight).isActive = true
        button.accessibilityIdentifier = AccessibilityIdentifier.SuccessfulPaymentView.button
        return button
    }()
    
    // MARK: - Private Properties
    
    private var presenter: SuccessfulPaymentPresenterProtocol?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Actions
    
    @objc
    private func backToBasket() {
        UIProgressHUD.show()
        presenter?.cleanOrder()
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        view.backgroundColor = UIColor(resource: .ypWhite)
        navigationItem.leftBarButtonItem = nil
        navigationItem.setHidesBackButton(true, animated: false)
        
        [imageView, label, button]
            .forEach {
                view.addSubview($0)
                $0.translatesAutoresizingMaskIntoConstraints = false
            }
        
        NSLayoutConstraint.activate([
            
            // imageView Constraints
            
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -36.0),
            
            // label Constraints
            
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20.0),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 36.0),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -36.0),
            
            // button Constraints
            
            button.topAnchor.constraint(greaterThanOrEqualTo: label.bottomAnchor, constant: 16.0),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16.0),
        ])
    }
}

// MARK: - SuccessfulPaymentViewController + SuccessfulPaymentViewControllerProtocol

extension SuccessfulPaymentViewController: SuccessfulPaymentViewControllerProtocol {
    func configure(_ presenter: SuccessfulPaymentPresenterProtocol) {
        self.presenter = presenter
    }
    
    func showError() {
        UIProgressHUD.dismiss()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            UIProgressHUD.showError()
        }
    }
    
    func returnToBasket() {
        UIProgressHUD.dismiss()
        dismiss(animated: true)
    }
}
