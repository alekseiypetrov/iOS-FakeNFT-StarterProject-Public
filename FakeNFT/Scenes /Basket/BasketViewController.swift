import UIKit

final class BasketViewController: UIViewController {
    
    // MARK: - Constants
    
    private enum Constants {
        static let sortingButtonImage = UIImage(resource: .nbSort)
    }
    
    // MARK: - UI-elements
    
    private lazy var sortingButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            image: Constants.sortingButtonImage,
            style: .plain,
            target: self,
            action: #selector(sortingButtonPressed)
        )
        button.tintColor = UIColor(resource: .ypBlack)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Actions
    
    @objc
    private func sortingButtonPressed() { }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        view.backgroundColor = UIColor(resource: .ypWhite)
        navigationItem.rightBarButtonItem = sortingButton
    }
}
