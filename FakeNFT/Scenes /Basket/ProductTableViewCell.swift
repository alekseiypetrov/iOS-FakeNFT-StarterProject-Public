import UIKit
import Kingfisher

final class ProductTableViewCell: UITableViewCell, ReuseIdentifying {
    
    // MARK: - Constants
    
    private enum Constants {
        enum Sizes {
            static let sizeOfRating = CGSize(width: 68.0, height: 12.0)
            static let sizeOfDeleteButton = CGSize(width: 40.0, height: 40.0)
        }
        enum Heights {
            static let heightOfTitleAndPrice: CGFloat = 22.0
            static let heightOfStaticPriceLabel: CGFloat = 18.0
        }
        static let cornerRadius: CGFloat = 12.0
    }
    
    // MARK: - UI-elements
    
    private lazy var productImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = UIColor(resource: .ypBackground)
        imageView.layer.cornerRadius = Constants.cornerRadius
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var productTitle: UILabel = {
        let label = UILabel()
        label.font = .bodyBold
        label.textAlignment = .left
        label.textColor = UIColor(resource: .ypBlack)
        label.text = "Title"
        return label
    }()
    
    private lazy var productRating: UIImageView = {
        UIImageView(
            image: UIImage(resource: .copRating0)
        )
    }()
    
    private lazy var staticPriceLabel: UILabel = {
        let label = UILabel()
        label.font = .caption2
        label.textAlignment = .left
        label.textColor = UIColor(resource: .ypBlack)
        label.text = NSLocalizedString("Basket.cell.staticPriceLabel", comment: "")
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyBold
        label.textAlignment = .left
        label.textColor = UIColor(resource: .ypBlack)
        label.text = "0 ETH"
        return label
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.setImage(
            UIImage(resource: .copDeleteFromCart)
                .withTintColor(UIColor(resource: .ypBlack)),
            for: .normal)
        button.addTarget(self, action: #selector(deleteProductFromBasket), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Public Properties
    
    var delegate: ProductTableViewCellDelegate?
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) { nil }
    
    // MARK: - Lifecycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        delegate = nil
        productTitle.text = ""
        productRating.image = getRating(from: 0)
        priceLabel.text = "0.0 ETH"
        productImage.image = nil
    }
    
    // MARK: - Actions
    
    @objc
    private func deleteProductFromBasket() {
        guard let title = productTitle.text else { return }
        delegate?.deleteButtonPushedInCell(withTitle: title)
    }
    
    // MARK: - Public Methods
    
    func configure(by model: Nft, withDelegate delegate: ProductTableViewCellDelegate) {
        self.delegate = delegate
        productImage.kf.indicatorType = .activity
        productTitle.text = model.name
        productRating.image = getRating(from: model.rating)
        priceLabel.text = "\(model.price) ETH"
        guard let imageUrl = model.images.first else { return }
        productImage.kf.setImage(with: URL(string: imageUrl),
                                 options: [
                                    .transition(.fade(0.3)),
                                    .cacheOriginalImage
                                 ]
        )
    }
    
    // MARK: - Private Methods
    
    private func getRating(from rating: Int) -> UIImage {
        switch rating {
        case 1:
            UIImage(resource: .copRating1)
        case 2:
            UIImage(resource: .copRating2)
        case 3:
            UIImage(resource: .copRating3)
        case 4:
            UIImage(resource: .copRating4)
        case 5:
            UIImage(resource: .copRating5)
        default:
            UIImage(resource: .copRating0)
        }
    }
    
    private func setupUI() {
        contentView.backgroundColor = UIColor(resource: .ypWhite)
        
        [productImage, productTitle, productRating, staticPriceLabel, priceLabel, deleteButton]
            .forEach({
                contentView.addSubview($0)
                $0.translatesAutoresizingMaskIntoConstraints = false
            })
        NSLayoutConstraint.activate([
            
            // productImage Constraints
            
            productImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.0),
            productImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16.0),
            productImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16.0),
            productImage.widthAnchor.constraint(equalTo: productImage.heightAnchor),
            
            // productTitle Constraints 
            
            productTitle.topAnchor.constraint(equalTo: productImage.topAnchor, constant: 8.0),
            productTitle.leadingAnchor.constraint(equalTo: productImage.trailingAnchor, constant: 20.0),
            productTitle.heightAnchor.constraint(equalToConstant: Constants.Heights.heightOfTitleAndPrice),
            productTitle.trailingAnchor.constraint(equalTo: deleteButton.leadingAnchor, constant: -20.0),
            
            // productRating Constraints
            
            productRating.topAnchor.constraint(equalTo: productTitle.bottomAnchor, constant: 4.0),
            productRating.leadingAnchor.constraint(equalTo: productTitle.leadingAnchor),
            productRating.heightAnchor.constraint(equalToConstant: Constants.Sizes.sizeOfRating.height),
            productRating.widthAnchor.constraint(equalToConstant: Constants.Sizes.sizeOfRating.width),
            
            // staticPriceLabel Constraints
            
            staticPriceLabel.topAnchor.constraint(equalTo: productRating.bottomAnchor, constant: 12.0),
            staticPriceLabel.leadingAnchor.constraint(equalTo: productTitle.leadingAnchor),
            staticPriceLabel.heightAnchor.constraint(equalToConstant: Constants.Heights.heightOfStaticPriceLabel),
            staticPriceLabel.trailingAnchor.constraint(equalTo: productTitle.trailingAnchor),
            
            // priceLabel Constraints
            
            priceLabel.topAnchor.constraint(equalTo: staticPriceLabel.bottomAnchor, constant: 2.0),
            priceLabel.leadingAnchor.constraint(equalTo: productTitle.leadingAnchor),
            priceLabel.heightAnchor.constraint(equalToConstant: Constants.Heights.heightOfTitleAndPrice),
            priceLabel.trailingAnchor.constraint(equalTo: productTitle.trailingAnchor),
            
            // deleteButton Constraints
            
            deleteButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.0),
            deleteButton.widthAnchor.constraint(equalToConstant: Constants.Sizes.sizeOfDeleteButton.width),
            deleteButton.heightAnchor.constraint(equalToConstant: Constants.Sizes.sizeOfDeleteButton.height),
        ])
    }
}
