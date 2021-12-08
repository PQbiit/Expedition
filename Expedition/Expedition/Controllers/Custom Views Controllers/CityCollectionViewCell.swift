//
//  CityCollectionViewCell.swift
//  Expedition
//
//  Created by Luis Alfonso Arriaga Quezada on 08/12/21.
//

import UIKit

class CityCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cityBackgroundImage: UIImageView!
    @IBOutlet weak var cityNameLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
    func setupViews() {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 10
    }
}
