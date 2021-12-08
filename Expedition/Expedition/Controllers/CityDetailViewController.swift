//
//  CityDetailViewController.swift
//  Expedition
//
//  Created by Luis Alfonso Arriaga Quezada on 08/12/21.
//

import UIKit

class CityDetailViewController: UIViewController {

    @IBOutlet weak var coverPhotoContainer: UIView!
    @IBOutlet weak var cityCoverImageView: UIImageView!
    @IBOutlet weak var bookmarkBlurView: UIVisualEffectView!
    @IBOutlet weak var bookmarkButton: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupViews() {
        coverPhotoContainer.clipsToBounds = true
        coverPhotoContainer.layer.cornerRadius = 20
        bookmarkBlurView.layer.cornerRadius = bookmarkBlurView.frame.height / 2.0
        bookmarkBlurView.clipsToBounds = true
        bookmarkButton.layer.cornerRadius = bookmarkButton.frame.height / 2
    }

}
