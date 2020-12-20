//
//  Extensions.swift
//  unsplash-images
//
//  Created by Daeho Park on 2020/12/17.
//

import UIKit

extension UIView {
    // return cached image
    func setImageFromURL(tagNumber: Int, url: String, imageView: UIImageView) {
        tag = tagNumber
        if let image = ImageCacheService.shared.getCache(key: url) {
            imageView.image = image
        }
        DispatchQueue.global().async {
            let imageData = NSData.init(contentsOf: NSURL.init(string: url)! as URL)
            guard let data = imageData else { return }
            let image = UIImage.init(data: data as Data)
            ImageCacheService.shared.setCache(key: url, value: image)
            DispatchQueue.main.async { [weak self] in
                if self?.tag == tagNumber {
                    imageView.image = image
                } else {
                    print("cell index not match tag!!!")
                }
            }
        }
    }
}

extension Array {
    subscript (safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}
