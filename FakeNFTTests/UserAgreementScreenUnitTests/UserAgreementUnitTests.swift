@testable import FakeNFT
import XCTest

final class UserAgreementUnitTests: XCTestCase {
    
    // MARK: - Private Properties
    
    private let testValueOfHalfLoading: CGFloat = 0.5
    private let testValueOfCompletingLoading: CGFloat = 1.0
    
    // MARK: - Testing Functions For UserAgreementPresenterProtocol
    
    func testLifecycleFunctions() {
        let presenter = UserAgreementPresenterStub()
        let viewController = UserAgreementWebView()
        viewController.configure(presenter)
        
        viewController.viewWillAppear(false)
        viewController.viewDidDisappear(false)
        
        XCTAssertTrue(presenter.viewWillAppearCalled)
        XCTAssertTrue(presenter.viewDidDisappearCalled)
    }
    
    // MARK: - Testing Functions For UserAgreementWebViewProtocol
    
    func testStartingLoading() {
        let viewController = UserAgreementWebViewStub()
        let presenter = UserAgreementPresenter(viewController)
        
        presenter.viewWillAppear()
        
        XCTAssertTrue(viewController.wasNoMistake)
        XCTAssertTrue(viewController.pageStartedToLoad)
    }
    
    func testStoppingLoading() {
        let viewController = UserAgreementWebViewStub()
        let presenter = UserAgreementPresenter(viewController)
        
        presenter.viewDidDisappear()
        
        XCTAssertTrue(viewController.pageStoppedToLoad)
    }
    
    func testPageIsStillLoading() {
        let viewController = UserAgreementWebViewStub()
        let presenter = UserAgreementPresenter(viewController)
        
        presenter.updateProgress(toValue: testValueOfHalfLoading)
        
        XCTAssertFalse(viewController.progressHidden)
    }
    
    func testPageWasFullyLoaded() {
        let viewController = UserAgreementWebViewStub()
        let presenter = UserAgreementPresenter(viewController)
        
        presenter.updateProgress(toValue: testValueOfCompletingLoading)
        
        XCTAssertTrue(viewController.progressHidden)
    }
    
    // MARK: - Testing Functions For Both Protocols
    
    func testUpdatingProgress() {
        let presenter = UserAgreementPresenterStub()
        let viewController = UserAgreementWebViewStub()
        presenter.viewController = viewController
        viewController.configure(presenter)
        
        presenter.updateProgress(toValue: testValueOfHalfLoading)
        
        XCTAssertNotNil(viewController.newProgressValue)
        XCTAssertEqual(testValueOfHalfLoading, viewController.newProgressValue)
    }
    
}
