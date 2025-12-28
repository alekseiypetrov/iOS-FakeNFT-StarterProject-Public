import Foundation

final class SortingParametersStorage {
    private static let standard = UserDefaults.standard
    private init() { }
    
    static let shared = SortingParametersStorage()
}
