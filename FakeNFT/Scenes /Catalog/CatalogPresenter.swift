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

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.view?.hideLoading()
        }
    }
}
