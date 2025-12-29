import UIKit

protocol PaymentViewControllerProtocol: AnyObject {
    func hideCollection()
    func showCollection()
}

final class PaymentViewController: UIViewController {
    
    // MARK: - UI-elements
    
    private lazy var backButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            image: UIImage(resource: .nbBack),
            style: .plain,
            target: self,
            action: #selector(backButtonPressed)
        )
        button.tintColor = UIColor(resource: .ypBlack)
        return button
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.backgroundColor = self.view.backgroundColor
        collection.allowsSelection = true
        collection.isScrollEnabled = false
        collection.delegate = self
        collection.dataSource = self
        collection.register(PaymentCollectionViewCell.self)
        return collection
    }()
    
    // MARK: - Private Properties
    
    private var presenter: PaymentPresenterProtocol?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.setupUI()
        }
        presenter?.viewDidLoad()
    }
    
    // MARK: - Actions
    
    @objc
    private func backButtonPressed() {
        dismiss(animated: true)
    }
    
    // MARK: - Public Methods
    
    func configure(_ presenter: PaymentPresenterProtocol) {
        self.presenter = presenter
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        view.backgroundColor = UIColor(resource: .ypWhite)
        navigationItem.leftBarButtonItem = backButton
        navigationItem.title = NSLocalizedString("Payment.navigationTitle", comment: "")
        
        [collectionView]
            .forEach{
                view.addSubview($0)
                $0.translatesAutoresizingMaskIntoConstraints = false
            }
        NSLayoutConstraint.activate([
            
            // collectionView Constraints
            
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20.0),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0),
            // TODO: - will be fixed later (поменять на topAnchor "карточки" для подтверждения и выполнения оплаты при выполнении 3/3 эпика)
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: - PaymentViewController + PaymentViewControllerProtocol

extension PaymentViewController: PaymentViewControllerProtocol {
    func hideCollection() {
        UIProgressHUD.show()
        collectionView.isHidden = true
    }
    
    func showCollection() {
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
        collectionView.isHidden = false
        UIProgressHUD.dismiss()
    }
}

// MARK: - PaymentViewController + UICollectionViewDataSource

extension PaymentViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter?.getNumberOfCurrencies() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: PaymentCollectionViewCell = collectionView.dequeueReusableCell(indexPath: indexPath)
        if let currency = presenter?.getCurrency(at: indexPath.row) {
            cell.config(from: currency)
        }
        return cell
    }
}

// MARK: - PaymentViewController + UICollectionViewDelegate

extension PaymentViewController: UICollectionViewDelegateFlowLayout {
    private func changeStateOfCell(_ collectionView: UICollectionView, atIndexPath indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? PaymentCollectionViewCell
        else { return }
        cell.changeBorder()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) { 
        changeStateOfCell(collectionView, atIndexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        changeStateOfCell(collectionView, atIndexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let horizontalSpacing = presenter?.spacing,
              let height = presenter?.heightOfCell
        else { return .zero }
        
        let width = (collectionView.frame.width - horizontalSpacing) / 2
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        presenter?.spacing ?? 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        presenter?.spacing ?? 0.0
    }
}
