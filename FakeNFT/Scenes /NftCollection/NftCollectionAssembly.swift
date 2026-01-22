import UIKit

final class NftCollectionAssembly {
    
    private let servicesAssembly: ServicesAssembly
    private let collectionId: String
    
    init(
        servicesAssembly: ServicesAssembly,
        collectionId: String
    ) {
        self.servicesAssembly = servicesAssembly
        self.collectionId = collectionId
    }
    
    func build() -> UIViewController {
        let presenter = NftCollectionPresenter(
            collectionId: collectionId,
            catalogService: servicesAssembly.catalogService,
            nftService: servicesAssembly.nftService,
            orderService: servicesAssembly.orderService
        )
        
        let viewController = NftCollectionViewController(presenter: presenter)
        presenter.view = viewController
        
        return viewController
    }
}
