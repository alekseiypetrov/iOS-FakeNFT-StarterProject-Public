import Foundation

protocol CatalogPresenterProtocol: AnyObject {
    var itemsAmount: Int { get }
    func viewDidLoad()
    func collection(at index: Int) -> NFTCollection
    func didSelectSort(_ option: SortOption)
    
    func loadPreviewImages(
        for collectionIndex: Int,
        completion: @escaping ([URL?]) -> Void
    )
}
