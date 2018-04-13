@testable import MarvelHeros
import XCTest

class HeroListViewControllerTests: XCTestCase {
    
    var heroListViewController = HeroListViewController()
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testShowCollectionView() {
        let testHero = Character()
        heroListViewController.addHeros([testHero])
        XCTAssertEqual(collectionView?.numberOfSections, 1)
        XCTAssertEqual(collectionView?.numberOfItems(inSection: 0), 1)
    }
    
    func testHasSearchBar() {
        collectionView?.setNeedsLayout()
        collectionView?.layoutIfNeeded()
        XCTAssertNotNil(asearchBar)
    }
    
    func testHasRefreshIndicatorView() {
        collectionView?.setNeedsLayout()
        collectionView?.layoutIfNeeded()
        XCTAssertNotNil(refreshIndicatorView)
    }
    
    func testConformsToSearchBarDelegateProtocol() {
        XCTAssert(heroListViewController.conforms(to: UISearchBarDelegate.self))
        XCTAssertTrue(heroListViewController.responds(to: #selector(heroListViewController.searchBarSearchButtonClicked(_:))))
    }
    
}

extension HeroListViewControllerTests {
    
    var collectionView: UICollectionView? {
        return heroListViewController.view.viewWithAccessibilityIdentifier("herosListCollectionView", classType: UICollectionView.self)
    }
    
    var asearchBar: UISearchBar? {
        return heroListViewController.view.viewWithAccessibilityIdentifier("heroSearchBar", classType: UISearchBar.self)
    }
    
    var refreshIndicatorView: UIActivityIndicatorView? {
        return heroListViewController.view.viewWithAccessibilityIdentifier("refreshIndicatorView", classType: UIActivityIndicatorView.self)
    }
    
    func cell(atIndex index: Int) -> HeroListCell? {
        return collectionView?.cellForItem(at: IndexPath(item: index, section: 0)) as? HeroListCell
    }
    
}
