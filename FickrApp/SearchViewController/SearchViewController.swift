//
//  SearchViewController.swift
//  FickrApp
//
//  Created by Amir Pervaiz on 31/8/21.
//

import UIKit

protocol SearchTextProtocol: AnyObject {
    func searchForItem(_ text: String)
}

private let reuseIdentifier = "SearchCell"

class SearchViewController: UIViewController {
    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak private var searchBar: UISearchBar!
    
    weak var delegate: SearchTextProtocol?
    lazy var viewModel: SearchViewModelType = {
        let path = URL(fileURLWithPath: NSTemporaryDirectory())
        let disk: Storage = DiskStorage(path: path)
        let storage = CodableStorage(storage: disk)
        return SearchViewModel(storage)
    }()
    
    override func viewDidLoad() {
        self.title = "Search"
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        self.bindViewModel()
        self.viewModel.inputs.viewdidLoad()
        self.searchBar.becomeFirstResponder()
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    func bindViewModel() {
        self.viewModel.outputs.errorOccured = { message in
            print(message)
        }
        self.viewModel.outputs.reloadTableView = { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    deinit {
        print("SearchViewController callleld")
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
}

// MARK: - Table view data source

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.viewModel.inputs.totalCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        
        // Configure the cell...
        cell.textLabel?.text = self.viewModel.inputs.getData(at: indexPath.row).text
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Change the selected background view of the cell.
        tableView.deselectRow(at: indexPath, animated: true)
        let text =  self.viewModel.inputs.getData(at: indexPath.row).text
        self.viewModel.inputs.saveKeyword(text)
        self.delegate?.searchForItem(text)
        self.navigationController?.popViewController(animated: true)
    }
    
}

// MARK: - UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.viewModel.inputs.resetSearch()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else {
            let alert = UIAlertController(title: "Flickr App", message: "Please enter the text first!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
        }
        self.viewModel.inputs.saveKeyword(text)
        self.delegate?.searchForItem(text)
        view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.viewModel.inputs.filterText(searchText)
    }
}
