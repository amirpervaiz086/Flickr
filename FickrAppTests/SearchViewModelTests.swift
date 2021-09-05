//
//  SearchViewModelTest.swift
//  FickrAppTests
//
//  Created by Amir Pervaiz on 4/9/21.
//

import XCTest

class SearchViewModelTests: XCTestCase {
    
    var path: URL?
    var disk: Storage?
    var storage: CodableStorage?
    var searchViewModel: SearchViewModelType?
    /*
     let path = URL(fileURLWithPath: NSTemporaryDirectory())
     let disk: Storage = DiskStorage(path: path)
     let storage = CodableStorage(storage: disk)
     return SearchViewModel(storage)
     */
    override func setUpWithError() throws {
        path = URL(fileURLWithPath: NSTemporaryDirectory())
        disk = DiskStorage(path: path!)
        storage = CodableStorage(storage: disk!)
        searchViewModel = SearchViewModel.init(storage!)
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    func testReadSearchItems() {
        searchViewModel?.inputs.saveKeyword("Kitten")
        searchViewModel?.inputs.saveKeyword("clouds")
        searchViewModel?.inputs.saveKeyword("Phillosopher")
        
        self.searchViewModel?.inputs.viewdidLoad()
        
        XCTAssertEqual(self.searchViewModel?.inputs.getData(at: 0).text, "Phillosopher")
        XCTAssertEqual(self.searchViewModel?.inputs.getData(at: 1).text, "clouds")
        XCTAssertEqual(self.searchViewModel?.inputs.getData(at: 2).text, "Kitten")
        
    }
    
    func testFiteredData() {
        searchViewModel?.inputs.saveKeyword("Kitten")
        searchViewModel?.inputs.saveKeyword("clouds")
        searchViewModel?.inputs.saveKeyword("Kite")
        searchViewModel?.inputs.saveKeyword("Singapore")
        searchViewModel?.inputs.saveKeyword("Sunset")
        
        self.searchViewModel?.inputs.viewdidLoad()
        self.searchViewModel?.inputs.filterText("S")
        
        XCTAssert(self.searchViewModel?.inputs.totalCount() == 2)
        XCTAssertEqual(self.searchViewModel?.inputs.getData(at: 0).text, "Sunset")
        XCTAssertEqual(self.searchViewModel?.inputs.getData(at: 1).text, "Singapore")
        
    }
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
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
