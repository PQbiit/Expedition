//
//  CategoryView.swift
//  Expedition
//
//  Created by Luis Alfonso Arriaga Quezada on 09/12/21.
//

import UIKit

class CategoryView: UIView {
    
    @IBOutlet weak var categoryNameLbl: UILabel!
    @IBOutlet weak var blurEffectView: UIVisualEffectView!
    @IBOutlet weak var iconImageView: UIImageView!
    
    let nibName = "CategoryView"
    var category: Category?{
        didSet{
            setupViewsLayout()
            setupViewContent()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
        setupViewsLayout()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        setupViewsLayout()
    }
    
    func commonInit() {
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
    }
    
    func loadViewFromNib() -> UIView? {
        let nib = UINib(nibName: nibName, bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    func setupViewsLayout() {
        guard let category = category else { return }
        categoryNameLbl.text = category.name
        blurEffectView.layer.cornerRadius = blurEffectView.frame.height / 2.0
        iconImageView.layer.cornerRadius = iconImageView.frame.height / 2.0
        blurEffectView.clipsToBounds = true
        iconImageView.tintColor = UIColor.imperialRed
        //iconImageView.backgroundColor = .white
    }
    
    func setupViewContent() {
        switch category?.id {
            case 1:
                iconImageView.image = CategoryType.id1.icon
            case 2:
                iconImageView.image = CategoryType.id2.icon
            case 3:
                iconImageView.image = CategoryType.id3.icon
            case 4:
                iconImageView.image = CategoryType.id4.icon
            case 5:
                iconImageView.image = CategoryType.id5.icon
            case 6:
                iconImageView.image = CategoryType.id6.icon
            case 7:
                iconImageView.image = CategoryType.id7.icon
            default:
                break
        }
        categoryNameLbl.text = category?.name
    }
    
}
