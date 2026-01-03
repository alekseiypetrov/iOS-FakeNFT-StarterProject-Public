import UIKit

final class NftCollectionCell: UICollectionViewCell {

    static let reuseIdentifier = "NftCollectionCell"

    // MARK: - UI

    private let imageView = UIImageView()
    private let favoriteButton = UIButton(type: .system)

    private let titleLabel = UILabel()
    private let ratingLabel = UILabel()
    private let priceLabel = UILabel()
    private let cartButton = UIButton(type: .system)

    private let infoStack = UIStackView()
    private let bottomStack = UIStackView()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    // MARK: - Setup

    private func setupUI() {
        contentView.backgroundColor = .systemGray5
        contentView.layer.cornerRadius = 12
        contentView.clipsToBounds = true

        setupImage()
        setupFavoriteButton()
        setupLabels()
        setupCartButton()
        setupStacks()
        setupConstraints()
    }

    private func setupImage() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .systemGray3
        imageView.clipsToBounds = true

        contentView.addSubview(imageView)
    }

    private func setupFavoriteButton() {
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
        favoriteButton.tintColor = .white
        favoriteButton.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        favoriteButton.layer.cornerRadius = 14

        contentView.addSubview(favoriteButton)
    }

    private func setupLabels() {
        titleLabel.font = .systemFont(ofSize: 14, weight: .medium)
        titleLabel.numberOfLines = 1

        ratingLabel.font = .systemFont(ofSize: 12)
        ratingLabel.textColor = .secondaryLabel

        priceLabel.font = .systemFont(ofSize: 12, weight: .medium)
        priceLabel.textColor = .label
    }

    private func setupCartButton() {
        cartButton.setImage(UIImage(systemName: "cart"), for: .normal)
        cartButton.tintColor = .label
    }

    private func setupStacks() {
        infoStack.axis = .vertical
        infoStack.spacing = 4

        bottomStack.axis = .horizontal
        bottomStack.alignment = .center
        bottomStack.distribution = .equalSpacing

        infoStack.addArrangedSubview(titleLabel)
        infoStack.addArrangedSubview(ratingLabel)

        bottomStack.addArrangedSubview(priceLabel)
        bottomStack.addArrangedSubview(cartButton)

        infoStack.translatesAutoresizingMaskIntoConstraints = false
        bottomStack.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(infoStack)
        contentView.addSubview(bottomStack)
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
            infoStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),

            // Bottom stack
            bottomStack.topAnchor.constraint(equalTo: infoStack.bottomAnchor, constant: 8),
            bottomStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            bottomStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            bottomStack.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8)
        ])
    }

    // MARK: - Configuration

    func configure(with nft: Nft) {
        titleLabel.text = nft.name
        ratingLabel.text = "⭐️ \(nft.rating)"
        priceLabel.text = "\(nft.price) ETH"
    }
}
