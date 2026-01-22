import Foundation

protocol NftCollectionViewProtocol: AnyObject {
    
    /// Показать индикатор загрузки
    func showLoading()
    
    /// Скрыть индикатор загрузки
    func hideLoading()
    
    /// Обновить список NFT
    func reloadData()
    
    /// Показать ошибку загрузки
    func showError(_ error: Error)
}
