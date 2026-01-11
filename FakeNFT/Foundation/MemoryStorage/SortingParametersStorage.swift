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

enum SortOption: String {
    case byPrice
    case byRating
    case byName
    case byNftsAmount
}
