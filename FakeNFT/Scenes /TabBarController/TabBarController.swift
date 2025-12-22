import UIKit

final class TabBarController: UITabBarController {

    var servicesAssembly: ServicesAssembly!

    private let catalogTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.catalog", comment: ""),
        image: UIImage(resource: .tbCatalogNoActive),
        tag: 0
    )
    private let basketTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.basket", comment: ""),
        image: UIImage(resource: .tbBasketNoActive),
        tag: 1
    )

    override func viewDidLoad() {
        super.viewDidLoad()

        let catalogController = TestCatalogViewController(
            servicesAssembly: servicesAssembly
        )
        catalogController.tabBarItem = catalogTabBarItem
        
        let basketController = BasketViewController()
        let navigationBasketController = UINavigationController(rootViewController: basketController)
        basketController.tabBarItem = basketTabBarItem

        tabBar.unselectedItemTintColor = UIColor(resource: .ypBlack)
        viewControllers = [catalogController, navigationBasketController]

        view.backgroundColor = UIColor(resource: .ypWhite)
    }
}
