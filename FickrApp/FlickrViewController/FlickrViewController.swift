//
//  FlickrViewController.swift
//  FickrApp
//
//  Created by Amir Pervaiz on 30/8/21.
//

import UIKit

private let reuseIdentifier = "PhotoCell"
private let loaderCellIdentifier = "LoaderCell"

class FlickrViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!

    lazy var viewModel: FlickrViewModelType = {
        return FlickrViewModel(service: ServiceManager())
    }()
    
    override func viewDidLoad() {
        self.title = "Flickr"
        super.viewDidLoad()

        self.bindViewModel()
        self.indicatorView.startAnimating()
        // Sample input
        self.viewModel.inputs.fetchPhotos(with: "Kittens")
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        // Do any additional setup after loading the view.
        self.collectionView.delegate = self
    }
    
    func bindViewModel() {
        
        viewModel.outputs.reloadCollectionView = { [weak self] in
            DispatchQueue.main.async {
                self?.indicatorView.stopAnimating()
                self?.collectionView.reloadData()
            }
        }
        viewModel.outputs.dataError = { [weak self] message in
            DispatchQueue.main.async {
                self?.showAlertView(message)
            }
        }
    }
    
    func showAlertView(_ message: String) {
        print("showAlertView")
    }
    
     // MARK: - Navigation
     // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if segue.destination is SearchViewController {
            let viewController = segue.destination as? SearchViewController
            viewController?.delegate = self
        }
    }
    
    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.viewModel.inputs.totalItems()
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Configure the cell
        if indexPath.row == self.viewModel.inputs.totalCount() {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: loaderCellIdentifier, for: indexPath) as! LoadingCollectionViewCell
            cell.setupCell()
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PhotoCollectionViewCell
            cell.congfigureCell(with: self.viewModel.inputs.getData(at: indexPath.row))
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.frame.size
        if indexPath.row == self.viewModel.inputs.totalCount() {
            return CGSize(width: size.width, height: 60)
        }
        return CGSize(width: size.width/2 - 15, height: 200)
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if (indexPath.row == self.viewModel.inputs.totalCount()) && !self.viewModel.inputs.isLoadingMore() {
            self.viewModel.inputs.fetchNextPage()
        }
    }
}

extension FlickrViewController: SearchTextProtocol {
    func searchForItem(_ text: String) {
        self.indicatorView.startAnimating()
        self.viewModel.inputs.resetSearch()
        self.collectionView.reloadData()
        self.viewModel.inputs.fetchPhotos(with: text)
    }
}
