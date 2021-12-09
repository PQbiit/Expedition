//
//  CityDetailViewController.swift
//  Expedition
//
//  Created by Luis Alfonso Arriaga Quezada on 08/12/21.
//

import UIKit

class CityDetailViewController: UIViewController {

    //MARK: - IBOutlets
    
    @IBOutlet weak var coverPhotoContainer: UIView!
    @IBOutlet weak var backBlurView: UIVisualEffectView!
    @IBOutlet weak var cityCoverImageView: UIImageView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var bookmarkBlurView: UIVisualEffectView!
    @IBOutlet weak var bookmarkButton: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
  
    //MARK: - Attributes
    
    var city: City?
    var coverPhoto: UIImage?
    
    //MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    //MARK: - Helper Methods
    
    func setupViews() {
        coverPhotoContainer.clipsToBounds = true
        coverPhotoContainer.layer.cornerRadius = 20
        bookmarkBlurView.layer.cornerRadius = bookmarkBlurView.frame.height / 2.0
        backBlurView.layer.cornerRadius = backBlurView.frame.height / 2.0
        backBlurView.clipsToBounds = true
        bookmarkBlurView.clipsToBounds = true
        bookmarkButton.layer.cornerRadius = bookmarkButton.frame.height / 2
        backButton.layer.cornerRadius = backButton.frame.height / 2
        
        guard let city = city,
              let coverPhoto = coverPhoto
              else { return }
        cityCoverImageView.image = coverPhoto
        titleLbl.text = "\(city.name), \(city.country.name)"
        descriptionLbl.text = city.description
    }

    //MARK: - IBActions
    
    @IBAction func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    
}

//MARK: - CollectionView Data Source & Delegate Methods



//MARK: - CollectionViewDelegateFlowLayout



//MARK: - Extensions
