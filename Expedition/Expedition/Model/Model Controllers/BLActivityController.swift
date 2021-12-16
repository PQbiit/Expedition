//
//  BLActivityController.swift
//  Expedition
//
//  Created by Luis Alfonso Arriaga Quezada on 15/12/21.
//

import Foundation
import CoreData

class BLActivityController {
    static let shared = BLActivityController()
    
    private lazy var fetchRequest: NSFetchRequest<BLActivity> = {
        let request = NSFetchRequest<BLActivity>(entityName: "BLActivity")
        request.predicate = NSPredicate(value: true)
        return request
    }()
    
    var activitiesBucketList: [[BLActivity]] = []
    
    func fetchActivitiesBucketList() {
        activitiesBucketList = []
        guard let blItems = try? CoreDataStack.context.fetch(fetchRequest) else { return }
        let cities = Set(blItems.map({$0.cityName}))
        for city in cities {
            let sub = blItems.filter({$0.cityName == city})
            activitiesBucketList.append(sub)
        }
    }
    
    func addToBucketList(activity: Activity) {
        let latitude = activity.latitude ?? 0
        let longitude = activity.longitude ?? 0
        let imageData = activity.coverImage?.jpegData(compressionQuality: 0.5)
        let blActivity = BLActivity(id: activity.id, title: activity.title, activityDescription: activity.description, about: activity.about, coverImageData: imageData, latitude: latitude, longitude: longitude, musementURL: activity.musementURL, retailPrice: activity.retailPrice.value, serviceFee: activity.serviceFee.value, duration: activity.duration?.max, rating: activity.rating, cityName: activity.city.name, countryName: activity.city.country.name, context: CoreDataStack.context)
        
        for (index, cat) in activitiesBucketList.enumerated() {
            if cat[0].cityName == blActivity.cityName{
                activitiesBucketList[index].append(blActivity)
                CoreDataStack.saveToPersistenStorage()
                return
            }
        }
        activitiesBucketList.append([blActivity])
        CoreDataStack.saveToPersistenStorage()
    }
    
    func removeFromBucketList(activity: Activity) {
        let actID = activity.id
        for (index,cat) in activitiesBucketList.enumerated() {
            if let targetIndex = cat.firstIndex(where: {$0.id == actID}) {
                let targetActivity = cat[targetIndex]
                guard let moc = targetActivity.managedObjectContext else { return }
                moc.delete(targetActivity)
                activitiesBucketList[index].remove(at: targetIndex)
                if activitiesBucketList[index].count == 0 {
                    activitiesBucketList.remove(at: index)
                }
                CoreDataStack.saveToPersistenStorage()
            }
        }
    }
    
    func isFavoriteActivity(activity: Activity) -> Bool {
        let actID = activity.id
        for cat in activitiesBucketList {
            if cat.contains(where: {$0.id == actID}) {
                return true
            }
        }
        return false
    }
    
    func activitiesInBucketlist() -> Int {
        var counter = 0
        for cat in activitiesBucketList {
            counter += cat.count
        }
        return counter
    }
    
}
