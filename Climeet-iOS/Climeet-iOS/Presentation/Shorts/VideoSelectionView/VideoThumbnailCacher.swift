//
//  VideoThumbnailCacher.swift
//  Climeet-iOS
//
//  Created by mac on 11/25/24.
//

import Foundation
import UIKit

actor VideoThumbnailCacher {
    static let shared = VideoThumbnailCacher()
    
    private let cache: NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>()
        cache.countLimit = 200
        cache.totalCostLimit = 1024 * 1024 * 100
        return cache
    }()
    
    private init() {}
    
    // MARK: - Cache Operations
    func setImage(_ image: UIImage, forKey key: String) {
        let cacheKey = NSString(string: key)
        cache.setObject(image, forKey: cacheKey)
    }
    
    func image(forKey key: String) -> UIImage? {
        let cacheKey = NSString(string: key)
        return cache.object(forKey: cacheKey)
    }
    
    func removeImage(forKey key: String) {
        let cacheKey = NSString(string: key)
        cache.removeObject(forKey: cacheKey)
    }
    
    func clearCache() {
        cache.removeAllObjects()
    }
}
