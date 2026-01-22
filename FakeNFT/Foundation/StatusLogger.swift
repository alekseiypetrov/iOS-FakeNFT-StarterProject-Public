import Logging

final class StatusLogger {
    
    // MARK: - Static Properties
    
    static let shared = StatusLogger()
    
    // MARK: - Private Properties
    
    private let logger: Logger
    
    // MARK: - Initilizers
    
    private init() { 
        logger = Logger(label: "com.practicum.FakeNFT")
    }
    
    // MARK: - Public Methods
    
    func sendCommonMessage(withText text: String) {
        logger.info(Logger.Message(stringLiteral: text))
    }
    
    func sendWarningMessage(withText text: String) {
        logger.warning(Logger.Message(stringLiteral: text))
    }
    
    func sendErrorMessage(withText text: String, andError error: Error) {
        logger.error(
            Logger.Message(stringLiteral: text),
            metadata: ["error": "\(error)"]
        )
    }
}
