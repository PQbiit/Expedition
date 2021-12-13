//
//  CityListViewController.swift
//  Expedition
//
//  Created by Luis Alfonso Arriaga Quezada on 08/12/21.
//

import UIKit

class CityListViewController: UIViewController {

    //MARK: - IBOutlets
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var cityCollectionView: UICollectionView!
    
    //MARK: - Attributes
    var cities: [City] = []
    
    //MARK: - Life cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cityCollectionView.delegate = self
        cityCollectionView.dataSource = self
        cityCollectionView.register((UINib(nibName: "CityCollectionViewCell", bundle: nil)), forCellWithReuseIdentifier: "cityCell")
        fetchAvailableCities()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }

    //MARK: - Helper Methods
    
    func fetchAvailableCities() {
        CityController.shared.fetchCities { [weak self] (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let cities):
                    self?.cities = cities
                    self?.cityCollectionView.reloadData()
                case .failure(let error):
                    self?.presentErrorAlert(error: error)
                }
            }
        }
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
}

//MARK: - CollectionView Data Source & Delegate Methods

extension CityListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cities.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cityCell", for: indexPath) as? CityCollectionViewCell else { return UICollectionViewCell()}
        let city = cities[indexPath.row]
        cell.city = city
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CityCollectionViewCell,
              let city = cell.city,
              let coverPhoto = cell.coverPhoto
              else { return }
        let destinationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "cityDetailsVC") as CityDetailViewController
        destinationVC.city = city
        destinationVC.coverPhoto = coverPhoto
        navigationController?.pushViewController(destinationVC, animated: true)
    }

}

//MARK: - CollectionViewDelegateFlowLayout

extension CityListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width / 2
        return CGSize(width: width - 25, height: width + 40)
    }
}

//MARK: - Extensions
