//
//  Extensions.swift
//  unsplash-images
//
//  Created by Daeho Park on 2020/12/17.
//

import UIKit

extension UIImageView {
    func setImageFromURL(url: String) {
        DispatchQueue.global().async {
            let data = NSData.init(contentsOf: NSURL.init(string: url)! as URL)
            DispatchQueue.main.async {
                let image = UIImage.init(data: data! as Data)
                self.image = image
            }
        }
    }
}
