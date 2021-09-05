//
//  MockServiceManager.swift
//  FickrAppTests
//
//  Created by Amir Pervaiz on 4/9/21.
//

import Foundation

struct MockServiceManager: ServiceType {
    
    var isDelay = false
    var currentTemplate: MockTemplate
    var showError = false
    
    init(template: MockTemplate, isDelay: Bool = false) {
        self.isDelay  = isDelay
        self.currentTemplate = template
    }
    
    func fetchPhotos(_ query: String, page: Int, completion: @escaping (Result<FlickrPhotoResponse, FickrError>) -> Void) {
        self.request(.fetchPhotos(query: query, page: page), completion: completion)
    }
    
    func request(_ route: Route, completion: @escaping (Result<FlickrPhotoResponse, FickrError>) -> Void) {
        
        switch currentTemplate {
        case .template1:
            completion(.success(FlickrPhotoResponse.template1))
        case .template2:
            completion(.success(FlickrPhotoResponse.template2))
        case .template3:
            completion(.success(FlickrPhotoResponse.template3))
        case .template4:
            completion(.success(FlickrPhotoResponse.template4))
        }
    }
}

enum MockTemplate {
    case template1
    case template2
    case template3
    case template4
}

extension FlickrPhotoResponse {
    // Template 1: complete message with two photos
    internal static let template1 = FlickrPhotoResponse(photos: FlickrPhotos(page: 1, pages: 27084, total: 135416, perpage: 5, photo: [Photo(title: "Luna", id: "51423780918" , owner: "186948470", secret: "a0cf4046a4", server: "65535", farm: 66, ispublic: 1, isfamily: 0, isfriend: 0), Photo(title: "034 Reliant Kitten Van (1977) UDV 601 R", id: "51423780918" , owner: "45676495", secret: "ab59371151", server: "65535", farm: 66, ispublic: 1, isfamily: 0, isfriend: 0)]), stat: "ok", message: nil, code: nil)
    
    // Template 2: valid message with farm and server are missing
    internal static let template2 = FlickrPhotoResponse(photos: FlickrPhotos(page: 1, pages: 27084, total: 135416, perpage: 5, photo: [Photo(title: "Luna", id: "51423780918" , owner: "186948470", secret: "a0cf4046a4", server: nil, farm: nil, ispublic: 1, isfamily: 0, isfriend: 0), Photo(title: "034 Reliant Kitten Van (1977) UDV 601 R", id: "51423780918" , owner: "45676495", secret: "ab59371151", server: "65535", farm: 66, ispublic: 1, isfamily: 0, isfriend: 0)]), stat: "ok", message: nil, code: nil)
    
    // Template 3: Failed message with invalid API key
    //{"stat":"fail","code":100,"message":"Invalid API Key (Key has invalid format)"}
    internal static let template3 = FlickrPhotoResponse(photos: FlickrPhotos(page: 1, pages: 27084, total: 135416, perpage: 5, photo: nil), stat: "fail", message: "Invalid API Key (Key has invalid format)", code: 100)
    
    // one page having 2 records. The viewModel should not call the paginated API call. 
    internal static let template4 = FlickrPhotoResponse(photos: FlickrPhotos(page: 1, pages: 1, total: 2, perpage: 2, photo: [Photo(title: "Luna", id: "51423780918" , owner: "186948470", secret: "a0cf4046a4", server: "65535", farm: 66, ispublic: 1, isfamily: 0, isfriend: 0), Photo(title: "034 Reliant Kitten Van (1977) UDV 601 R", id: "51423780918" , owner: "45676495", secret: "ab59371151", server: "65535", farm: 66, ispublic: 1, isfamily: 0, isfriend: 0)]), stat: "ok", message: nil, code: nil)
}

// Sample response with 5 items
/*
 {
 "photos": {
 "page": 1,
 "pages": 27084,
 "perpage": 5,
 "total": 135416,
 "photo": [{
 "id": "51423780918",
 "owner": "186948470@N04",
 "secret": "a0cf4046a4",
 "server": "65535",
 "farm": 66,
 "title": "Luna",
 "ispublic": 1,
 "isfriend": 0,
 "isfamily": 0
 }, {
 "id": "51424274539",
 "owner": "45676495@N05",
 "secret": "ab59371151",
 "server": "65535",
 "farm": 66,
 "title": "034 Reliant Kitten Van (1977) UDV 601 R",
 "ispublic": 1,
 "isfriend": 0,
 "isfamily": 0
 }, {
 "id": "51423484111",
 "owner": "32761335@N08",
 "secret": "b70eaa48ba",
 "server": "65535",
 "farm": 66,
 "title": "Kitten",
 "ispublic": 1,
 "isfriend": 0,
 "isfamily": 0
 }, {
 "id": "51422491797",
 "owner": "148179219@N03",
 "secret": "ce190e4324",
 "server": "65535",
 "farm": 66,
 "title": "poedie 3 (99)",
 "ispublic": 1,
 "isfriend": 0,
 "isfamily": 0
 }, {
 "id": "51423210191",
 "owner": "116001411@N02",
 "secret": "39ecc0a833",
 "server": "65535",
 "farm": 66,
 "title": "20180916-160133 Handmade Wooden Toy Black Cat Kitten Tray Puzzle 645535259 004",
 "ispublic": 1,
 "isfriend": 0,
 "isfamily": 0
 }]
 },
 "stat": "ok"
 }
 */
