import UIKit

final class PaymentCardView: UIView {
    
    // MARK: - Constants
    
    private enum Constants {
        enum Widths {
            static let minimumWidthForButton: CGFloat = 100.0
            static let maximumWidthForButton: CGFloat = 240.0
        }
        enum CornerRadiuses {
            static let cornerRadiusOfView: CGFloat = 12.0
            static let cornerRadiusOfButton: CGFloat = 16.0
        }
        enum Sizes {
            static let sizeOfAmountNftsLabel = CGSize(width: 42, height: 20)
            static let sizeOfTotalCostLabel = CGSize(width: 79, height: 22)
        }
        static let attributedStringForButton = NSAttributedString(
            string: NSLocalizedString("Basket.paymentButton", comment: ""),
            attributes: [.font: UIFont.bodyBold,
                         .foregroundColor: UIColor(resource: .ypWhite)]
        )
    }
    
    // MARK: - UI-elements
    
    private lazy var amountNftsLabel: UILabel = {
        let label = UILabel()
        label.font = .caption1
        label.textColor = UIColor(resource: .ypBlack)
        return label
    }()
    
    private lazy var totalCostLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyBold
        label.textColor = UIColor(resource: .ypGreen)
        return label
    }()
    
    private lazy var paymentButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(Constants.attributedStringForButton, for: .normal)
        button.backgroundColor = UIColor(resource: .ypBlack)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = Constants.CornerRadiuses.cornerRadiusOfButton
        button.addTarget(self, action: #selector(paymentButtonTouched), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Private Properties
    
    private var buttonAction: (() -> ())?
    
    // MARK: - Initializers
    
    init(_ buttonAction: (() -> ())?) {
        super.init(frame: .zero)
        self.buttonAction = buttonAction
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    // MARK: - Public Methods
    
    func updateAmountNfts(_ amount: Int) { 
        amountNftsLabel.text = "\(amount) NFT"
    }
    
    func updateTotalCost(_ cost: Double) {
        let roundedCost = round(cost * 100) / 100.0
        totalCostLabel.text = "\(roundedCost) ETH"
    }
    
    func changeButtonState(toEnable isEnabled: Bool) {
        paymentButton.isEnabled = isEnabled
    }
    
    // MARK: - Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateCornerMask()
    }
    
    // MARK: - Actions
    
    @objc
    private func paymentButtonTouched() {
        buttonAction?()
    }
    
    // MARK: - Private Methods
    
    private func updateCornerMask() {
        let maskPath = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: [.topLeft, .topRight],
            cornerRadii: CGSize(width: Constants.CornerRadiuses.cornerRadiusOfView, height: Constants.CornerRadiuses.cornerRadiusOfView)
        )
        let maskLayer = CAShapeLayer()
        maskLayer.path = maskPath.cgPath
        layer.mask = maskLayer
    }
    
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor(resource: .ypLightGrey)
        
        [amountNftsLabel, totalCostLabel, paymentButton]
            .forEach({
                addSubview($0)
                $0.translatesAutoresizingMaskIntoConstraints = false
            })
        
        NSLayoutConstraint.activate([
            
            // amountNftsLabel Constraints
            
            amountNftsLabel.heightAnchor.constraint(equalToConstant: Constants.Sizes.sizeOfAmountNftsLabel.height),
            amountNftsLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16.0),
            amountNftsLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.0),
            
            // totalCostLabel Constraints
            
            totalCostLabel.heightAnchor.constraint(equalToConstant: Constants.Sizes.sizeOfTotalCostLabel.height),
            totalCostLabel.topAnchor.constraint(equalTo: amountNftsLabel.bottomAnchor, constant: 2.0),
            totalCostLabel.leadingAnchor.constraint(equalTo: amountNftsLabel.leadingAnchor),
            
            // paymentButton Constraints
            
            paymentButton.topAnchor.constraint(equalTo: amountNftsLabel.topAnchor),
            paymentButton.bottomAnchor.constraint(equalTo: totalCostLabel.bottomAnchor),
            paymentButton.leadingAnchor.constraint(equalTo: totalCostLabel.trailingAnchor, constant: 24.0),
            paymentButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.0),
            paymentButton.widthAnchor.constraint(lessThanOrEqualToConstant: Constants.Widths.maximumWidthForButton),
            paymentButton.widthAnchor.constraint(greaterThanOrEqualToConstant: Constants.Widths.minimumWidthForButton),
        ])
        
        updateAmountNfts(0)
        updateTotalCost(0.0)
    }
}
