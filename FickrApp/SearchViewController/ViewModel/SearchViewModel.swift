//
//  SearchVireModell.swift
//  FickrApp
//
//  Created by Amir Pervaiz on 31/8/21.
//

import Foundation

protocol SearchViewModelInputs {
    
    // When the viewDidLoad of the viewController is called
    func viewdidLoad()
    
    // Get the total count of the items to be displayed on the list
    func totalCount() -> Int
    
    // Get data item at selected index path
    func getData(at index: Int) -> SearchItem
    
    // Saved last saved Entered keyword
    func saveKeyword(_ word: String)
    
    // Reset the filtered array to the original array when clear search is called from the controller
    func resetSearch()
    
    // Filter text while the user types
    func filterText(_ text: String)
    
}

protocol SearchViewModelOutput: AnyObject {
    var reloadTableView: (() -> Void) { get set }
    var errorOccured: ((String) -> Void) { get set }
}

protocol SearchViewModelType {
    var inputs: SearchViewModelInputs { get }
    var outputs: SearchViewModelOutput { get }
}

final class SearchViewModel: SearchViewModelType, SearchViewModelInputs, SearchViewModelOutput {
    let storage: CodableStorage
    var originalCachedData = [SearchItem]()
    var filteredData: [SearchItem]?
    init(_ storage: CodableStorage) {
        self.storage = storage
    }
    
    var inputs: SearchViewModelInputs {return self}
    var outputs: SearchViewModelOutput {return self}
    var reloadTableView: (() -> Void) = {}
    var errorOccured: ((String) -> Void) = { _ in }
    
    // Input methods
    func viewdidLoad() {
        self.loadData()
    }
    
    private func loadData() {
        do {
            let history: SearchHistory = try storage.fetch(for: "SearchHistory")
            originalCachedData = history.words
            filteredData = originalCachedData
        } catch {
            print("No saved data found...")
            errorOccured(error.localizedDescription)
        }
    }
    
    func getData(at index: Int) -> SearchItem {
        return filteredData![index]
    }
    
    func saveKeyword(_ word: String) {
        originalCachedData =  originalCachedData.filter({$0.text != word})
        originalCachedData.insert(SearchItem(text: word, timestamp: Date.init()), at: 0)
        do {
            try storage.save(SearchHistory(words: originalCachedData), for: "SearchHistory")
        } catch {
            errorOccured(error.localizedDescription)
        }
    }
    
    func resetSearch() {
        filteredData = originalCachedData
        reloadTableView()
    }
    // Getter for data items
    func totalCount() -> Int {
        if let array = filteredData {
            return array.count
        }
        return 0
    }
    
    func filterText(_ text: String) {
        if !text.isEmpty {
        filteredData = originalCachedData.filter({ $0.text.contains(text) })
        } else {
            filteredData = originalCachedData
        }
        reloadTableView()
    }
}
