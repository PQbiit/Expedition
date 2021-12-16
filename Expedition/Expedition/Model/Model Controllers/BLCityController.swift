//
//  BLCityController.swift
//  Expedition
//
//  Created by Luis Alfonso Arriaga Quezada on 14/12/21.
//

import Foundation
import CoreData

class BLCityController {
    static let shared = BLCityController()
    
    private lazy var fetchRequest: NSFetchRequest<BLCity> = {
        let request = NSFetchRequest<BLCity>(entityName: "BLCity")
        request.predicate = NSPredicate(value: true)
        return request
    }()
    
    var favoriteCities: [BLCity] = []
    
    func fetchFavoriteCities() {
        favoriteCities = (try? CoreDataStack.context.fetch(fetchRequest)) ?? []
    }
    
    func addFavoriteCity(city: City) {
        let imagedata = city.coverImage?.jpegData(compressionQuality: 0.5)
        let favCity = BLCity(id: Int64(city.id), name: city.name, cityDescription: city.description ?? "No description available", countryName: city.country.name, coverImageData: imagedata, context: CoreDataStack.context)
        favoriteCities.append(favCity)
        CoreDataStack.saveToPersistenStorage()
    }
    
    func removeFavoriteCity(city: City) {
        let cityID = Int64(city.id)
        guard let targetIndex = favoriteCities.firstIndex(where: {$0.id == cityID}) else { return }
        let targetCity = favoriteCities[targetIndex]
        guard let moc = targetCity.managedObjectContext else { return }
        moc.delete(targetCity)
        favoriteCities.remove(at: targetIndex)
        CoreDataStack.saveToPersistenStorage()
    }
    
    func isFavoriteCity(cityID: Int) -> Bool {
        return favoriteCities.contains(where: {$0.id == Int64(cityID)})
    }
    
}
