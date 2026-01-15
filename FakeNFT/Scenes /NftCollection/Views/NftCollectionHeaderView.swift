import UIKit

final class NftCollectionHeaderView: UIView {

    // MARK: - Preview (3 NFT)

    private let previewContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        view.layer.cornerRadius = 12
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let firstImageView = UIImageView()
    private let secondImageView = UIImageView()
    private let thirdImageView = UIImageView()

    // MARK: - Text block

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
        label.textColor = .systemBlue
        label.isUserInteractionEnabled = true
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

    // MARK: - Callbacks

    var onAuthorTap: (() -> Void)?

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }

    // MARK: - Configuration

    func configure(
        title: String,
        author: String,
        description: String
    ) {
        titleLabel.text = title
        authorLabel.text = "Автор коллекции: \(author)"
        descriptionLabel.text = description
    }

    // MARK: - Setup

    private func setupUI() {
        [firstImageView, secondImageView, thirdImageView].forEach {
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
            $0.backgroundColor = .systemGray4 // заглушка
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        let tap = UITapGestureRecognizer(target: self, action: #selector(authorTapped))
        authorLabel.addGestureRecognizer(tap)
    }

    private func setupLayout() {
        addSubview(previewContainerView)
        addSubview(titleLabel)
        addSubview(authorLabel)
        addSubview(descriptionLabel)

        previewContainerView.addSubview(firstImageView)
        previewContainerView.addSubview(secondImageView)
        previewContainerView.addSubview(thirdImageView)

        NSLayoutConstraint.activate([
            // Preview container
            previewContainerView.topAnchor.constraint(equalTo: topAnchor),
            previewContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            previewContainerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            previewContainerView.heightAnchor.constraint(equalToConstant: 310),

            // Preview images
            firstImageView.leadingAnchor.constraint(equalTo: previewContainerView.leadingAnchor),
            firstImageView.topAnchor.constraint(equalTo: previewContainerView.topAnchor),
            firstImageView.bottomAnchor.constraint(equalTo: previewContainerView.bottomAnchor),

            secondImageView.leadingAnchor.constraint(equalTo: firstImageView.trailingAnchor),
            secondImageView.topAnchor.constraint(equalTo: previewContainerView.topAnchor),
            secondImageView.bottomAnchor.constraint(equalTo: previewContainerView.bottomAnchor),
            secondImageView.widthAnchor.constraint(equalTo: firstImageView.widthAnchor),

            thirdImageView.leadingAnchor.constraint(equalTo: secondImageView.trailingAnchor),
            thirdImageView.topAnchor.constraint(equalTo: previewContainerView.topAnchor),
            thirdImageView.bottomAnchor.constraint(equalTo: previewContainerView.bottomAnchor),
            thirdImageView.widthAnchor.constraint(equalTo: firstImageView.widthAnchor),
            thirdImageView.trailingAnchor.constraint(equalTo: previewContainerView.trailingAnchor),

            // Text block
            titleLabel.topAnchor.constraint(equalTo: previewContainerView.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            authorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            authorLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            authorLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            descriptionLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }

    // MARK: - Actions

    @objc private func authorTapped() {
        onAuthorTap?()
    }
}
