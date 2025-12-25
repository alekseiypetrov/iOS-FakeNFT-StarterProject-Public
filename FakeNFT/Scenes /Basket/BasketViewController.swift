import UIKit

final class BasketViewController: UIViewController {
    
    // MARK: - Constants
    
    private enum Constants {
        static let sortingButtonImage = UIImage(resource: .nbSort)
        static let heightOfCardView: CGFloat = 76.0
        static let heightOfCellInTable: CGFloat = 140.0
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
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.rowHeight = Constants.heightOfCellInTable
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
            let navigationController = UINavigationController(rootViewController: paymentController)
            navigationController.modalPresentationStyle = .fullScreen
            self?.present(navigationController, animated: true)
        }
    }()
    
    // MARK: - Private Properties
    
    private var products: [BasketProduct] = []
    
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
        
        [tableView, paymentCard]
            .forEach({
                view.addSubview($0)
                $0.translatesAutoresizingMaskIntoConstraints = false
            })
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

// MARK: - BasketViewController + UITabelViewDataSource

extension BasketViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ProductTableViewCell = tableView.dequeueReusableCell()
        cell.configure(by: products[indexPath.row])
        return cell
    }
}
