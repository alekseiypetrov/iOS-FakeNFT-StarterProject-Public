import UIKit

final class NftCollectionViewController: UIViewController {

    // MARK: - Dependencies

    private let presenter: NftCollectionPresenterProtocol
    private let headerView = NftCollectionHeaderView()

    // MARK: - UI

    private let activityIndicator = UIActivityIndicatorView(style: .large)

    // MARK: - Init

    init(presenter: NftCollectionPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter.viewDidLoad()
    }

    // MARK: - Setup

    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerView)

        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])

        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}


extension NftCollectionViewController: NftCollectionViewProtocol {

    func showLoading() {
        activityIndicator.startAnimating()
    }

    func hideLoading() {
        activityIndicator.stopAnimating()
    }

    func reloadData() {
        // Пока без UI — позже здесь будет UICollectionView
        print("NftCollectionViewController: reloadData")
    }

    func showError(_ error: Error) {
        print("NftCollectionViewController error:", error)
    }
}
