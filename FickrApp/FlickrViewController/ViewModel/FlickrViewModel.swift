//
//  FlickrViewModel.swift
//  FickrApp
//
//  Created by Amir Pervaiz on 30/8/21.
//

protocol FlickrViewModelInputs {
    // Fetch photos from the server
    func fetchPhotos(with text: String)
    
    // pagination
    func fetchNextPage()
    
    // this func checks if the pagination is enabled for the given text
    func isPaginationEnabled() -> Bool
    
    // getter for the collection view
    func getData(at index: Int) -> Photo
    
    // total count of the photos
    func totalCount() -> Int

    // count + 1 in case if isPaginationEnabled is true
    func totalItems() -> Int
    
    // check if the paginated call is already dispatched
    func isLoadingMore() -> Bool
    
    // preare for the new search item
    func resetSearch()

}

protocol FlickrViewModelOutput: AnyObject {
    var reloadCollectionView: (() -> Void) { get set }
    var dataError: ((String) -> Void) { get set }
}

protocol FlickrViewModelType {
    var inputs: FlickrViewModelInputs { get }
    var outputs: FlickrViewModelOutput { get }
}

final class FlickrViewModel: FlickrViewModelType, FlickrViewModelInputs, FlickrViewModelOutput {
    let serviceManager: ServiceType
    var currentPage = 1
    var totalPages = 1
    var photoArrays: [Photo] = [Photo]()
    var isLoading = false
    var currentSearchItem = ""
   
    init(service: ServiceType) {
        serviceManager = service
    }
    
    func fetchPhotos(with text: String) {
        print("Fetch Photos for \(text); page: \(currentPage); Total pages \(totalPages)")
        isLoading = true
        currentSearchItem = text
        serviceManager.fetchPhotos(text, page: currentPage) { [unowned self] result in
            isLoading = false
            switch result {
            case .success(let response):
                if response.validateResponse() {
                    if let photos = response.photos?.photo {
                        self.photoArrays += photos
                        if let pages = response.photos?.pages {
                            self.totalPages = pages
                        }
                        self.reloadCollectionView()
                    }
                } else {
                    self.dataError(response.errorMessageWithCode())
                }
            case .failure(let error):
                self.dataError(error.localizedDescription)
            }
        }
    }
    
    func fetchNextPage() {
        currentPage += 1
        if self.isPaginationEnabled() {
            self.fetchPhotos(with: currentSearchItem)
        }
    }
    
    func isPaginationEnabled() -> Bool {
        if currentPage < totalPages {
            return true
        }
        return false
    }
    
    func totalItems() -> Int {
        if !self.photoArrays.isEmpty && self.isPaginationEnabled() {
            return self.photoArrays.count + 1
        }
        return self.photoArrays.count
    }
    
    func isLoadingMore() -> Bool {
        return isLoading
    }
    
    func resetSearch() {
        photoArrays.removeAll()
        currentPage = 1
    }
    
    // Getter for data items
    func totalCount() -> Int {
        return self.photoArrays.count
    }
    
    func getData(at index: Int) -> Photo {
        return self.photoArrays[index]
    }
    
    var inputs: FlickrViewModelInputs { return self }
    var outputs: FlickrViewModelOutput { return self }
    var reloadCollectionView: (() -> Void) = {}
    var dataError: ((String) -> Void) = {_ in }
    
}
