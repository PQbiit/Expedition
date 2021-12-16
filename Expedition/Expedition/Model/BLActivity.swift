//
//  BLActivity.swift
//  Expedition
//
//  Created by Luis Alfonso Arriaga Quezada on 14/12/21.
//

import Foundation
import CoreData

extension BLActivity {
    @discardableResult convenience init(id: String, title: String, activityDescription: String?, about: String, coverImageData: Data?, latitude: Double, longitude: Double, musementURL: String, retailPrice: Double, serviceFee: Double, duration: String?, rating: Double, cityName: String, countryName: String, context: NSManagedObjectContext) {
        self.init(context: context)
        self.id = id
        self.title = title
        self.activityDescription = activityDescription
        self.about = about
        self.coverImageData = coverImageData
        self.latitude = latitude
        self.longitude = longitude
        self.musementURL = musementURL
        self.retailPrice = retailPrice
        self.serviceFee = serviceFee
        self.duration = duration
        self.rating = rating
        self.cityName = cityName
        self.countryName = countryName
    }
}
