//
//  CategoryController.swift
//  Expedition
//
//  Created by Luis Alfonso Arriaga Quezada on 09/12/21.
//

import Foundation

class CategoryController {
    static let shared = CategoryController()
    
    private struct APIConstants {
        static let baseURL = URL(string: "https://sandbox.musement.com/api/v3/cities")
        static let verticalsPath = "verticals"
    }
    
    func fetchActivityCategoriesFor(cityID: String, completion: @escaping (Result<[Category],NetworkError>) -> Void) {
        guard let baseURL = APIConstants.baseURL else { return completion(.failure(.invalidURL)) }
        let finalURL = baseURL.appendingPathComponent(cityID).appendingPathComponent(APIConstants.verticalsPath)
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            
            guard let data = data else { return completion(.failure(.noData)) }
            
            do{
                let categoriesArr = try JSONDecoder().decode([Category].self, from: data)
                return completion(.success(categoriesArr))
            }catch {
                return completion(.failure(.unableToDecode))
            }
            
        }.resume()
    }
    
    
    
}
