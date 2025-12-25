import Foundation

final class CatalogPresenter: CatalogPresenterProtocol {

    // MARK: - Properties

    weak var view: CatalogViewProtocol?

    // MARK: - Lifecycle

    init(view: CatalogViewProtocol? = nil) {
        self.view = view
    }

    // MARK: - CatalogPresenterProtocol

    func viewDidLoad() {
        view?.showLoading()
        view?.hideLoading()
    }
}
