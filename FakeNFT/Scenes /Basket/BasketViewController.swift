import UIKit

protocol ProductTableViewCellDelegate: AnyObject {
    func deleteButtonPushedInCell(withTitle name: String)
}

protocol BasketViewControllerProtocol: AnyObject {
    func updateInfoInPaymentCard(newCount: Int, newCost: Double)
    func updateCellsFromTable()
    func deleteCellFromTable(at index: Int)
    func showTable()
    func hideTable()
}

final class BasketViewController: UIViewController {
    
    // MARK: - Constants
    
    private enum Constants {
        static let heightOfCardView: CGFloat = 76.0
        static let heightOfCellInTable: CGFloat = 140.0
        static let parameters = ["price", "rating", "name"]
    }
    
    // MARK: - UI-elements
    
    private lazy var emptyBasketLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = NSLocalizedString("Basket.emptyBasketTitle", comment: "")
        label.font = .bodyBold
        return label
    }()
    
    private lazy var sortingButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            image: UIImage(resource: .nbSort),
            style: .plain,
            target: self,
            action: #selector(sortingButtonPressed)
        )
        button.tintColor = UIColor(resource: .ypBlack)
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.rowHeight = Constants.heightOfCellInTable
        tableView.backgroundColor = UIColor(resource: .ypWhite)
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.isScrollEnabled = true
        tableView.dataSource = self
        tableView.register(ProductTableViewCell.self)
        return tableView
    }()
    
    private lazy var paymentCard: PaymentCardView = {
        PaymentCardView { [weak self] in
            let paymentController = PaymentViewController()
            let paymentPresenter = PaymentPresenter(viewController: paymentController)
            paymentController.configure(paymentPresenter)
            let navigationController = UINavigationController(rootViewController: paymentController)
            navigationController.modalPresentationStyle = .fullScreen
            self?.present(navigationController, animated: true)
        }
    }()
    
    private lazy var blurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .systemMaterial)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return blurView
    }()
    
    private lazy var confirmingDeletionView: ConfirmingDeletionView = {
        ConfirmingDeletionView { [weak self] isDelete in
            if isDelete {
                self?.presenter?.deleteProduct()
            }
            self?.hideBlur()
        }
    }()
    
    // MARK: - Private Properties
    
    private var presenter: BasketPresenterProtocol?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("[viewController/viewWillAppear]: viewWillAppear")
        presenter?.viewWillAppear()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("[viewController/viewDidDisappear]: viewDidDisappear")
        UIProgressHUD.dismiss()
        presenter?.viewDidDisappear()
    }
    
    // MARK: - Actions
    
    @objc
    private func sortingButtonPressed() {
        let alert = UIAlertController(
            title: NSLocalizedString("Basket.alertController.title", comment: ""),
            message: nil,
            preferredStyle: .actionSheet
        )
        let parameterTitles = [
            NSLocalizedString("Basket.alertController.sortByPrice", comment: ""),
            NSLocalizedString("Basket.alertController.sortByRating", comment: ""),
            NSLocalizedString("Basket.alertController.sortByName", comment: ""),
        ]
        for (index, title) in parameterTitles.enumerated() {
            alert.addAction(
                UIAlertAction(
                    title: title,
                    style: .default,
                    handler: { [weak self] _ in
                        UIProgressHUD.show()
                        self?.presenter?.sortParameterChanged(to: Constants.parameters[index])
                    }
                )
            )
        }
        alert.addAction(
            UIAlertAction(
                title: NSLocalizedString("Basket.alertController.close", comment: ""),
                style: .cancel
            )
        )
        present(alert, animated: true)
    }
    
    // MARK: - Public Methods
    
    func configure(_ presenter: BasketPresenterProtocol) {
        self.presenter = presenter
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        view.backgroundColor = UIColor(resource: .ypWhite)
        navigationItem.rightBarButtonItem = sortingButton
        
        [emptyBasketLabel, tableView, paymentCard]
            .forEach({
                view.addSubview($0)
                $0.translatesAutoresizingMaskIntoConstraints = false
            })
        emptyBasketLabel.constraintCenters(to: view)
        NSLayoutConstraint.activate([
            
            // tableView Constraints
            
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: paymentCard.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            // paymentCard Constraints
            
            paymentCard.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            paymentCard.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            paymentCard.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            paymentCard.heightAnchor.constraint(equalToConstant: Constants.heightOfCardView)
        ])
    }
}

// MARK: - BasketViewController + BasketViewControllerProtocol

extension BasketViewController: BasketViewControllerProtocol {
    func updateInfoInPaymentCard(newCount: Int, newCost: Double) {
        paymentCard.updateAmountNfts(newCount)
        paymentCard.updateTotalCost(newCost)
    }
    
    func updateCellsFromTable() {
        UIProgressHUD.dismiss()
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    func deleteCellFromTable(at index: Int) {
        tableView.performBatchUpdates({
            let indexPath = IndexPath(row: index, section: 0)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }, completion: { [weak self] _ in
            self?.presenter?.countNewInfoForPaymentCard()
        })
    }
    
    func showTable() {
        emptyBasketLabel.isHidden = true
        UIProgressHUD.show()
        [tableView, paymentCard]
            .forEach({
                $0.isHidden = false
            })
        sortingButton.isHidden = false
    }
    
    func hideTable() {
        [tableView, paymentCard]
            .forEach({
                $0.isHidden = true
            })
        sortingButton.isHidden = true
        emptyBasketLabel.isHidden = false
    }
}

// MARK: - BasketViewController + UITabelViewDataSource

extension BasketViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.getCountOfProducts() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ProductTableViewCell = tableView.dequeueReusableCell()
        guard let currentProduct = presenter?.getCurrentProduct(at: indexPath.row)
        else { return cell }
        cell.configure(by: currentProduct, withDelegate: self)
        return cell
    }
}

// MARK: - BasketViewController + ProductTableViewCellDelegate

extension BasketViewController: ProductTableViewCellDelegate {
    func deleteButtonPushedInCell(withTitle name: String) {
        guard let product = presenter?.findProduct(withName: name),
              let imageUrl = product.images.first
        else { return }
        showBlur()
        showConfirmingDeletionView(withImageUrl: imageUrl)
    }
    
    private func showBlur() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first(where: { $0.isKeyWindow })
        else { return }
        blurView.frame = window.bounds
        blurView.alpha = 0
        window.addSubview(blurView)
        UIView.animate(withDuration: 0.3) {
            self.blurView.alpha = 1
        }
    }
    
    private func hideBlur() {
        UIView.animate(withDuration: 0.3, animations: {
            self.blurView.alpha = 0
        }, completion: { _ in
            self.blurView.removeFromSuperview()
        })
    }
    
    private func showConfirmingDeletionView(withImageUrl imageUrl: String) {
        confirmingDeletionView.imageOfNft = imageUrl
        confirmingDeletionView.removeFromSuperview()
        confirmingDeletionView.isUserInteractionEnabled = true
        blurView.contentView.addSubview(confirmingDeletionView)
        NSLayoutConstraint.activate([
            confirmingDeletionView.centerXAnchor.constraint(equalTo: blurView.contentView.centerXAnchor),
            confirmingDeletionView.centerYAnchor.constraint(equalTo: blurView.contentView.centerYAnchor),
            confirmingDeletionView.widthAnchor.constraint(equalToConstant: view.bounds.width),
            confirmingDeletionView.heightAnchor.constraint(equalToConstant: view.bounds.width)
        ])
        confirmingDeletionView.setNeedsLayout()
        confirmingDeletionView.layoutIfNeeded()
    }
}
