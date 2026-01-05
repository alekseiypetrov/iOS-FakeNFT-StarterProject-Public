import UIKit

final class CatalogViewController: UIViewController {
    
    private let presenter: CatalogPresenterProtocol
    private let servicesAssembly: ServicesAssembly
    
    // MARK: - UI
    
    private let tableView = UITableView()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    // MARK: - Init
    
    init(
        presenter: CatalogPresenterProtocol,
        servicesAssembly: ServicesAssembly
    ) {
        self.presenter = presenter
        self.servicesAssembly = servicesAssembly
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        setupActivityIndicator()
        presenter.viewDidLoad()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Каталог"
    }
    
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        tableView.register(
            CatalogTableViewCell.self,
            forCellReuseIdentifier: CatalogTableViewCell.reuseIdentifier
        )
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func setupActivityIndicator() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        activityIndicator.hidesWhenStopped = true
    }
    
    // MARK: - Navigation
    
    private func openCollection(id: String) {
        let collectionVC = NftCollectionAssembly(
            servicesAssembly: servicesAssembly,
            collectionId: id
        ).build()
        
        navigationController?.pushViewController(collectionVC, animated: true)
    }
}


extension CatalogViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = presenter.itemsAmount
        print("📊 [CatalogViewController/numberOfRows]: \(count)")
        return count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CatalogTableViewCell.reuseIdentifier,
            for: indexPath
        ) as? CatalogTableViewCell else {
            return UITableViewCell()
        }
        
        let collection = presenter.collection(at: indexPath.row)
        
        cell.configure(
            title: collection.name,
            countText: "\(collection.nfts.count) NFT"
        )
        
        return cell
    }
}

extension CatalogViewController: CatalogViewProtocol {
    
    func showLoading() {
        activityIndicator.startAnimating()
    }
    
    func hideLoading() {
        activityIndicator.stopAnimating()
    }
    
    func reloadData() {
        print("🔄 [CatalogViewController/reloadData]")
        tableView.reloadData()
    }
}

extension CatalogViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let collection = presenter.collection(at: indexPath.row)
        openCollection(id: collection.id)
    }
}
