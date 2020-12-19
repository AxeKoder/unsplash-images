//
//  DetailImageCell.swift
//  unsplash-images
//
//  Created by Daeho Park on 2020/12/19.
//

import UIKit

class DetailImageCell: UICollectionViewCell {
    typealias CellData = (name: String?, imageUrl: String?, width: Int, height: Int)
    
    static let identifier = "DetailImageCell"
    
    @IBOutlet weak var detailImage: UIImageView!
    
    func setData(index: Int, data: CellData) {
        guard let imageUrl = data.imageUrl else { return }
        setImageFromURL(tagNumber: index, url: imageUrl, imageView: detailImage)
    }
}
