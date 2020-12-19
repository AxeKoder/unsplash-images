//
//  ListImageCell.swift
//  unsplash-images
//
//  Created by Daeho Park on 2020/12/17.
//

import UIKit

class ListImageCell: UITableViewCell {
    typealias CellData = (name: String?, imageUrl: String?, width: Int, height: Int)
    
    static let identifier = "ListImageCell"
    
    @IBOutlet weak var listImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    
    override func prepareForReuse() {
        listImage.image = nil
    }
    
    func setData(index: Int, data: CellData) {
        guard let imageUrl = data.imageUrl else { return }
        tag = index
        userName.text = data.name ?? ""
        setImageFromURL(tagNumber: index, url: imageUrl, imageView: listImage)   
    }
}



