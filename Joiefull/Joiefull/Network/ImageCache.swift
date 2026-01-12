import UIKit

final class ImageCache {
    //MARK: Singleton
    static let shared = ImageCache()
    
    //MARK: Property
    private let cache = NSCache<NSURL, UIImage>()
    
    //MARK: Init
    private init() {
        cache.countLimit = 100
    }
    
    //MARK: Methods
    func getImage(for url: URL) -> UIImage? {
        cache.object(forKey: url as NSURL)
    }
    
    func setImage(_ image: UIImage, for url: URL) {
        cache.setObject(image, forKey: url as NSURL)
    }
}
