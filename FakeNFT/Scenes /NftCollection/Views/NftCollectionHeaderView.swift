import UIKit
import Kingfisher

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

    func configure(with viewModel: NftCollectionHeaderViewModel) {
        titleLabel.text = viewModel.title
        
        let prefixAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 13, weight: .regular),
            .foregroundColor: UIColor(named: "ypBlack") ?? .label
        ]

        let authorAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 13, weight: .regular),
            .foregroundColor: UIColor.systemBlue
        ]

        let text = NSMutableAttributedString(
            string: "Автор коллекции: ",
            attributes: prefixAttributes
        )

        text.append(
            NSAttributedString(
                string: viewModel.authorName,
                attributes: authorAttributes
            )
        )

        authorLabel.attributedText = text
        
        descriptionLabel.text = viewModel.description
        setPreviewImageURLs(viewModel.previewImageURLs)
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
    
    // MARK: - Preview images

    func setPreviewImageURLs(_ urls: [URL]) {
        let imageViews = [firstImageView, secondImageView, thirdImageView]

        for (imageView, url) in zip(imageViews, urls) {
            imageView.kf.setImage(
                with: url,
                placeholder: nil,
                options: [
                    .transition(.fade(0.2)),
                    .cacheOriginalImage
                ]
            )
        }

        // Если картинок меньше 3 — остальные остаются серыми
        if urls.count < imageViews.count {
            for imageView in imageViews.dropFirst(urls.count) {
                imageView.image = nil
                imageView.backgroundColor = .systemGray4
            }
        }
    }
}
