//
//  ImageCacheService.swift
//  unsplash-images
//
//  Created by Daeho Park on 2020/12/20.
//

import UIKit


struct ImageCacheService {
    static var shared: ImageCacheService = ImageCacheService()
    let cache: NSCache<NSString, UIImage>
    
    init() {
        cache = NSCache<NSString, UIImage>()
    }
    
    func setCache(key: String, value: UIImage?) {
        guard let value = value else { return }
        cache.setObject(value, forKey: key as NSString)
    }
    
    func getCache(key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
}
