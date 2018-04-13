import UIKit

class HeroListCell: UICollectionViewCell {
    
    private struct Constants {
        static let numberOfPages = 2
        static let padding: CGFloat = 10
        static let minBubbleSize: CGFloat = 18
    }
    
    private var customConstraints = [NSLayoutConstraint]()
    private var hasCellBeenLoaded: Bool = false
    
    private let titleLabel: UILabel = {
        let titleLabel = UILabel(frame: .zero)
        titleLabel.accessibilityIdentifier = "cellTitleLabel"
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 2
        return titleLabel
    }()
    
    private var imageView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let favoriteImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "favorite")
        imageView.image = image
        imageView.alpha = 0
        return imageView
    }()
    
    // MARK: - Lifecycle Methods
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.accessibilityIdentifier = "heroListCell"
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 2
        
        imageView.addSubview(favoriteImageView)
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("This subclass does not support NSCoding.")
    }
    
    override class var requiresConstraintBasedLayout: Bool {
        return true
    }
    
    override func updateConstraints() {
        defer { super.updateConstraints() }
        guard customConstraints.isEmpty else { return }
        
        let views = [
            "contentView": contentView,
            "imageView": imageView,
            "titleLabel": titleLabel,
            "favoriteImageView": favoriteImageView
        ]
        
        let metrics = [
            "padding": Constants.padding,
            "bubbleSize": Constants.minBubbleSize,
            "numberPadding": 5
        ]
        
        customConstraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "H:|[imageView]|", metrics: metrics, views: views))
        customConstraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "V:|[imageView]|", metrics: metrics, views: views))
        customConstraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "H:|-(padding)-[titleLabel]-(padding)-|", metrics: metrics, views: views))
        customConstraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "V:|-(padding)-[titleLabel]", metrics: metrics, views: views))
        
        NSLayoutConstraint.activate(customConstraints)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        hasCellBeenLoaded = false
    }
    
    func configureCell(_ hero: Character) {
        contentView.backgroundColor = UIColor.gray
        
        let text = hero.name ?? ""
        titleLabel.text = text
        if let image = hero.thumbnail?.url.cachedImage {
            imageView.image = image
        } else {
            hero.thumbnail?.url.fetchImage { image in
                self.imageView.image = image
            }
        }
        
        hasCellBeenLoaded = true
    }
}
