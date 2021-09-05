//
//  FlickrPhotos.swift
//  FickrApp
//
//  Created by Amir Pervaiz on 31/8/21.
//

struct FlickrPhotos: Codable {
    let page: Int
    let pages: Int
    let total: Int
    let perpage: Int
    let photo: [Photo]? // it can be empty
}

//page":1,"pages":1356,"perpage":100,"total":135548,"photo"
