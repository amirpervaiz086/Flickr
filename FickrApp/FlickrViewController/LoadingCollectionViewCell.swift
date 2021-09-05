//
//  loadingCollectionViewCell.swift
//  FickrApp
//
//  Created by Amir Pervaiz on 30/8/21.
//

import UIKit

class LoadingCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    func setupCell() {
        self.indicatorView.startAnimating()
    }

}
