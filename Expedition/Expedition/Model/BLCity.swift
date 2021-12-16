//
//  BLCity.swift
//  Expedition
//
//  Created by Luis Alfonso Arriaga Quezada on 14/12/21.
//

import Foundation
import CoreData

extension BLCity {
    @discardableResult convenience init(id: Int64, name: String, cityDescription: String?, countryName: String, coverImageData: Data?, context: NSManagedObjectContext) {
        self.init(context: context)
        self.id = id
        self.name = name
        self.cityDescription = cityDescription
        self.countryName = countryName
        self.coverImageData = coverImageData
    }
}
