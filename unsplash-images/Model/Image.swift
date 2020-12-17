//
//  Image.swift
//  unsplash-images
//
//  Created by Daeho Park on 2020/12/16.
//

import Foundation


struct Image: Decodable {
    let id: String
    let width: Int
    let height: Int
    let color: String
    let description: String?
    let urls: URLs
    let user: User?
    
}
