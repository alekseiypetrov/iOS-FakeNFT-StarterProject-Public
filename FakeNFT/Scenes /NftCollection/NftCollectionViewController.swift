import UIKit

final class NftCollectionViewController: UIViewController {
    
    // MARK: - Dependencies
    
    private let presenter: NftCollectionPresenterProtocol
    
    // MARK: - UI
    
    private let headerView = NftCollectionHeaderView()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 12
        
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    // MARK: - Init
    
    init(presenter: NftCollectionPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCollectionView()
        presenter.viewDidLoad()
    }
    
    // MARK: - TabBar visibility

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerView)
        
        view.addSubview(collectionView)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            // Header
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            // CollectionView
            collectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Loader
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(NftCollectionCell.self)
    }
}

// MARK: - NftCollectionViewProtocol

extension NftCollectionViewController: NftCollectionViewProtocol {
    
    func showLoading() {
        activityIndicator.startAnimating()
    }
    
    func hideLoading() {
        activityIndicator.stopAnimating()
    }
    
    func reloadData() {
        let headerViewModel = presenter.headerViewModel()
        headerView.configure(with: headerViewModel)

        headerView.onAuthorTap = { [weak self] in
            guard
                let self,
                let url = self.presenter.collectionAuthorWebsite()
            else { return }

            let vc = WebViewViewController(url: url)
            self.navigationController?.pushViewController(vc, animated: true)
        }

        collectionView.reloadData()
    }
    
    func showError(_ error: Error) {
        print("[NftCollectionViewController/showError]: \(error)")
    }
}

// MARK: - UICollectionViewDataSource

extension NftCollectionViewController: UICollectionViewDataSource {
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        presenter.numberOfItems()
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        
        let cell: NftCollectionCell = collectionView.dequeueReusableCell(indexPath: indexPath)
        
        let index = indexPath.item
        let model = presenter.cellModel(at: index)
        
        cell.configure(
            with: model,
            onFavoriteTap: { [weak self] in
                guard let self else { return }
                self.presenter.didTapFavorite(at: index)
                self.collectionView.reloadItems(at: [indexPath])
            },
            onCartTap: { [weak self] in
                guard let self else { return }
                self.presenter.didTapCart(at: index)
                self.collectionView.reloadItems(at: [indexPath])
            }
        )
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension NftCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {

        let itemsPerRow: CGFloat = 3
        let interItemSpacing: CGFloat = 12
        let sectionInset: CGFloat = 16

        let totalSpacing =
            sectionInset * 2 +
            interItemSpacing * (itemsPerRow - 1)

        let availableWidth =
            collectionView.bounds.width - totalSpacing

        let itemWidth = floor(availableWidth / itemsPerRow)

        return CGSize(
            width: itemWidth,
            height: 192
        )
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        UIEdgeInsets(
            top: 0,
            left: 16,
            bottom: 16,
            right: 16
        )
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        12
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        12
    }
}
