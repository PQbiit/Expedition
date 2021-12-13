//
//  ActivityController.swift
//  Expedition
//
//  Created by Luis Alfonso Arriaga Quezada on 10/12/21.
//

import UIKit

class ActivityController {
    static let shared = ActivityController()
    
    private struct APIConstants {
        
        static let baseURL = URL(string: "https://sandbox.musement.com/api/v3/cities/")
        static let mediaBaseURL = URL(string: "https://sandbox.musement.com/api/v3/activities/")
        
        static let activitiesPath = "activities"
        static let mediaPath = "media"
        
        static let cityIDKey = "cityId"
        static let verticalKey = "vertical"
        static let limitKey = "limit"
        static let paginationOffSetKey = "limit"
        static let sortByKey = "sort_by"
        
        static let limitValue = "20"
        static let sortByRatingValue = "rating"
        static let sortByRelevanceValue = "relevance"
        
    }
    
    //Fetch activities without aplying category filtering
    func fetchActivitiesForCity(cityID: String, paginationOffSet: Int, completion: @escaping (Result<[Activity],NetworkError>) -> Void) {
        guard let baseURL = APIConstants.baseURL?.appendingPathComponent(cityID).appendingPathComponent(APIConstants.activitiesPath) else { return completion(.failure(.invalidURL)) }
        
        let queryItems = [URLQueryItem(name: APIConstants.limitKey, value: APIConstants.limitValue),
                          URLQueryItem(name: APIConstants.sortByKey, value: APIConstants.sortByRelevanceValue)]
        
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        components?.queryItems = queryItems
        
        guard let finalURL = components?.url else { return completion(.failure(.invalidURL)) }
        
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n\(error)")
                return completion(.failure(.thrownError(error)))
            }
            
            guard let data = data else { return completion(.failure(.noData)) }
            
            do{
                let activitiesData = try JSONDecoder().decode(CityAtivities.self, from: data)
                let activitiesArr = activitiesData.activities
                return completion(.success(activitiesArr))
            }catch {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n\(error)")
                return completion(.failure(.thrownError(error)))
            }
            
        }.resume()
        
    }
    
    //Fetch activities aplying CATEGORY FILTERING
    func fetchActivitiesForCityWithCategory(cityID: String, categoryID: String, paginationOffSet: Int, completion: @escaping () -> Void) {
        
    }
    
    //Fetch Top 10 activities for city
    func fetchTop10ActivitiesForCity(cityID: String, completion: @escaping () -> Void) {
        
    }
    
    //Fetch image for provided image URL
    func fetchPhotoFor(url: String, completion: @escaping (UIImage?) -> Void) {
        guard let photoURL = URL(string: url) else {
            print("Error formating: \(url) URL!")
            return completion(nil) }
        URLSession.shared.dataTask(with: photoURL) { (data, _, error) in
            if let error = error {
                print(error,error.localizedDescription)
                return completion(nil)
            }
            guard let data = data,
                  let coverPhoto = UIImage(data: data)
                  else { return completion(nil) }
            
            return completion(coverPhoto)
            
        }.resume()
    }
    
    //Fetch all activity media data
    func fetchMediaFor(activityID: String, completion: @escaping (Result<[ActivityMedia],NetworkError>) -> Void) {
        guard let finalURL = APIConstants.mediaBaseURL?.appendingPathComponent(activityID).appendingPathComponent(APIConstants.mediaPath) else { return completion(.failure(.invalidURL)) }

        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n\(error)")
                return completion(.failure(.thrownError(error)))
            }
            
            guard let data = data else {
                return completion(.failure(.noData))
            }
            
            do{
                let mediaDataArr = try JSONDecoder().decode([ActivityMedia].self, from: data)
                return completion(.success(mediaDataArr))
            }catch {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n\(error)")
                return completion(.failure(.unableToDecode))
            }
            
        }.resume()
        
    }
    
}
