import Foundation

protocol CatalogViewProtocol: AnyObject {
    func showLoading()
    func hideLoading()
    func reloadData()
}
