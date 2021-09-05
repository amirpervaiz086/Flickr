//
//  Route.swift
//  FickrApp
//
//  Created by Amir Pervaiz on 30/8/21.
//

enum Route {
    case fetchPhotos(query: String, page: Int)
    
    var routeProperties: (method: HTTPMethod, url: String) {
        switch self {
        case .fetchPhotos(let query, let page):
            return (.get, "/?method=flickr.photos.search&api_key=\(Constants.API_KEY)&format=json&nojsoncallback=1&text=\(query)&per_page=\(Constants.PER_PAGE)&page=\(page)")
        }
    }
}

enum HTTPMethod: String {
    case post = "POST"
    case get = "GET"
    case put = "PUT"
    case delete = "DELETE"
}
