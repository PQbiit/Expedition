//
//  ActivityDetailViewController.swift
//  Expedition
//
//  Created by Luis Alfonso Arriaga Quezada on 11/12/21.
//

import UIKit
import MapKit

class ActivityDetailViewController: UIViewController {

    //MARK: - IBOutlets
    
    @IBOutlet weak var activityCoverContainer: UIView!
    @IBOutlet weak var backBlurContainer: UIVisualEffectView!
    @IBOutlet weak var saveToBucketListBlurContainer: UIVisualEffectView!
    @IBOutlet weak var photoGalleryBlurContainer: UIVisualEffectView!
    @IBOutlet weak var durationBlurContainer: UIVisualEffectView!
    @IBOutlet weak var ratingBlurContainer: UIVisualEffectView!
    @IBOutlet weak var saveToBucketListButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var activityCoverImageView: UIImageView!
    @IBOutlet weak var photoGalleryImageView: UIImageView!
    @IBOutlet weak var activityTitleLbl: UILabel!
    @IBOutlet weak var ActivityPriceLbl: UILabel!
    @IBOutlet weak var activityDurationLbl: UILabel!
    @IBOutlet weak var activityRatingLbl: UILabel!
    @IBOutlet weak var activityDescriptionLbl: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var photoCountLbl: UILabel!
    @IBOutlet weak var noLocationView: UIView!
    
    @IBOutlet weak var locationTitleLbl: UILabel!
    @IBOutlet weak var topNoLocationViewConstraint: NSLayoutConstraint!
    
    //MARK: - Attributes
  
    var activity: Activity?
    var activityMedia: [ActivityMedia] = []
    
    //MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoGalleryBlurContainer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(presentPhotoGallery)))
        mapView.delegate = self
        fetchMediaLinks()
        updateViews()
        updateMap()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    //MARK: - Helper Methods
    
    func updateViews() {
        photoGalleryBlurContainer.layer.cornerRadius = 20
        photoGalleryImageView.layer.cornerRadius = 20
        activityCoverContainer.layer.cornerRadius = 20
        backBlurContainer.layer.cornerRadius = backBlurContainer.frame.height / 2.0
        saveToBucketListBlurContainer.layer.cornerRadius = saveToBucketListBlurContainer.frame.height / 2.0
        backButton.layer.cornerRadius = backButton.frame.height / 2.0
        saveToBucketListButton.layer.cornerRadius = saveToBucketListButton.frame.height / 2.0
        durationBlurContainer.layer.cornerRadius = 10
        ratingBlurContainer .layer.cornerRadius = 10

        activityCoverContainer.clipsToBounds = true
        backBlurContainer.clipsToBounds = true
        saveToBucketListBlurContainer.clipsToBounds = true
        durationBlurContainer.clipsToBounds = true
        ratingBlurContainer.clipsToBounds = true
        photoGalleryBlurContainer.clipsToBounds = true
        
        guard let activity = activity else { return }
        activityTitleLbl.text = activity.title
        ActivityPriceLbl.text = "$ \(activity.retailPrice.value)"
        activityRatingLbl.text = "\(activity.rating)"
        activityDescriptionLbl.text = activity.about
        activityCoverImageView.image = activity.coverImage ?? UIImage(systemName: "expeditionLogo")
        if let duration = activity.duration?.max {
            activityDurationLbl.text = formatDuration(duration: duration)
        }else{
            activityDurationLbl.text = "No info available"
        }
        
    }
    
    func updateMap() {
        guard let activity = activity,
              let lat = activity.latitude,
              let lon = activity.longitude
              else {
            mapView.isHidden = true
            noLocationView.isHidden = false
            return
        }
        mapView.isHidden = false
        noLocationView.isHidden = true
        topNoLocationViewConstraint.isActive = false
        mapView.topAnchor.constraint(equalTo: locationTitleLbl.bottomAnchor, constant: 10.0).isActive = true
        mapView.centerToLocation(latitude: lat, longitude: lon)
        let activityPin = ActivityMapPin(title: activity.title, coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon))
        mapView.addAnnotation(activityPin)
    }
    
    func formatDuration(duration: String) -> String {
        var formatedDuration = ""
        let components = DateComponents.formatDurationfrom(durationString: duration)
        if let hours = components?.hour {
            formatedDuration += (hours > 1 ? "\(hours) hours " : "\(hours) hour ")
        }
        if let mins = components?.minute {
            formatedDuration += (mins > 1 ? "\(mins) mins" : "\(mins) min")
        }
        return formatedDuration
    }
    
    @objc func presentPhotoGallery() {
        guard let destinationVC = UIStoryboard(name: "ActivityPhotoGallery", bundle: nil).instantiateViewController(withIdentifier: "activityPhotoGallery") as? PhotoGalleryViewController,
              activityMedia.count > 0
        else { return }
        destinationVC.activityMedia = activityMedia
        navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    func fetchMediaLinks() {
        guard let activity = activity else { return }
        ActivityController.shared.fetchMediaFor(activityID: activity.id) { [weak self] (result) in
            DispatchQueue.main.async {
                switch result {
                    case .success(let mediaData):
                        if mediaData.count > 0 {
                            self?.photoCountLbl.text = mediaData.count < 100 ? "+\(mediaData.count)" : "+99"
                            self?.activityMedia = mediaData
                            let url = mediaData[0].url
                            ActivityController.shared.fetchPhotoFor(url: url) { (image) in
                                guard let image = image else { return }
                                DispatchQueue.main.async {
                                    self?.photoGalleryImageView.image = image
                                }
                            }
                        }else{
                            self?.photoCountLbl.text = "No images"
                        }
                        
                    case .failure(let error):
                        self?.presentErrorAlert(error: error)
                }
            }
        }
    }
    
    //MARK: - IBOutlets
    
    @IBAction func saveToBucketListButtonTapped(_ sender: Any) {
        
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}

extension ActivityDetailViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? ActivityMapPin else { return nil }
        
        let identifier = "activityPin"
        var view: MKMarkerAnnotationView
        
        if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
            annotationView.annotation = annotation
            view = annotationView
        }else{
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        
        return view
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let activityMapPin = view.annotation as? ActivityMapPin else { return }
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        activityMapPin.mapItem?.openInMaps(launchOptions: launchOptions)
    }
    
}
