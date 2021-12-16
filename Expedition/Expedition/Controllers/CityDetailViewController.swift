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
    @IBOutlet weak var favoriteBlurView: UIVisualEffectView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var showActivitiesButtonContainer: UIView!
    @IBOutlet weak var showActivitiesButton: UIButton!
    
    //MARK: - Attributes
    
    var city: City?
    var coverPhoto: UIImage?
    var isFavorite: Bool = false
    var top10Activities: [Activity] = []
    
    //MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BLCityController.shared.fetchFavoriteCities()
        fetchTop10ctivities()
        setupViews()
        tabBarController?.tabBar.isHidden = true
    }
    
    //MARK: - Helper Methods
    
    func setupViews() {
        coverPhotoContainer.clipsToBounds = true
        coverPhotoContainer.layer.cornerRadius = 20
        favoriteBlurView.layer.cornerRadius = favoriteBlurView.frame.height / 2.0
        backBlurView.layer.cornerRadius = backBlurView.frame.height / 2.0
        backBlurView.clipsToBounds = true
        favoriteBlurView.clipsToBounds = true
        favoriteButton.layer.cornerRadius = favoriteButton.frame.height / 2
        backButton.layer.cornerRadius = backButton.frame.height / 2
        showActivitiesButtonContainer.layer.cornerRadius = showActivitiesButtonContainer.frame.height / 2
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "SmallActivityCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "smallActivityCell")
        
        guard let city = city,
              let coverPhoto = coverPhoto
              else { return }
        isFavorite = BLCityController.shared.isFavoriteCity(cityID: city.id)
        setupFavoriteButtonIcon()
        cityCoverImageView.image = coverPhoto
        titleLbl.text = "\(city.name), \(city.country.name)"
        descriptionLbl.text = city.description
        showActivitiesButton.setTitle("Explore activities in \(city.name)", for: .normal)
    }
    
    func setupFavoriteButtonIcon() {
        if isFavorite {
            favoriteButton.setImage(UIImage(systemName: Strings.heartFull), for: .normal)
        }else {
            favoriteButton.setImage(UIImage(systemName: Strings.heartEmpty), for: .normal)
        }
    }
    
    func fetchTop10ctivities() {
        guard let city = city else { return }
        ActivityController.shared.fetchTop10ActivitiesForCity(cityID: String(city.id)) { [weak self] (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let activities):
                    self?.top10Activities = activities
                    self?.collectionView.reloadData()
                case .failure(let error):
                    self?.presentErrorAlert(error: error)
                }
            }
        }
        
    }

    //MARK: - IBActions
    
    @IBAction func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func showActivitiesButtonTapped(_ sender: Any) {
        let destinationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "activitiesListVC") as ActivityListViewController
        guard let city = city else { return }
        
        destinationVC.cityID = String(city.id)
        destinationVC.cityName = city.name
        navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    @IBAction func likeButtonTapped(_ sender: Any) {
        guard let city = city else { return }
        if isFavorite {
            //removeFromFavs
            BLCityController.shared.removeFavoriteCity(city: city)
        }else{
            //AddToFavs
            BLCityController.shared.addFavoriteCity(city: city)
        }
        isFavorite = !isFavorite
        setupFavoriteButtonIcon()
    }
}

//MARK: - CollectionView Data Source & Delegate Methods
extension CityDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return top10Activities.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "smallActivityCell", for: indexPath) as? SmallActivityCollectionViewCell else { return UICollectionViewCell() }
        let activity = top10Activities[indexPath.row]
        cell.activity = activity
        return cell
    }
    
}


//MARK: - CollectionViewDelegateFlowLayout
extension CityDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width / 2
        return CGSize(width: width - 15, height: width + 20)
    }
}


//MARK: - Extensions
