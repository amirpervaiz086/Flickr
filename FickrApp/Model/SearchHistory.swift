//
//  SearchItem.swift
//  FickrApp
//
//  Created by Amir Pervaiz on 4/9/21.
//

import Foundation

struct SearchHistory: Codable {
    let words: [SearchItem]
}

struct SearchItem: Codable {
    let text: String
    let timestamp: Date
}
