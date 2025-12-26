import Foundation

protocol CatalogPresenterProtocol: AnyObject {
    func viewDidLoad()
    func numberOfItems() -> Int
    func collection(at index: Int) -> Collection
}
