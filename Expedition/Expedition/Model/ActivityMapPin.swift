//
//  ActivityMapPin.swift
//  Expedition
//
//  Created by Luis Alfonso Arriaga Quezada on 12/12/21.
//

import Foundation
import MapKit
import Contacts

class ActivityMapPin: NSObject, MKAnnotation {
    let title: String?
    let coordinate: CLLocationCoordinate2D
    
    var mapItem: MKMapItem? {
        let placeMark = MKPlacemark(coordinate: coordinate)
        let mapItem = MKMapItem(placemark: placeMark)
        mapItem.name = title
        return mapItem
    }
    
    init(title: String?, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
        super.init()
    }
    
}
