//
//  Activity.swift
//  Expedition
//
//  Created by Luis Alfonso Arriaga Quezada on 01/12/21.
//

import Foundation

struct CityAtivities: Codable{
    let activities: [Activity]
    enum CodingKeys: String, CodingKey {
        case activities = "data"
    }
}

struct Activity: Codable {
    let id: String
    let title: String
    let description: String
    let about: String
    let coverImageURL: String
    let latitude: Double
    let longitude: Double
    let musementURL: String
    let categories: [Category]
    let retailPrice: RetailPrice
    let serviceFee: ServiceFee
    
    struct RetailPrice: Codable {
        let currency: String
        let value: Int
    }

    struct ServiceFee: Codable {
        let currency: String
        let value: Int
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "uuid"
        case title
        case description
        case about
        case coverImageURL = "cover_image_url"
        case latitude
        case longitude
        case musementURL = "url"
        case categories = "verticals"
        case retailPrice = "retail_price"
        case serviceFee = "service_fee"
    }
    
}

struct ActivityMedia: Codable {
    let type: String
    let imageURL: String
    
    enum codingKeys: String, CodingKey {
        case type
        case imageURL = "url"
    }
    
}
