import UIKit

final class NftCollectionHeaderView: UIView {

    // MARK: - UI

    private let coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.backgroundColor = .systemGray5
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 22)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let authorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }

    // MARK: - Public

    func configure(
        title: String,
        author: String,
        description: String,
        coverURL: URL?
    ) {
        titleLabel.text = title
        authorLabel.text = "Автор коллекции: \(author)"
        descriptionLabel.text = description
    }

    // MARK: - Layout

    private func setupLayout() {
        addSubview(coverImageView)
        addSubview(titleLabel)
        addSubview(authorLabel)
        addSubview(descriptionLabel)

        NSLayoutConstraint.activate([
            coverImageView.topAnchor.constraint(equalTo: topAnchor),
            coverImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            coverImageView.widthAnchor.constraint(equalToConstant: 108),
            coverImageView.heightAnchor.constraint(equalToConstant: 108),

            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: coverImageView.trailingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),

            authorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            authorLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            authorLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            descriptionLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    // MARK: - Image loading (temporary)

    private func loadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard
                let self,
                let data,
                let image = UIImage(data: data)
            else { return }

            DispatchQueue.main.async {
                self.coverImageView.image = image
            }
        }.resume()
    }
}
