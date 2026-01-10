import UIKit
import Kingfisher

final class ConfirmingDeletionView: UIView {
    
    // MARK: - Constants
    
    private enum Constants {
        static let cornerRadius: CGFloat = 12.0
        static let sizeOfImageView = CGSize(width: 108, height: 108)
        static let heightOfButtons: CGFloat = 44.0
        
        enum AttributedTitles {
            static let forQuestion = NSAttributedString(
                string: NSLocalizedString("ConfirmingDeletion.question", comment: ""),
                attributes: [.font: UIFont.caption2,
                             .foregroundColor: UIColor(resource: .ypBlack)
                ]
            )
            static let forDeleteButton = NSAttributedString(
                string: NSLocalizedString("ConfirmingDeletion.deleteButton", comment: ""),
                attributes: [.font: UIFont.bodyRegular,
                             .foregroundColor: UIColor(resource: .ypRed)
                ]
            )
            static let forCancelButton = NSAttributedString(
                string: NSLocalizedString("ConfirmingDeletion.cancelButton", comment: ""),
                attributes: [.font: UIFont.bodyRegular,
                             .foregroundColor: UIColor(resource: .ypWhite)
                ]
            )
        }
    }
    
    // MARK: - UI-elements
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(
            image: UIImage(resource: .copConfirmingDeletion)
        )
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = Constants.cornerRadius
        imageView.widthAnchor.constraint(equalToConstant: Constants.sizeOfImageView.width).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: Constants.sizeOfImageView.height).isActive = true
        return imageView
    }()
    
    private lazy var questionLabel: UILabel = {
        let label = UILabel()
        label.attributedText = Constants.AttributedTitles.forQuestion
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(Constants.AttributedTitles.forDeleteButton, for: .normal)
        button.backgroundColor = UIColor(resource: .ypBlack)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = Constants.cornerRadius
        button.addTarget(self, action: #selector(deleteButtonTouched), for: .touchUpInside)
        button.heightAnchor.constraint(equalToConstant: Constants.heightOfButtons).isActive = true
        button.accessibilityIdentifier = AccessibilityIdentifier.BasketView.confirmingDeleteButton
        return button
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(Constants.AttributedTitles.forCancelButton, for: .normal)
        button.backgroundColor = UIColor(resource: .ypBlack)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = Constants.cornerRadius
        button.addTarget(self, action: #selector(cancelButtonTouched), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Public Properties
    
    var imageOfNft: String = "" {
        didSet {
            imageView.kf.setImage(with: URL(string: imageOfNft))
        }
    }
    
    // MARK: - Private Properties
    
    private var buttonAction: ((Bool) -> ())?
    
    // MARK: - Initializers
    
    init(_ buttonAction: ((Bool) -> ())?) {
        super.init(frame: .zero)
        self.buttonAction = buttonAction
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    // MARK: - Actions
    
    @objc
    private func deleteButtonTouched() {
        buttonAction?(true)
    }
    
    @objc
    private func cancelButtonTouched() {
        buttonAction?(false)
    }
    
    // MARK: - Private Methods
    
    private func setupView() {
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
        
        [imageView, questionLabel, deleteButton, cancelButton]
            .forEach({
                addSubview($0)
                $0.translatesAutoresizingMaskIntoConstraints = false
            })
        
        NSLayoutConstraint.activate([
            
            // imageView Constraints
            
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.bottomAnchor.constraint(equalTo: questionLabel.topAnchor, constant: -12.0),
            
            // questionLabel Constraints
            
            questionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20.0),
            questionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20.0),
            questionLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            questionLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -24.0),
            
            // deleteButton Constraints
            
            deleteButton.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 20.0),
            deleteButton.trailingAnchor.constraint(equalTo: cancelButton.leadingAnchor, constant: -8.0),
            deleteButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 56.0),
            
            // cancelButton Constraints
            
            cancelButton.heightAnchor.constraint(equalTo: deleteButton.heightAnchor),
            cancelButton.widthAnchor.constraint(equalTo: deleteButton.widthAnchor),
            cancelButton.topAnchor.constraint(equalTo: deleteButton.topAnchor),
            cancelButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -56.0),
        ])
    }
}
