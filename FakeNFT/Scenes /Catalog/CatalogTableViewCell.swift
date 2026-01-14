import UIKit

final class CatalogTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "CatalogTableViewCell"
    
    // MARK: - UI
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    // MARK: - Preview
    private let previewContainerView = UIView()
    
    private let firstImageView = UIImageView()
    private let secondImageView = UIImageView()
    private let thirdImageView = UIImageView()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        selectionStyle = .none
        
        titleLabel.font = .systemFont(ofSize: 17, weight: .bold)
        titleLabel.textColor = UIColor(named: "ypBlack")
        titleLabel.numberOfLines = 1
        
        previewContainerView.backgroundColor = .systemGray5
        previewContainerView.layer.cornerRadius = 12
        previewContainerView.clipsToBounds = true
        
        [firstImageView, secondImageView, thirdImageView].forEach {
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
            $0.backgroundColor = .systemGray4 // заглушка
        }
    }
    
    private func setupLayout() {
        
        previewContainerView.translatesAutoresizingMaskIntoConstraints = false
        firstImageView.translatesAutoresizingMaskIntoConstraints = false
        secondImageView.translatesAutoresizingMaskIntoConstraints = false
        thirdImageView.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(previewContainerView)
        contentView.addSubview(titleLabel)
        
        previewContainerView.addSubview(firstImageView)
        previewContainerView.addSubview(secondImageView)
        previewContainerView.addSubview(thirdImageView)
        
        NSLayoutConstraint.activate([
            previewContainerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            previewContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            previewContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            previewContainerView.heightAnchor.constraint(equalToConstant: 179)
        ])
        
        // Превью
        NSLayoutConstraint.activate([
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
            thirdImageView.trailingAnchor.constraint(equalTo: previewContainerView.trailingAnchor)
        ])
        
        // Заголовок под превью
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: previewContainerView.bottomAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: previewContainerView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: previewContainerView.trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.text = nil
        
        [firstImageView, secondImageView, thirdImageView].forEach {
            $0.image = nil
            $0.backgroundColor = .systemGray4
        }
    }
    
    func setPreviewImageURLs(_ urls: [URL?]) {
        let imageViews = [firstImageView, secondImageView, thirdImageView]

        for (imageView, url) in zip(imageViews, urls) {
            imageView.image = nil
            imageView.backgroundColor = .systemGray4

            guard let url else { continue }

            URLSession.shared.dataTask(with: url) { [weak imageView] data, _, _ in
                guard
                    let data,
                    let image = UIImage(data: data)
                else { return }

                DispatchQueue.main.async {
                    imageView?.image = image
                }
            }.resume()
        }
    }
    
    // MARK: - Configuration
    
    func configure(title: String, count: Int) {
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 17, weight: .bold),
            .foregroundColor: UIColor(named: "ypBlack") ?? .black
        ]
        
        let countAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 17, weight: .bold),
            .foregroundColor: UIColor(named: "ypBlack") ?? .black
        ]
        
        let attributedText = NSMutableAttributedString(
            string: title,
            attributes: titleAttributes
        )
        
        attributedText.append(
            NSAttributedString(
                string: " (\(count))",
                attributes: countAttributes
            )
        )
        
        titleLabel.attributedText = attributedText
    }
}
