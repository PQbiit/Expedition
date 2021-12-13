//
//  PhotoGalleryCollectionViewCell.swift
//  Expedition
//
//  Created by Luis Alfonso Arriaga Quezada on 12/12/21.
//

import UIKit

class PhotoGalleryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    var photoURL: String?{
        didSet{
            setupViews()
        }
    }
    
    func setupViews() {
        guard let photoURL = photoURL else { return }
        ActivityController.shared.fetchPhotoFor(url: photoURL) { [weak self] (image) in
            DispatchQueue.main.async {
                guard let image = image else { return }
                self?.photoImageView.image = image
            }
        }
    }
    
}
