import UIKit

final class PaymentCardView: UIView {
    
    // MARK: - Constants
    
    private enum Constants {
        enum Heights {
            static let heightOfPaymentButton: CGFloat = 44.0
        }
        enum CornerRadiuses {
            static let cornerRadiusOfView: CGFloat = 12.0
            static let cornerRadiusOfButton: CGFloat = 16.0
        }
        enum Fonts {
            static let fontOfAmountNftsLabel = UIFont.systemFont(ofSize: 15.0, weight: .regular)
            static let fontOfTotalCostLabelAndButton = UIFont.boldSystemFont(ofSize: 17.0)
        }
        enum Sizes {
            static let sizeOfAmountNftsLabel = CGSize(width: 42, height: 20)
            static let sizeOfTotalCostLabel = CGSize(width: 79, height: 22)
        }
        static let attributedStringForButton = NSAttributedString(
            string: NSLocalizedString("Basket.paymentButton", comment: ""),
            attributes: [.font: Fonts.fontOfTotalCostLabelAndButton,
                         .foregroundColor: UIColor(resource: .ypWhite)]
        )
    }
    
    // MARK: - UI-elements
    
    private lazy var amountNftsLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Fonts.fontOfAmountNftsLabel
        label.textColor = UIColor(resource: .ypBlack)
        return label
    }()
    
    private lazy var totalCostLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Fonts.fontOfTotalCostLabelAndButton
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
            amountNftsLabel.widthAnchor.constraint(equalToConstant: Constants.Sizes.sizeOfAmountNftsLabel.width),
            amountNftsLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16.0),
            amountNftsLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.0),
            
            // totalCostLabel Constraints
            
            totalCostLabel.heightAnchor.constraint(equalToConstant: Constants.Sizes.sizeOfTotalCostLabel.height),
            totalCostLabel.widthAnchor.constraint(equalToConstant: Constants.Sizes.sizeOfTotalCostLabel.width),
            totalCostLabel.topAnchor.constraint(equalTo: amountNftsLabel.bottomAnchor, constant: 2.0),
            totalCostLabel.leadingAnchor.constraint(equalTo: amountNftsLabel.leadingAnchor),
            
            // paymentButton Constraints
            
            paymentButton.heightAnchor.constraint(equalToConstant: Constants.Heights.heightOfPaymentButton),
            paymentButton.topAnchor.constraint(equalTo: amountNftsLabel.topAnchor),
            paymentButton.leadingAnchor.constraint(equalTo: totalCostLabel.trailingAnchor, constant: 24.0),
            paymentButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.0),
        ])
        
        updateAmountNfts(0)
        updateTotalCost(0.0)
    }
}
