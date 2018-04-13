import XCTest

class MarvelHerosUITests: XCTestCase {
    
    var app = XCUIApplication()
        
    override func setUp() {
        super.setUp()

        continueAfterFailure = false
        app.launch()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testHeroListViewController() {
        XCTAssertTrue(app.isDisplayingHeroListViewController)
    }
    
    func testHeroDetailViewController() {
        XCTAssertTrue(app.isDisplayingHeroListViewController)
        
        app.cells.firstMatch.tap()
        XCTAssertTrue(app.isDisplayingHeroDetailViewController)
    }
    
}

extension XCUIApplication {
    var isDisplayingHeroListViewController: Bool {
        return otherElements["heroListViewController"].exists
    }
    
    var isDisplayingHeroDetailViewController: Bool {
        return otherElements["heroDetailViewController"].exists
    }
}
