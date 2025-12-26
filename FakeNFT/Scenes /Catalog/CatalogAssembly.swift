import UIKit

final class CatalogAssembly {

    private let servicesAssembly: ServicesAssembly

    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
    }

    func build() -> UIViewController {
        let catalogService = servicesAssembly.catalogService
        let presenter = CatalogPresenter(catalogService: catalogService)
        let viewController = TestCatalogViewController(presenter: presenter)

        presenter.view = viewController
        return viewController
    }
}
