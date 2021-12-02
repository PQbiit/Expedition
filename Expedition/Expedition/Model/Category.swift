//
//  Category.swift
//  Expedition
//
//  Created by Luis Alfonso Arriaga Quezada on 01/12/21.
//

import Foundation

//CATEGORY represents VERTICAL in object JSON
struct Category: Codable {
    let id: Int
    let name: String
    let title: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case title = "meta_title"
    }
}

//let categoriesArr = try JSONDecoder().decode([Category].self, from: json!)
