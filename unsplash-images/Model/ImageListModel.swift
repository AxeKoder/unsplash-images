//
//  ImageListModel.swift
//  unsplash-images
//
//  Created by Daeho Park on 2020/12/17.
//

import Foundation


struct ImageListModel {
    func parseImageList(images: [Image]) -> [ListImageCell.Data] {
        return images.map {
            (name: $0.user?.name, imageUrl: $0.urls.regular, width: $0.width, height: $0.height)
        }
    }
    
    func getImageList(completion: @escaping (Result<[Image], Error>) -> Void) {
        APIService.getList(completion: completion)
    }
}
