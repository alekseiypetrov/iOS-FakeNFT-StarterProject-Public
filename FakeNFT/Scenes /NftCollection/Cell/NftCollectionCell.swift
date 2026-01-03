import UIKit

final class NftCollectionCell: UICollectionViewCell {

    static let reuseIdentifier = "NftCollectionCell"

    // MARK: - UI

    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let ratingLabel = UILabel()
    private let priceLabel = UILabel()

    private let infoStack = UIStackView()

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

        // Image
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .systemGray3
        imageView.clipsToBounds = true

        // Title
        titleLabel.font = .systemFont(ofSize: 14, weight: .medium)
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 1

        // Rating
        ratingLabel.font = .systemFont(ofSize: 12)
        ratingLabel.textColor = .secondaryLabel

        // Price
        priceLabel.font = .systemFont(ofSize: 12, weight: .medium)
        priceLabel.textColor = .secondaryLabel

        // Stack
        infoStack.axis = .vertical
        infoStack.spacing = 4
        infoStack.translatesAutoresizingMaskIntoConstraints = false

        infoStack.addArrangedSubview(titleLabel)
        infoStack.addArrangedSubview(ratingLabel)
        infoStack.addArrangedSubview(priceLabel)

        contentView.addSubview(imageView)
        contentView.addSubview(infoStack)

        NSLayoutConstraint.activate([
            // Image
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),

            // Info
            infoStack.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            infoStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            infoStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            infoStack.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8)
        ])
    }

    // MARK: - Configuration

    func configure(with nft: Nft) {
        titleLabel.text = nft.name
        ratingLabel.text = "⭐️ \(nft.rating)"
        priceLabel.text = "\(nft.price) ETH"
    }
}
