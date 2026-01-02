import Foundation

protocol NftCollectionPresenterProtocol {
    
    func viewDidLoad()
    
    /// Количество NFT в коллекции
    func numberOfItems() -> Int
    
    /// NFT по индексу для отображения в ячейке
    func nft(at index: Int) -> Nft
}
