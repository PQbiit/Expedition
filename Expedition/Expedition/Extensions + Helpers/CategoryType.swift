//
//  CategoryType.swift
//  Expedition
//
//  Created by Luis Alfonso Arriaga Quezada on 10/12/21.
//

import UIKit

enum CategoryType {
    case id1
    case id2
    case id3
    case id4
    case id5
    case id6
    case id7
    
    var icon: UIImage {
        switch self {
            case .id1:
                return UIImage(named: "museum")!
            case .id2:
                return UIImage(named: "tour")!
            case .id3:
                return UIImage(named: "food")!
            case .id4:
                return UIImage(named: "performance")!
            case .id5:
                return UIImage(named: "london")!
            case .id6:
                return UIImage(named: "active")!
            case .id7:
                return UIImage(named: "nightlife")!
        }
    }
    
}
