//
//  ProfileViewController.swift
//  Expedition
//
//  Created by Luis Alfonso Arriaga Quezada on 13/12/21.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var savedActivitiesCountLbl: UILabel!
    @IBOutlet weak var favoriteCitiesCountLbl: UILabel!
    @IBOutlet weak var favoriteCitiesCollectionView: UICollectionView!
    @IBOutlet weak var activitiesBucketListCollectionView: UICollectionView!
    
    var sampleActitities: [BLActivity] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favoriteCitiesCollectionView.delegate = self
        favoriteCitiesCollectionView.dataSource = self
        activitiesBucketListCollectionView.delegate = self
        activitiesBucketListCollectionView.dataSource = self
        favoriteCitiesCollectionView.register(UINib(nibName: "CityCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cityCell")
        activitiesBucketListCollectionView.register(UINib(nibName: "SmallActivityCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "smallActivityCell")
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupViews()
        favoriteCitiesCollectionView.reloadData()
        activitiesBucketListCollectionView.reloadData()
    }
    
    func setupViews() {
        guard let user = UserController.shared.currentUser else { return }
        userProfileImageView.layer.cornerRadius = userProfileImageView.frame.height / 2
        BLCityController.shared.fetchFavoriteCities()
        BLActivityController.shared.fetchActivitiesBucketList()
        getSampleActivities()
        userProfileImageView.image = user.profilePhoto
        userNameLbl.text = "\(user.firstName) \(user.middleName ?? "") \(user.lastName)"
        favoriteCitiesCountLbl.text = "\(BLCityController.shared.favoriteCities.count)"
        savedActivitiesCountLbl.text = "\( BLActivityController.shared.activitiesInBucketlist())"
    }
    
    func getSampleActivities() {
        sampleActitities = []
        for cat in BLActivityController.shared.activitiesBucketList {
            if sampleActitities.count <= 10 {
                let activity = cat[0]
                sampleActitities.append(activity)
            }
        }
    }
    
    @IBAction func optionsButtonTapped(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: Strings.UDSavedUserEmailKey)
        UserDefaults.standard.synchronize()
        let authNavViewController = UIStoryboard(name: "Authentication", bundle: nil).instantiateViewController(identifier: Strings.authNavigationController)
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(authNavViewController)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.favoriteCitiesCollectionView {
            return BLCityController.shared.favoriteCities.count
        }
        return sampleActitities.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.favoriteCitiesCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cityCell", for: indexPath) as? CityCollectionViewCell else { return UICollectionViewCell() }
            let city = BLCityController.shared.favoriteCities[indexPath.row]
            cell.blCity = city
            return cell
        }else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "smallActivityCell", for: indexPath) as? SmallActivityCollectionViewCell else { return UICollectionViewCell() }
            let activity = sampleActitities[indexPath.row]
            cell.blActivity = activity
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
}

extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width / 2
        return CGSize(width: width - 15, height: width + 60)
    }
}
