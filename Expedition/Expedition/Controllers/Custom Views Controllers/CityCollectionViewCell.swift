//
//  CityCollectionViewCell.swift
//  Expedition
//
//  Created by Luis Alfonso Arriaga Quezada on 08/12/21.
//

import UIKit

class CityCollectionViewCell: UICollectionViewCell {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var cityBackgroundImage: UIImageView!
    @IBOutlet weak var cityNameLbl: UILabel!
    
    //MARK: - Attributes
    
    var city: City? {
        didSet{
            setupViews()
        }
    }
    var coverPhoto: UIImage?

    //MARK: - Helper Methods
    
    func setupCellCornerRadius() {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 10
    }
    
    func setupViews() {
        setupCellCornerRadius()

        guard let city = city else { return }

        CityController.shared.fetchCoverPhotofor(coverPhotoURL: city.coverImageURL) { [weak self] (coverPhoto) in
            DispatchQueue.main.async {
                self?.cityNameLbl.text = "\(city.name), \(city.country.name)"
                if coverPhoto != nil{
                    self?.coverPhoto = coverPhoto
                    self?.cityBackgroundImage.image = coverPhoto
                }
            }
        }
        
    }
    
}
