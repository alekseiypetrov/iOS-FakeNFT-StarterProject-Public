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
        setupSortButton()
        presenter.viewDidLoad()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        navigationItem.title = nil
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
        
        activityIndicator.constraintCenters(to: view)
        
        activityIndicator.hidesWhenStopped = true
    }
    
    //MARK: кнопка сортировки
    private func setupSortButton() {
        let image = UIImage(named: "Vector")?.withRenderingMode(.alwaysOriginal)
        
        let sortButton = UIBarButtonItem(
            image: image,
            style: .plain,
            target: self,
            action: #selector(didTapSort)
        )
        
        navigationItem.rightBarButtonItem = sortButton
    }
    
    // Обработчик нажатия
    @objc private func didTapSort() {
        let alert = UIAlertController(
            title: "Сортировка",
            message: nil,
            preferredStyle: .actionSheet
        )
        
        alert.addAction(
            UIAlertAction(title: "По названию", style: .default) { [weak self] _ in
                self?.presenter.didSelectSort(.byName)
            }
        )
        
        alert.addAction(
            UIAlertAction(title: "По количеству NFT", style: .default) { [weak self] _ in
                self?.presenter.didSelectSort(.byNftsAmount)
            }
        )
        
        alert.addAction(
            UIAlertAction(title: "Закрыть", style: .cancel)
        )
        
        present(alert, animated: true)
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
    
    // MARK: Обработка ошибок загрузки данных
    func showError(message: String) {
        let alert = UIAlertController(
            title: "Ошибка",
            message: message,
            preferredStyle: .alert
        )

        alert.addAction(
            UIAlertAction(title: "Повторить", style: .default) { [weak self] _ in
                self?.presenter.viewDidLoad()
            }
        )

        alert.addAction(
            UIAlertAction(title: "Закрыть", style: .cancel)
        )

        present(alert, animated: true)
    }
}

extension CatalogViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let collection = presenter.collection(at: indexPath.row)
        openCollection(id: collection.id)
    }
}
