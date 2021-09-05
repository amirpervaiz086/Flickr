//
//  FlickrPhotoResponse.swift
//  FickrApp
//
//  Created by Amir Pervaiz on 31/8/21.
//

struct FlickrPhotoResponse: Codable {
    let photos: FlickrPhotos?
    let stat: String
    let message: String? // In case of error
    let code: Int? // In case of error
}

extension FlickrPhotoResponse {
    func validateResponse() -> Bool {
        if stat == "ok" {
            return true
        }
        return false
    }
    func errorMessageWithCode() -> String {
        if let message = message, let code = code {
            return (message + String(code))
        }
        return "Soemthing went wrong"
    }
}
