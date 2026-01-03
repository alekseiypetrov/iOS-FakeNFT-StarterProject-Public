import UIKit

final class CatalogAssembly {

    private let servicesAssembly: ServicesAssembly

    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
    }

    func build() -> UIViewController {
        let presenter = CatalogPresenter(
            catalogService: servicesAssembly.catalogService
        )

        let viewController = CatalogViewController(
            presenter: presenter,
            servicesAssembly: servicesAssembly
        )

        presenter.view = viewController
        return viewController
    }
}
