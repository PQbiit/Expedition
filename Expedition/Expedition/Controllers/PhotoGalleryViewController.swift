//
//  PhotoGalleryViewController.swift
//  Expedition
//
//  Created by Luis Alfonso Arriaga Quezada on 12/12/21.
//

import UIKit

class PhotoGalleryViewController: UIViewController {

    @IBOutlet weak var photoGalleryCollectionView: UICollectionView!
    
    var activityMedia: [ActivityMedia] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: false)
        photoGalleryCollectionView.delegate = self
        photoGalleryCollectionView.dataSource = self
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }

}

extension PhotoGalleryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return activityMedia.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as? PhotoGalleryCollectionViewCell else { return UICollectionViewCell() }
        let media = activityMedia[indexPath.row]
        if media.type == "image" {
            cell.photoURL = media.url
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension PhotoGalleryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.view.frame.width / 2
        return CGSize(width: width - 15, height: width - 15)
    }
}
