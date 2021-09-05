//
//  ServiceManager.swift
//  FickrApp
//
//  Created by Amir Pervaiz on 30/8/21.
//

import UIKit

// This class implements all the API methods defined in the ServiceType

struct ServiceManager: ServiceType {
    func fetchPhotos(_ query: String, page: Int, completion: @escaping (Result<FlickrPhotoResponse, FickrError>) -> Void) {
        self.request(.fetchPhotos(query: query, page: page), completion: completion)
    }
    
    //TODO: Using URLSession.Can be replaced with Alamofire or Moya.
    func request<T: Decodable>(_ route: Route, completion: @escaping (Result<T, FickrError>) -> Void) {
        print(Constants.BASE_URL + route.routeProperties.url)
        
        let api = Constants.BASE_URL + route.routeProperties.url
        guard let urlString = api.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            completion(.failure(.invalidURL))
            return
        }

        let request = URLRequest(url: URL.init(string: urlString)!)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let responseError = error {
                completion(.failure(.genericError(responseError.localizedDescription)))
            }
            guard (response as? HTTPURLResponse) != nil, let responseData = data
            else {
                completion(.failure(.unkownResponse))
                return
            }
            do {
                let parsedData = try JSONDecoder().decode(T.self, from: responseData)
                completion(.success(parsedData))
            } catch {
                print(error.localizedDescription)
                completion(.failure(.invalidData))
                return
            }
        }.resume()
    }
}

enum FickrError: Error {
    case unkownResponse
    case invalidData // if parsing faills
    case genericError(String)
    case invalidURL
}
