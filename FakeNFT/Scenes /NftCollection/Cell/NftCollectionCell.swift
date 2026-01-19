import UIKit
import Kingfisher

final class NftCollectionCell: UICollectionViewCell, ReuseIdentifying {
    
    // MARK: - UI
    private let imageView = UIImageView()
    private let favoriteButton = UIButton(type: .custom)
    
    private let titleLabel = UILabel()
    private let ratingImageView = UIImageView()
    private let priceLabel = UILabel()
    private let cartButton = UIButton(type: .custom)
    
    private let infoStack = UIStackView()
    private let bottomStack = UIStackView()
    
    // MARK: - Actions
    private var onFavoriteTap: (() -> Void)?
    private var onCartTap: (() -> Void)?
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        assertionFailure("init(coder:) is not supported")
        super.init(coder: coder)
    }
    
    // MARK: - Actions
    @objc private func favoriteTapped() {
        onFavoriteTap?()
    }
    
    @objc private func cartTapped() {
        onCartTap?()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 12
        contentView.clipsToBounds = true
        
        setupImage()
        setupFavoriteButton()
        setupLabels()
        setupCartButton()
        setupStacks()
        setupConstraints()
        
        favoriteButton.addTarget(self, action: #selector(favoriteTapped), for: .touchUpInside)
        cartButton.addTarget(self, action: #selector(cartTapped), for: .touchUpInside)
    }
    
    private func setupImage() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .systemGray3
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        
        contentView.addSubview(imageView)
    }
    
    private func setupFavoriteButton() {
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.backgroundColor = .clear
        favoriteButton.layer.cornerRadius = 0
        favoriteButton.clipsToBounds = false
        favoriteButton.tintColor = .clear
        favoriteButton.adjustsImageWhenHighlighted = false
        favoriteButton.contentEdgeInsets = .zero
        
        contentView.addSubview(favoriteButton)
    }
    
    private func setupLabels() {
        // Название NFT
        titleLabel.font = .systemFont(ofSize: 17, weight: .bold)
        titleLabel.textColor = UIColor(named: "ypBlack") ?? .label
        titleLabel.numberOfLines = 1
        
        // Цена NFT
        let priceFont = UIFont.systemFont(ofSize: 10, weight: .medium)
        let priceAttributes: [NSAttributedString.Key: Any] = [
            .font: priceFont,
            .kern: -0.24,
            .foregroundColor: UIColor(named: "ypBlack") ?? .label
        ]
        
        priceLabel.attributedText = NSAttributedString(
            string: "",
            attributes: priceAttributes
        )
    }
    
    private func setupCartButton() {
        cartButton.setImage(UIImage(systemName: "cart"), for: .normal)
        cartButton.tintColor = .label
        cartButton.adjustsImageWhenHighlighted = false
    }
    
    private func setupStacks() {
        infoStack.axis = .vertical
        infoStack.spacing = 4
        
        bottomStack.axis = .horizontal
        bottomStack.alignment = .center
        bottomStack.spacing = 8
        bottomStack.distribution = .fill
        
        ratingImageView.contentMode = .left
        ratingImageView.translatesAutoresizingMaskIntoConstraints = false
        
        infoStack.addArrangedSubview(ratingImageView)
        infoStack.addArrangedSubview(bottomStack)
        infoStack.addArrangedSubview(priceLabel)
        
        bottomStack.addArrangedSubview(titleLabel)
        bottomStack.addArrangedSubview(UIView())
        bottomStack.addArrangedSubview(cartButton)
        
        infoStack.translatesAutoresizingMaskIntoConstraints = false
        bottomStack.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(infoStack)
    }
    
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Image
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            
            // Favorite button
            favoriteButton.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 8),
            favoriteButton.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -8),
            favoriteButton.widthAnchor.constraint(equalToConstant: 28),
            favoriteButton.heightAnchor.constraint(equalToConstant: 28),
            
            // Info stack
            infoStack.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            infoStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            infoStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        ])
        
        cartButton.setContentHuggingPriority(.required, for: .horizontal)
        cartButton.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    
    // MARK: - Configuration
    
    func configure(
        with model: NftCellModel,
        onFavoriteTap: @escaping () -> Void,
        onCartTap: @escaping () -> Void
    ) {
        
        if let url = model.imageURL {
            imageView.kf.setImage(
                with: url,
                placeholder: nil,
                options: [
                    .transition(.fade(0.2)),
                    .cacheOriginalImage
                ]
            )
            imageView.backgroundColor = .clear
        } else {
            imageView.image = nil
            imageView.backgroundColor = .systemGray3
        }
        
        titleLabel.text = model.name
        
        let priceText = "\(model.price) ETH"
        
        priceLabel.attributedText = NSAttributedString(
            string: priceText,
            attributes: [
                .font: UIFont.systemFont(ofSize: 10, weight: .medium),
                .kern: -0.24,
                .foregroundColor: UIColor(named: "ypBlack") ?? .label
            ]
        )
        
        let rating = max(0, min(5, model.rating))
        ratingImageView.image = UIImage(named: "copRating\(rating)")
        
        let favoriteImageName = model.isFavorite
        ? "copFavouriteDefault"
        : "copFavouritePressed"
        
        favoriteButton.setImage(
            UIImage(named: favoriteImageName),
            for: .normal
        )
        
        let cartImageName = model.isInCart
        ? "copDeleteFromCart"
        : "copAddToCart"
        
        cartButton.setImage(
            UIImage(named: cartImageName),
            for: .normal
        )
        
        self.onFavoriteTap = onFavoriteTap
        self.onCartTap = onCartTap
    }
}
