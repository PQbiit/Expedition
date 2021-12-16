//
//  City.swift
//  Expedition
//
//  Created by Luis Alfonso Arriaga Quezada on 30/11/21.
//

import UIKit

struct City: Codable{
    let id: Int
    let name: String
    let description: String?
    let latitude: Double
    let longitude: Double
    let coverImageURL: String
    let country: Country
    var coverImage: UIImage?
    
    struct Country: Codable {
        let name: String
        let code: String

        enum CodingKeys: String, CodingKey {
            case name
            case code = "iso_code"
        }
    }

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case latitude
        case longitude
        case description = "content"
        case coverImageURL = "cover_image_url"
        case country
    }

}

//let citiesArr = try JSONDecoder().decode([City].self, from: json!)
