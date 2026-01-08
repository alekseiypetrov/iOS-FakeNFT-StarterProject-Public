import UIKit

final class ConfirmingPurchaseView: UIView {
    
    // MARK: - Constants
    
    private enum Constants {
        enum CornerRadiuses {
            static let ofView: CGFloat = 12.0
            static let ofButton: CGFloat = 16.0
        }
        enum Heights {
            static let ofTitleLabel: CGFloat = 18.0
            static let ofLinkButton: CGFloat = 26.0
        }
        enum AttributedTitles {
            static let forLinkButton = NSAttributedString(
                string: NSLocalizedString("Payment.linkButton", comment: ""),
                attributes: [.font: UIFont.caption2,
                             .foregroundColor: UIColor(resource: .ypBlue)]
            )
            static let forPaymentButton = NSAttributedString(
                string: NSLocalizedString("Payment.paymentButton", comment: ""),
                attributes: [.font: UIFont.bodyBold,
                             .foregroundColor: UIColor(resource: .ypWhite)]
            )
        }
    }
    
    // MARK: - UI-elements
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .caption2
        label.textColor = UIColor(resource: .ypBlack)
        label.text = NSLocalizedString("Payment.titleLabel", comment: "")
        return label
    }()
    
    private lazy var linkButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(Constants.AttributedTitles.forLinkButton, for: .normal)
        button.contentHorizontalAlignment = .left
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(showUserAgreement), for: .touchUpInside)
        return button
    }()
    
    private lazy var paymentButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(Constants.AttributedTitles.forPaymentButton, for: .normal)
        button.backgroundColor = UIColor(resource: .ypBlack)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = Constants.CornerRadiuses.ofButton
        button.addTarget(self, action: #selector(paymentButtonTouched), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Private Properties
    
    private var paymentButtonAction: (() -> ())?
    private var linkButtonAction: (() -> ())?
    
    // MARK: - Initializers
    
    init(linkButtonAction: (() -> ())?, paymentButtonAction: (() -> ())?) {
        super.init(frame: .zero)
        self.linkButtonAction = linkButtonAction
        self.paymentButtonAction = paymentButtonAction
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    // MARK: - Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateCornerMask()
    }
    
    // MARK: - Actions
    
    @objc
    private func showUserAgreement() { 
        linkButtonAction?()
    }
    
    @objc
    private func paymentButtonTouched() {
        paymentButtonAction?()
    }
    
    // MARK: - Private Methods
    
    private func updateCornerMask() {
        let maskPath = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: [.topLeft, .topRight],
            cornerRadii: CGSize(width: Constants.CornerRadiuses.ofView, height: Constants.CornerRadiuses.ofView)
        )
        let maskLayer = CAShapeLayer()
        maskLayer.path = maskPath.cgPath
        layer.mask = maskLayer
    }
    
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor(resource: .ypLightGrey)
        
        [titleLabel, linkButton, paymentButton]
            .forEach({
                addSubview($0)
                $0.translatesAutoresizingMaskIntoConstraints = false
            })
        
        NSLayoutConstraint.activate([
            
            // titleLabel Constraints
            
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16.0),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.0),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.0),
            titleLabel.heightAnchor.constraint(equalToConstant: Constants.Heights.ofTitleLabel),
            
            // linkButton Constraints
            
            linkButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            linkButton.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            linkButton.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            linkButton.heightAnchor.constraint(equalToConstant: Constants.Heights.ofLinkButton),
            
            // paymentButton Constraints
            
            paymentButton.topAnchor.constraint(equalTo: linkButton.bottomAnchor, constant: 16.0),
            paymentButton.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            paymentButton.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            paymentButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16.0),
        ])
    }
}
