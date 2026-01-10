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
    }
    
    // MARK: - Testing UI in Epic-Basket
    
    func testDeletingProductFromBasket() {
        let tablesQuery = app.tables
        
        app.tabBars.buttons.element(boundBy: 1).tap()
        
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        XCTAssertTrue(cell.waitForExistence(timeout: 15))
        
        let cellToDelete = tablesQuery.children(matching: .cell).element(boundBy: 1)
        let deleteButton = cellToDelete.descendants(matching: .any)
            .matching(NSPredicate(format: "label == 'delete'"))
            .firstMatch
        deleteButton.tap()
        
        let confirmingDeleteButton = app.buttons["confirmingDeleteButton"]
        XCTAssertTrue(confirmingDeleteButton.waitForExistence(timeout: 5))
        confirmingDeleteButton.tap()
        sleep(5)
    }
    
    func testPaymentProcess() { 
        app.tabBars.buttons.element(boundBy: 1).tap()
        
        let buttonInBasket = app.buttons["navigateToPay"]
        XCTAssertTrue(buttonInBasket.waitForExistence(timeout: 15))
        buttonInBasket.tap()
        
        let collectionsQuery = app.collectionViews
        let cell = collectionsQuery.children(matching: .cell).element(boundBy: 0)
        XCTAssertTrue(cell.waitForExistence(timeout: 10))
        cell.tap()
        
        app.buttons["confirmAndExecutePayment"].tap()
        
        let image = app.images["imageOfSuccessfulPayment"]
        let label = app.staticTexts["titleOfSuccessfulPayment"]
        XCTAssertTrue(image.waitForExistence(timeout: 5))
        XCTAssertTrue(label.waitForExistence(timeout: 5))
        
        app.buttons["backToBasketButton"].tap()
        
        let emptyBasketLabel = app.staticTexts["titleOfEmptyBasket"]
        XCTAssertTrue(emptyBasketLabel.waitForExistence(timeout: 10))
    }
}
