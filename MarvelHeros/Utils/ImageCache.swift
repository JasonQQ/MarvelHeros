import UIKit

extension URL {
    
    private static var imageCache = NSCache<NSString, UIImage>()
    typealias ImageCacheCompletion = (UIImage) -> Void
    
    var cachedImage: UIImage? {
        return URL.imageCache.object(
            forKey: absoluteString as NSString)
    }
    
    func fetchImage(completion: @escaping ImageCacheCompletion) {
        DispatchQueue.global().async {
            let task = URLSession.shared.dataTask(with: self as URL) { data, _, error in
                if error == nil {
                    if let  data = data,
                        let image = UIImage(data: data) {
                        URL.imageCache.setObject(
                            image,
                            forKey: self.absoluteString as NSString)
                        DispatchQueue.main.async {
                            completion(image)
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
}
