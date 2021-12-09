//
//  CityController.swift
//  Expedition
//
//  Created by Luis Alfonso Arriaga Quezada on 08/12/21.
//

import UIKit

class CityController {
    static let shared = CityController()
    
    private struct APIConstants {
        static let baseURL = URL(string: "https://sandbox.musement.com/api/v3/cities")
        static let limitKey = "limit"
        static let limitValue = "100"
    }
    
    //Fetch all cities supported by Musement API
    func fetchCities(completion: @escaping (Result<[City],NetworkError>) -> Void) {
        guard let baseURL = APIConstants.baseURL else { return completion(.failure(.invalidURL)) }
        let queries = [URLQueryItem(name: APIConstants.limitKey, value: APIConstants.limitValue)]
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        components?.queryItems = queries
        
        guard let finalURL = components?.url else { return completion(.failure(.invalidURL)) }
        
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            
            guard let data = data else { return completion(.failure(.noData)) }
            
            do{
                let citiesArr = try JSONDecoder().decode([City].self, from: data)
                return completion(.success(citiesArr))
            }catch {
                return completion(.failure(.unableToDecode))
            }
            
        }.resume()
        
    }
    
    //Fetch cover photo for provided city
    func fetchCoverPhotofor(coverPhotoURL: String, completion: @escaping (UIImage?) -> Void) {
        guard let photoURL = URL(string: coverPhotoURL) else {
            print("Error formating: \(coverPhotoURL) URL!")
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
    
}
