import UIKit
import Kingfisher

final class PaymentCollectionViewCell: UICollectionViewCell, ReuseIdentifying {
    
    // MARK: - Constants
    
    private enum Constants {
        static let sizeOfImage = CGSize(width: 36.0, height: 36.0)
        static let cornerRadiusOfImage: CGFloat = 6.0
        static let cornerRadiusOfView: CGFloat = 12.0
    }
    
    // MARK: - UI-elements
    
    private lazy var background: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(resource: .ypLightGrey)
        view.layer.cornerRadius = Constants.cornerRadiusOfImage
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var currencyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = UIColor(resource: .ypBlackUniversal)
        imageView.layer.cornerRadius = Constants.cornerRadiusOfImage
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var currencyFullNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.caption2
        label.textColor = UIColor(resource: .ypBlack)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var currencyShortNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.caption2
        label.textColor = UIColor(resource: .ypGreen)
        label.textAlignment = .left
        return label
    }()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    // MARK: - Public Methods
    
    func config(from currency: Currency) {
        currencyFullNameLabel.text = currency.title
        currencyShortNameLabel.text = currency.name
        currencyImageView.kf.indicatorType = .activity
        currencyImageView.kf.setImage(with: URL(string: currency.image))
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        contentView.backgroundColor = UIColor(resource: .ypWhite)
        [background, currencyImageView, currencyFullNameLabel, currencyShortNameLabel]
            .forEach{
                contentView.addSubview($0)
                $0.translatesAutoresizingMaskIntoConstraints = false
            }
        background.constraintEdges(to: contentView)
        NSLayoutConstraint.activate([
            
            // currencyImageView Constraints
            
            currencyImageView.widthAnchor.constraint(equalToConstant: Constants.sizeOfImage.width),
            currencyImageView.heightAnchor.constraint(equalToConstant: Constants.sizeOfImage.height),
            currencyImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5.0),
            currencyImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12.0),
            
            // currencyFullNameLabel Constraints
            
            currencyFullNameLabel.leadingAnchor.constraint(equalTo: currencyImageView.trailingAnchor, constant: 4.0),
            currencyFullNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12.0),
            currencyFullNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5.0),
            
            // currencyShortNameLabel Constraints
            
            currencyShortNameLabel.leadingAnchor.constraint(equalTo: currencyFullNameLabel.leadingAnchor),
            currencyShortNameLabel.trailingAnchor.constraint(equalTo: currencyFullNameLabel.trailingAnchor),
            currencyShortNameLabel.topAnchor.constraint(equalTo: currencyFullNameLabel.bottomAnchor),
            currencyShortNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5.0),
        ])
    }
}
