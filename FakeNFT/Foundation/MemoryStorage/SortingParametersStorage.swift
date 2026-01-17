import Foundation

final class SortingParametersStorage {
    static let shared = SortingParametersStorage()
    private let standard = UserDefaults.standard
    
    private init() { }
    
    static func getParameter(fromKey key: String) -> String? {
        shared.standard.string(forKey: key)
    }
    
    static func save(parameter: String, forKey key: String) {
        shared.standard.setValue(parameter, forKey: key)
        shared.standard.synchronize()
    }
}

// MARK: - Sort keys
enum SortKeys {
    static let catalog = "catalog.sort.option"
    // static let basket = "basket.sort.option"
}

// MARK: - Sort options
enum SortOption: String {
    case byPrice
    case byRating
    case byName
    case byNftsAmount
}
