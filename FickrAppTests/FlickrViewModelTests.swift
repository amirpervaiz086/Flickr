//
//  FlickrViewModel.swift
//  FickrAppTests
//
//  Created by Amir Pervaiz on 4/9/21.
//

import XCTest

class FlickrViewModelTests: XCTestCase {
    
    var viewModel: FlickrViewModelType?
    var mockService: ServiceType?
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    func testSuccessfulSearchResponseReceived() {
        mockService = MockServiceManager.init(template: .template1)
        viewModel = FlickrViewModel(service: mockService!)
        viewModel?.inputs.fetchPhotos(with: "Kittens")
        let count = viewModel?.inputs.totalCount()
        XCTAssert(count == 2)
    }
    
    func testViewUpdatedAfterSuccessfulResponseReceived() {
        
        mockService = MockServiceManager.init(template: .template1)
        viewModel = FlickrViewModel(service: mockService!)
        
        viewModel?.outputs.reloadCollectionView = {
            XCTAssert(true)
        }
        
        viewModel?.inputs.fetchPhotos(with: "Kittens")
    }
    
    func testInvalidKeyMessagefromtheAPISuccussful() {
        
        mockService = MockServiceManager.init(template: .template3)
        viewModel = FlickrViewModel(service: mockService!)
        
        viewModel?.outputs.dataError = { message in
            XCTAssertEqual("Invalid API Key (Key has invalid format)100", message)
        }
        
        viewModel?.inputs.fetchPhotos(with: "Kittens")
    }
    
    func testInvalidAPIKeyMessagefromtheAPIWhenFailed() {
        
        mockService = MockServiceManager.init(template: .template3)
        viewModel = FlickrViewModel(service: mockService!)
        
        viewModel?.outputs.dataError = { message in
            XCTAssertEqual("Invalid API Key (Key has invalid format)102", message)
        }
        
        viewModel?.inputs.fetchPhotos(with: "Kittens")
    }
    
    
    // Test Successfull paginated calls
    func testPaginatedAPICallWithValidTotallPages() {
        
        mockService = MockServiceManager.init(template: .template1)
        viewModel = FlickrViewModel(service: mockService!)
        viewModel?.inputs.fetchPhotos(with: "Kittens")
        
        var count = viewModel?.inputs.totalCount()
        XCTAssert(count == 2)
        
        // Next page will fetch template 1 again so total should be 4
        viewModel?.inputs.fetchNextPage()
        count = viewModel?.inputs.totalCount()
        XCTAssert(count == 4)
        
    }
    
    // When all pages are fetched it should not fetch more photos for the selected text
    func testPaginatedCallWhenAllPagesFetched() {
        
        // Template 4 has 2 record and total pages = 1
        mockService = MockServiceManager.init(template: .template4)
        viewModel = FlickrViewModel(service: mockService!)
        viewModel?.inputs.fetchPhotos(with: "Kittens")
        
        var count = viewModel?.inputs.totalCount()
        XCTAssert(count == 2)
        
        viewModel?.inputs.fetchNextPage()
        count = viewModel?.inputs.totalCount()
        XCTAssertEqual(count, 2, "All pages are fetched")
    }
    
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        viewModel = nil
        mockService =  nil
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
