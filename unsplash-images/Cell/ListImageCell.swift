//
//  ListImageCell.swift
//  unsplash-images
//
//  Created by Daeho Park on 2020/12/17.
//

import UIKit

class ListImageCell: UITableViewCell {
    
    static let identifier = "ListImageCell"
    
    @IBOutlet weak var listImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    
    typealias Data = (name: String?, imageUrl: String?, width: Int, height: Int)
    
    func setData(data: Data) {
        guard let imageUrl = data.imageUrl else { return }
        userName.text = data.name ?? ""
        listImage.setImageFromURL(url: imageUrl)
    }

}

