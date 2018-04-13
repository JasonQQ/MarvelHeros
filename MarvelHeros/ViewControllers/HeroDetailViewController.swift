import UIKit

class HeroDetailViewController: UIViewController {
    
    private struct Constants {
        static let detailViewCellReuseIdentifier = "detailViewCellReuseIdentifier"
        static let cellHeight: CGFloat = 120
        static let headerImageViewRatio: CGFloat = 2
        static let headerImageViewYOffset: CGFloat = -64
        static let heightForHeaderInSection: CGFloat = 20
        static let lineOfDescription = 4
    }
    let tableViewHeaders = ["Comics", "Events", "Stories", "Series"]

    var hero: Character?
    var comics = [Comic]()
    var events = [Event]()
    var stories = [Story]()
    var series = [Series]()
    private var customConstraints: [NSLayoutConstraint] = []
    
    private lazy var headerImageView: UIImageView = {
        let headerImageView = UIImageView(frame: CGRect(x: 0, y: Constants.headerImageViewYOffset, width: self.view.frame.width, height: self.view.frame.height / Constants.headerImageViewRatio))
        headerImageView.contentMode = .scaleAspectFill
        headerImageView.autoresizingMask = .flexibleWidth
        if let image = hero?.thumbnail?.url.cachedImage {
            headerImageView.image = image
        } else {
            hero?.thumbnail?.url.fetchImage { image in
                self.headerImageView.image = image
            }
        }
        return headerImageView
    }()
    
    private let favoriteImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "favorite")
        imageView.image = image
        imageView.alpha = 0
        return imageView
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.accessibilityIdentifier = "heroDetailTableView"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.white
        tableView.layoutMargins = .zero
        tableView.sectionFooterHeight = 0
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.detailViewCellReuseIdentifier)
        tableView.tableHeaderView = headerImageView
        tableView.estimatedRowHeight = Constants.cellHeight
        tableView.estimatedSectionHeaderHeight = Constants.heightForHeaderInSection
        return tableView
    }()
    
    func configureView() {
        view.accessibilityIdentifier = "heroDetailViewController"
        view.addSubview(tableView)
        view.addSubview(favoriteImageView)
        addConstraints()
        
        if let hero = hero {
            title = hero.name
            fetchComics(hero.id, limit: 3)
            fetchEvents(hero.id, limit: 3)
            fetchStories(hero.id, limit: 3)
            fetchSeries(hero.id, limit: 3)
        }
    }
    
    private func addConstraints() {
        guard customConstraints.isEmpty else { return }
        
        let views = [
            "tableView": tableView,
            "favoriteImageView": favoriteImageView
        ]
        
        customConstraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "H:|[tableView]|", options: [], metrics: nil, views: views))
        customConstraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "V:|[tableView]|", options: [], metrics: nil, views: views))
        
        NSLayoutConstraint.activate(customConstraints)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    // MARK: - Private Methods
    
    private func configureCell(_ cell: UITableViewCell, indexPath: IndexPath) {
        cell.contentView.backgroundColor = UIColor.white
        cell.detailTextLabel?.numberOfLines = Constants.lineOfDescription
        if indexPath.section == 0 && indexPath.row < comics.count {
            cell.textLabel?.text = comics[indexPath.row].title
            cell.detailTextLabel?.text = comics[indexPath.row].description
        }
        if indexPath.section == 1 && indexPath.row < events.count {
            cell.textLabel?.text = events[indexPath.row].title
            cell.detailTextLabel?.text = events[indexPath.row].description
        }
        if indexPath.section == 2 && indexPath.row < stories.count {
            cell.textLabel?.text = stories[indexPath.row].title
            cell.detailTextLabel?.text = stories[indexPath.row].description
        }
        if indexPath.section == 3 && indexPath.row < series.count {
            cell.textLabel?.text = series[indexPath.row].title
            cell.detailTextLabel?.text = series[indexPath.row].description
        }
    }
    
    private func fetchComics(_ characterId: Int, limit: Int? = nil) {
        let httpClient = HTTPAPIClient(publicKey: Marvel.publicKey, privateKey: Marvel.privateKey)
        
        let charactersClient = CharactersClient(httpClient: httpClient)
        charactersClient.getComics(CharacterComicsRequest(characterId: characterId, limit: 3)) { response in
            print("\nGet comics for character finished:")
            
            switch response {
            case .success(let dataContainer):
                for data in dataContainer.results {
                    print("  Title: \(data.title ?? "Unnamed comic")")
                    print("  description: \(data.description ?? "None")")
                }
                self.comics = dataContainer.results
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func fetchEvents(_ characterId: Int, limit: Int? = nil) {
        let httpClient = HTTPAPIClient(publicKey: Marvel.publicKey, privateKey: Marvel.privateKey)
        
        let charactersClient = CharactersClient(httpClient: httpClient)
        charactersClient.getEvents(CharacterEventsRequest(characterId: characterId, limit: 3)) { response in
            print("\nGet events for character finished:")
            
            switch response {
            case .success(let dataContainer):
                for data in dataContainer.results {
                    print("  Title: \(data.title ?? "Unnamed event")")
                    print("  description: \(data.description ?? "None")")
                }
                self.events = dataContainer.results
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func fetchStories(_ characterId: Int, limit: Int? = nil) {
        let httpClient = HTTPAPIClient(publicKey: Marvel.publicKey, privateKey: Marvel.privateKey)
        
        let charactersClient = CharactersClient(httpClient: httpClient)
        charactersClient.getStories(CharacterStoriesRequest(characterId: characterId, limit: 3)) { response in
            print("\nGet stories for character finished:")
            
            switch response {
            case .success(let dataContainer):
                for data in dataContainer.results {
                    print("  Title: \(data.title ?? "Unnamed story")")
                    print("  description: \(data.description ?? "None")")
                }
                self.stories = dataContainer.results
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func fetchSeries(_ characterId: Int, limit: Int? = nil) {
        let httpClient = HTTPAPIClient(publicKey: Marvel.publicKey, privateKey: Marvel.privateKey)
        
        let charactersClient = CharactersClient(httpClient: httpClient)
        charactersClient.getSeries(CharacterSeriesRequest(characterId: characterId, limit: 3)) { response in
            print("\nGet series for character finished:")
            
            switch response {
            case .success(let dataContainer):
                for data in dataContainer.results {
                    print("  Title: \(data.title ?? "Unnamed series")")
                    print("  description: \(data.description ?? "None")")
                }
                self.series = dataContainer.results
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }

}

extension HeroDetailViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewHeaders.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return comics.count
        } else if section == 1 {
            return events.count
        } else if section == 2 {
            return stories.count
        } else {
            return series.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: Constants.detailViewCellReuseIdentifier)
        
        configureCell(cell, indexPath: indexPath)
        return cell
    }
    
}

extension HeroDetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Constants.heightForHeaderInSection
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.cellHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: Constants.heightForHeaderInSection))
        view.backgroundColor = UIColor.lightGray
        let sectionHeaderLabel = UILabel(frame: view.frame)
        sectionHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
        sectionHeaderLabel.text = self.tableViewHeaders[section]
        sectionHeaderLabel.textColor = UIColor.black
        view.addSubview(sectionHeaderLabel)
        return view
    }
}
