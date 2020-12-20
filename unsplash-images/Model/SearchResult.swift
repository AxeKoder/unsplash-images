//
//  SearchResult.swift
//  unsplash-images
//
//  Created by Daeho Park on 2020/12/20.
//

import Foundation


struct SearchResult: Decodable {
    let total: Int
    let total_pages: Int
    let results: [Image]
}
