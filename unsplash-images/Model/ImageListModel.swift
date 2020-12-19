//
//  ImageListModel.swift
//  unsplash-images
//
//  Created by Daeho Park on 2020/12/17.
//

import Foundation


struct ImageListModel {
    func parseImageList(images: [Image]) -> [ListImageCell.CellData] {
        return images.map {
            (name: $0.user?.name, imageUrl: $0.urls.regular, width: $0.width, height: $0.height)
        }
    }
    
    func parseToDetail(images: [ListImageCell.CellData]) -> [DetailImageCell.CellData] {
        return images.map {
            (name: $0.name, imageUrl: $0.imageUrl, width: $0.width, height: $0.height)
        }
    }
    
    func getImageList(page: Int, per_page: Int = 15, completion: @escaping (Result<[Image], Error>) -> Void) {
        APIService.getList(page: page, per_page: per_page, completion: completion)
    }
}
