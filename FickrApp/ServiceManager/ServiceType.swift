//
//  ServiceType.swift
//  FickrApp
//
//  Created by Amir Pervaiz on 30/8/21.
//

import UIKit
// This class contains all the methods for API calls
protocol ServiceType {
    
    func fetchPhotos(_ query: String, page: Int, completion: @escaping (Result<FlickrPhotoResponse, FickrError>) -> Void)
}
