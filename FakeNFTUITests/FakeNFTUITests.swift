import XCTest

final class FakeNFTUITests: XCTestCase {
    private let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }
    
    func testExample() throws {
        let app = XCUIApplication()
        app.launch()
        
        // TODO: - Не забудьте написать UI-тесты
    }
    
    // MARK: - Testing UI in Epic-Basket
    
    func testDeletingProductFromBasket() {
        let tablesQuery = app.tables
        
        app.tabBars.buttons.element(boundBy: 1).tap()
        sleep(10)
        
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
        
        let cellToDelete = tablesQuery.children(matching: .cell).element(boundBy: 1)
        let deleteButton = cellToDelete.descendants(matching: .any)
            .matching(NSPredicate(format: "label == 'delete'"))
            .firstMatch
        deleteButton.tap()
        sleep(2)
        
        app.buttons["confirmingDeleteButton"].tap()
        sleep(5)
    }
    
    func testPaymentProcess() { 
        app.tabBars.buttons.element(boundBy: 1).tap()
        sleep(10)
        
        app.buttons["navigateToPay"].tap()
        sleep(10)
        
        let collectionsQuery = app.collectionViews
        let cell = collectionsQuery.children(matching: .cell).element(boundBy: 0)
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
        cell.tap()
        
        app.buttons["confirmAndExecutePayment"].tap()
        sleep(5)
        
        let image = app.images["imageOfSuccessfulPayment"]
        let label = app.staticTexts["titleOfSuccessfulPayment"]
        XCTAssertTrue(image.exists)
        XCTAssertTrue(label.exists)
        
        app.buttons["backToBasketButton"].tap()
        sleep(10)
        
        let emptyBasketLabel = app.staticTexts["titleOfEmptyBasket"]
        XCTAssertTrue(emptyBasketLabel.exists)
    }
}
