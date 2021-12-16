//
//  SmallActivityCollectionViewCell.swift
//  Expedition
//
//  Created by Luis Alfonso Arriaga Quezada on 15/12/21.
//

import UIKit

class SmallActivityCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var activityImageView: UIImageView!
    @IBOutlet weak var activityTitleLbl: UILabel!
    
    var blActivity: BLActivity?{
        didSet{
            setupViewsWithBLActivity()
        }
    }
    
    var activity: Activity? {
        didSet{
            setupViewsWithActivity()
        }
    }
    
    func setupUI() {
        blurView.layer.cornerRadius = 20
        blurView.clipsToBounds = true
        activityImageView.layer.cornerRadius = 20
    }
    
    func setupViewsWithBLActivity() {
        setupUI()
        guard let activity = blActivity else { return }
        activityTitleLbl.text = activity.title
        if let coverData = activity.coverImageData {
            activityImageView.image = UIImage(data: coverData)
        }
    }
    
    func setupViewsWithActivity() {
        setupUI()
        guard let activity = activity else { return }
        activityTitleLbl.text = activity.title
        ActivityController.shared.fetchPhotoFor(url: activity.coverImageURL) { [weak self] (image) in
            DispatchQueue.main.async {
                if let image = image {
                    self?.activityImageView.image = image
                }
            }
        }
    }
    
}
