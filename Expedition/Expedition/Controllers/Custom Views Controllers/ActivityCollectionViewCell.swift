//
//  ActivityCollectionViewCell.swift
//  Expedition
//
//  Created by Luis Alfonso Arriaga Quezada on 09/12/21.
//

import UIKit

class ActivityCollectionViewCell: UICollectionViewCell {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var cellBlurContainer: UIVisualEffectView!
    @IBOutlet weak var activityCoverImageView: UIImageView!
    @IBOutlet weak var priceBlurContainer: UIVisualEffectView!
    @IBOutlet weak var activityPriceLbl: UILabel!
    @IBOutlet weak var activityTitleLbl: UILabel!
    @IBOutlet weak var activityDescriptionLbl: UILabel!
    @IBOutlet weak var bucketListButton: UIButton!
    
    //MARK: - Attributes
    
    var activity: Activity? {
        didSet{
            setupViews()
        }
    }
    
    //MARK: - Life Cycle Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    //MARK: - Helper Methods
    
    func setupViews() {
        guard let activity = activity else { return }
        setUpViewDesign()
        
        activityPriceLbl.text = "$\(activity.retailPrice.value)"
        activityTitleLbl.text = activity.title
        activityDescriptionLbl.text = activity.description
        
        ActivityController.shared.fetchPhotoFor(url: activity.coverImageURL) { [weak self] (coverPhoto) in
            DispatchQueue.main.async {
                guard let coverPhoto = coverPhoto else { return }
                self?.activityCoverImageView.image = coverPhoto
                self?.activity?.coverImage = coverPhoto
            }
        }
        
    }
    
    func setUpViewDesign() {
        cellBlurContainer.layer.cornerRadius = 20
        cellBlurContainer.clipsToBounds = true
        activityCoverImageView.layer.cornerRadius = 20
        priceBlurContainer.layer.cornerRadius = priceBlurContainer.frame.height / 2
        priceBlurContainer.clipsToBounds = true
        bucketListButton.layer.cornerRadius = bucketListButton.frame.height / 2
    }
    
    //MARK: - IBActions
    
    @IBAction func bucketListButtonTapped(_ sender: Any) {
    }
    
}
