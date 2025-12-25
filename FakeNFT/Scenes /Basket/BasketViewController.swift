import UIKit

final class BasketViewController: UIViewController {
    
    // MARK: - Constants
    
    private enum Constants {
        static let heightOfCardView: CGFloat = 76.0
        static let heightOfCellInTable: CGFloat = 140.0
    }
    
    // MARK: - UI-elements
    
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
            let navigationController = UINavigationController(rootViewController: paymentController)
            navigationController.modalPresentationStyle = .fullScreen
            self?.present(navigationController, animated: true)
        }
    }()
    
    // MARK: - Private Properties
    
    // TODO: - will be removed later (моковые данные)
    private var products: [BasketProduct] = [
        BasketProduct(name: "Title0", rating: 4, price: 12.0, imageUrl: "https://avatars.mds.yandex.net/i?id=8218634f6414d86b4a8c4f24146f8d5d06643f87-16441608-images-thumbs&n=13"),
        BasketProduct(name: "Title1", rating: 1, price: 1.0, imageUrl: "https://avatars.mds.yandex.net/i?id=8218634f6414d86b4a8c4f24146f8d5d06643f87-16441608-images-thumbs&n=13"),
        BasketProduct(name: "Title2", rating: 2, price: 2.0, imageUrl: "https://avatars.mds.yandex.net/i?id=8218634f6414d86b4a8c4f24146f8d5d06643f87-16441608-images-thumbs&n=13"),
        BasketProduct(name: "Title3", rating: 3, price: 121.0, imageUrl: "https://avatars.mds.yandex.net/i?id=8218634f6414d86b4a8c4f24146f8d5d06643f87-16441608-images-thumbs&n=13"),
        BasketProduct(name: "Title4", rating: 4, price: 21.0, imageUrl: "https://avatars.mds.yandex.net/i?id=8218634f6414d86b4a8c4f24146f8d5d06643f87-16441608-images-thumbs&n=13"),
        BasketProduct(name: "Title5", rating: 5, price: 22.0, imageUrl: "https://avatars.mds.yandex.net/i?id=8218634f6414d86b4a8c4f24146f8d5d06643f87-16441608-images-thumbs&n=13"),
        BasketProduct(name: "Title6", rating: 6, price: 11.0, imageUrl: "https://avatars.mds.yandex.net/i?id=8218634f6414d86b4a8c4f24146f8d5d06643f87-16441608-images-thumbs&n=13"),
    ]
    
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
