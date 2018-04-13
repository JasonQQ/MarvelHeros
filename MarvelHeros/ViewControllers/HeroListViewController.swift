import UIKit

class HeroListViewController: UIViewController, UINavigationControllerDelegate {
    
    private struct Constants {
        static let limitPerPage: Int = 20
        static let heroListCellPadding: CGFloat = 9
        static let heroListCellHeight: CGFloat = 150
        static let numberOfColumns: CGFloat = 3
        static let numberOfPaddings: CGFloat = 5
        static let heroListCellReuseId = "HeroListCellIdentifier"
        static let heroListCollectionHeaderIdentifier = "headerReuseIdentifier"
        static let heroListCollectionFooterIdentifier = "footerReuseIdentifier"
    }
    
    private var customConstraints = [NSLayoutConstraint]()
    private var heros = [Character]()
    private var isLoading: Bool = false
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionHeadersPinToVisibleBounds = true
        if #available(iOS 11.0, *) {
            layout.sectionInsetReference = .fromSafeArea
        }
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.accessibilityIdentifier = "herosListCollectionView"
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.scrollsToTop = true
        collectionView.alwaysBounceVertical = true
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: Constants.heroListCellPadding, right: 0)
        collectionView.register(HeroListCell.self, forCellWithReuseIdentifier: Constants.heroListCellReuseId)
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: Constants.heroListCollectionHeaderIdentifier)
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: Constants.heroListCollectionFooterIdentifier)
        return collectionView
    }()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.accessibilityIdentifier = "heroSearchBar"
        searchBar.autoresizingMask = .flexibleWidth
        searchBar.showsScopeBar = true
        searchBar.scopeButtonTitles = ["Marvel Heros"]
        searchBar.delegate = self
        searchBar.placeholder = NSLocalizedString("Heros name starts with...", comment: "placeholder of search bar")
        return searchBar
    }()
    
    private lazy var refreshIndicatorView: UIActivityIndicatorView = {
        let refreshIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        refreshIndicatorView.accessibilityIdentifier = "refreshIndicatorView"
        refreshIndicatorView.color = UIColor.orange
        refreshIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        return refreshIndicatorView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = NSLocalizedString("Heros", comment: "title of page")
        view.accessibilityIdentifier = "heroListViewController"
        view.addSubview(collectionView)
        navigationController?.delegate = self
        
        performFetch()
        addConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    func addHeros(_ heros: [Character]) {
        self.heros += heros
    }
    
    // MARK: - Private Methods
    
    private func configureCell(_ cell: UICollectionViewCell, atIndexPath indexPath: IndexPath) {
        guard let cell = cell as? HeroListCell else { return }
        let hero = heros[indexPath.row]
        cell.configureCell(hero)
    }
    
    private func addConstraints() {
        let views: [String: Any] = [
            "collectionView": collectionView
            ]
        
        customConstraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "H:|[collectionView]|", metrics: nil, views: views))
        customConstraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "V:|[collectionView]|", metrics: nil, views: views))
        
        NSLayoutConstraint.activate(customConstraints)
    }
    
    private func performFetch(_ offset: Int? = nil) {
        fetchHeros(Constants.limitPerPage, offset: offset, nameQuery: nil)
    }
    
    private func performSearch(_ searchString: String?) {
        guard let searchString = searchString else { return }
        let nameQuery = searchString.count > 0 ? searchString : nil
        heros.removeAll()
        fetchHeros(Constants.limitPerPage, offset: nil, nameQuery: nameQuery)
    }
    
    private func fetchHeros(_ limit: Int? = nil, offset: Int? = nil, nameQuery: String? = nil) {
        let httpClient = HTTPAPIClient(publicKey: Marvel.publicKey, privateKey: Marvel.privateKey)
        
        let charactersClient = CharactersClient(httpClient: httpClient)
        charactersClient.getCharacters(CharactersRequest(name: nil, nameStartsWith: nameQuery, limit: limit, offset: offset)) { response in
            print("\nGet characters finished:")
            
            switch response {
            case .success(let dataContainer):
                for character in dataContainer.results {
                    print("  Title: \(character.name ?? "Unnamed character")")
                    print("  Thumbnail: \(character.thumbnail?.url.absoluteString ?? "None")")
                }
                self.addHeros(dataContainer.results)
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
}

extension HeroListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return heros.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.heroListCellReuseId, for: indexPath)
        configureCell(cell, atIndexPath: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionFooter {
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Constants.heroListCollectionFooterIdentifier, for: indexPath)
            footerView.addSubview(refreshIndicatorView)
            footerView.addConstraint(refreshIndicatorView.centerXAnchor.constraint(equalTo: footerView.centerXAnchor))
            footerView.addConstraint(refreshIndicatorView.centerYAnchor.constraint(equalTo: footerView.centerYAnchor))
            return footerView
        } else {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Constants.heroListCollectionHeaderIdentifier, for: indexPath)
            headerView.addSubview(searchBar)
            return headerView
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width, height: searchBar.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if isLoading {
            return CGSize.zero
        }
        return CGSize(width: collectionView.bounds.size.width, height: refreshIndicatorView.frame.height)
    }
}

extension HeroListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let hero = heros[indexPath.row]
        let detailViewController = HeroDetailViewController()
        detailViewController.hero = hero
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

extension HeroListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let targetWidth = (view.safeLayoutFrame.size.width - Constants.heroListCellPadding * Constants.numberOfPaddings) / Constants.numberOfColumns
        return CGSize(width: targetWidth, height: Constants.heroListCellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: Constants.heroListCellPadding, left: Constants.heroListCellPadding, bottom: 0, right: Constants.heroListCellPadding)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.heroListCellPadding
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.heroListCellPadding
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if shouldRefreshAsScrollBottom(scrollView) {
            self.isLoading = true
            refreshIndicatorView.startAnimating()
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) {_ in
                self.performFetch(self.heros.count)
                self.collectionView.reloadData()
                self.isLoading = false
                self.refreshIndicatorView.stopAnimating()
            }
        }
    }
    
    private func shouldRefreshAsScrollBottom(_ scrollView: UIScrollView) -> Bool {
        let contentOffset = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let diffHeight = contentHeight - contentOffset
        let frameHeight = scrollView.safeLayoutFrame.size.height
        let pullHeight = fabs(diffHeight - frameHeight)
        print("pullHeight:\(pullHeight)")
        
        return pullHeight == 9.0
    }
    
}

extension HeroListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        performSearch(searchBar.text)
    }
    
}
