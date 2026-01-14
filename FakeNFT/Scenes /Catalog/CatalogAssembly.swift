import UIKit

final class CatalogAssembly {

    private let servicesAssembly: ServicesAssembly

    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
    }

    func build() -> UIViewController {
        let presenter = CatalogPresenter(
            catalogService: servicesAssembly.catalogService,
            nftService: servicesAssembly.nftService
        )

        let viewController = CatalogViewController(
            presenter: presenter,
            servicesAssembly: servicesAssembly
        )

        presenter.configure(viewController)
        return viewController
    }
}
