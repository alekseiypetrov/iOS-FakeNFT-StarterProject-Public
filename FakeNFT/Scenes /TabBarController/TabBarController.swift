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

        // Каталог
        let catalogAssembly = CatalogAssembly(servicesAssembly: servicesAssembly)
        let catalogVC = catalogAssembly.build()
        let catalogNav = UINavigationController(rootViewController: catalogVC)
        catalogNav.tabBarItem = catalogTabBarItem

        // Корзина
        let basketVC = BasketViewController()
        basketVC.tabBarItem = basketTabBarItem
        _ = BasketPresenter(viewController: basketVC)
        
        tabBar.unselectedItemTintColor = UIColor(resource: .ypBlack)
        viewControllers = [catalogNav, basketVC]
    }
}
