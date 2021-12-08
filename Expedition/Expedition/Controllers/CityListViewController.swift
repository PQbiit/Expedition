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
    
    
    //MARK: - Life cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cityCollectionView.delegate = self
        cityCollectionView.dataSource = self
        cityCollectionView.register((UINib(nibName: "CityCollectionViewCell", bundle: nil)), forCellWithReuseIdentifier: "cityCell")
    }
    
    //MARK: - Helper Methods
    
    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
}

//MARK: - CollectionView Data Source & Delegate Methods
extension CityListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cityCell", for: indexPath) as? CityCollectionViewCell else { return UICollectionViewCell()}
        return cell
        
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
