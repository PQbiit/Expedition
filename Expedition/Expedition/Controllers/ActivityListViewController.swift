//
//  ActivityListViewController.swift
//  Expedition
//
//  Created by Luis Alfonso Arriaga Quezada on 09/12/21.
//

import UIKit

class ActivityListViewController: UIViewController {

    //MARK: - IBOutlets
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var categoriesStackView: UIStackView!
    @IBOutlet weak var allActivitiesView: CategoryView!
    @IBOutlet weak var activityCollectionView: UICollectionView!
    
    //MARK: - Attributes
    
    var cityID: String?
    var cityName: String?
    
    var categories: [Category] = []
    var activities: [Activity] = []
    
    //MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = false
        fetchCategoriesForCity()
        fetchActivities(paginationOffSet: 0)
        setupViews()
    }
    
    //MARK: - Helper Methods
    
    func setupViews() {
        activityCollectionView.delegate = self
        activityCollectionView.dataSource = self
        activityCollectionView.register(UINib(nibName: "ActivityCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "largeActivityCell")
        guard let cityName = cityName else { return }
        titleLbl.text = "Activities in \(cityName)"
        allActivitiesView.categoryNameLbl.text = "All"
        allActivitiesView.blurEffectView.layer.cornerRadius = allActivitiesView.blurEffectView.frame.height / 2.0
        allActivitiesView.iconImageView.layer.cornerRadius = allActivitiesView.iconImageView.frame.height / 2.0
        allActivitiesView.blurEffectView.clipsToBounds = true
        allActivitiesView.iconImageView.image = UIImage(systemName: "dot.circle.fill")
        allActivitiesView.iconImageView.tintColor = UIColor.imperialRed
    }
    
    func fetchCategoriesForCity() {
        guard let cityID = cityID else { return }
        CategoryController.shared.fetchActivityCategoriesFor(cityID: cityID) { [weak self] (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let categories):
                    self?.categories = categories
                    for category in categories {
                        let categoryView = CategoryView()
                        categoryView.category = category
                        self?.categoriesStackView.addArrangedSubview(categoryView)
                    }
                case .failure(let error):
                    self?.presentErrorAlert(error: error)
                }
            }
        }
    }
    
    func fetchActivities(paginationOffSet: Int) {
        guard let cityID = cityID else { return }
        ActivityController.shared.fetchActivitiesForCity(cityID: cityID, paginationOffSet: paginationOffSet) { [weak self] (result) in
            DispatchQueue.main.async {
                switch result {
                    case .success(let activities):
                        self?.activities = activities
                        self?.activityCollectionView.reloadData()
                    case .failure(let error):
                        self?.presentErrorAlert(error: error)
                }
            }
        }
    }

    //MARK: - IBActions
    
    
    
}

//MARK: - CollectionView Data Source & Delegate Methods

extension ActivityListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return activities.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "largeActivityCell", for: indexPath) as? ActivityCollectionViewCell else { return UICollectionViewCell() }
        let activity = activities[indexPath.row]
        cell.activity = activity
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let destinationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ActivityDetailVC") as? ActivityDetailViewController else { return }
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? ActivityCollectionViewCell else { return }
        
        let activity = cell.activity
        destinationVC.activity = activity
//        let activity = activities[indexPath.row]
//        destinationVC.activity = activity
        navigationController?.pushViewController(destinationVC, animated: true)
    }
}

//MARK: - CollectionViewDelegateFlowLayout

extension ActivityListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        return CGSize(width: width - 40, height: width + 60)
    }
    
}

//MARK: - Extensions

extension ActivityListViewController: ActivityCollectionViewCellDelegate {
    func updateBucketListStatus(activity: Activity, favoriteStatus: Bool) {
        if favoriteStatus {
            BLActivityController.shared.addToBucketList(activity: activity)
        }else{
            BLActivityController.shared.removeFromBucketList(activity: activity)
        }
    }
}
