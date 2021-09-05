//
//  Photos.swift
//  FickrApp
//
//  Created by Amir Pervaiz on 31/8/21.
//

import Foundation

struct Photo: Codable {
    let title: String?
    let id: String?
    let owner: String?
    let secret: String?
    let server: String?
    let farm: Int?
    let ispublic: Int?
    let isfamily: Int?
    let isfriend: Int?
}

extension Photo {
    var photoURL: URL? {
        if let farm = farm, let server = server, let id = id, let secret = secret {
            print("Photo URLL is: https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_m.jpg")
            return URL(string: "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_m.jpg")
        }
        return nil
    }
}
