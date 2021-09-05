//
//  PhotoCollectionViewCell.swift
//  FickrApp
//
//  Created by Amir Pervaiz on 30/8/21.
//

import UIKit
import SDWebImage

class PhotoCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak private var flickrImageView: UIImageView!

    func congfigureCell(with photo: Photo) {
        flickrImageView.sd_setImage(with: photo.photoURL, placeholderImage: UIImage(named: "placeholder.png"))
    }
}
