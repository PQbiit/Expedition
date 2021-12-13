//
//  MapKit Extension.swift
//  Expedition
//
//  Created by Luis Alfonso Arriaga Quezada on 12/12/21.
//

import MapKit

extension MKMapView {
    func centerToLocation(latitude: Double, longitude: Double) {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        setRegion(coordinateRegion, animated: true)
        
    }
}
