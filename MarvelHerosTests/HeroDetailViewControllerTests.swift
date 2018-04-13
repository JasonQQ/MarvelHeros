@testable import MarvelHeros
import XCTest

class HeroDetailViewControllerTests: XCTestCase {
    
    var heroDetailViewController = HeroDetailViewController()
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testShowTableView() {
        XCTAssertEqual(tableView?.numberOfSections, 4)
    }
    
}

extension HeroDetailViewControllerTests {
    
    var tableView: UITableView? {
        return heroDetailViewController.view.viewWithAccessibilityIdentifier("heroDetailTableView", classType: UITableView.self)
    }
    
}
