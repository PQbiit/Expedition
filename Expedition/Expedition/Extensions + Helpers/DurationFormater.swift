//
//  DurationFormater.swift
//  Expedition
//
//  Created by Luis Alfonso Arriaga Quezada on 11/12/21.
//

import Foundation

extension DateComponents {
    
    static func formatDurationfrom(durationString: String) -> DateComponents? {
        guard durationString.starts(with: "P") else { return nil }
        
        let durationString = String(durationString.dropFirst())
        var dateComponents = DateComponents()
        
        let tRange = (durationString as NSString).range(of: "T", options: .literal)
        let timeString: String
        if tRange.location == NSNotFound {
            timeString = ""
        } else {
            timeString = (durationString as NSString).substring(from: tRange.location + 1)
        }
        
        let timeValues = componentsForString(timeString, designatiorSet: CharacterSet(charactersIn: "HMS"))
        dateComponents.minute = Int(timeValues["M"] ?? "")
        dateComponents.hour = Int(timeValues["H"] ?? "")
        
        return dateComponents
        
    }
    
    private static func componentsForString(_ string: String, designatiorSet: CharacterSet) -> [String:String] {
        if string.isEmpty { return [:] }
        
        let componentValues = string.components(separatedBy: designatiorSet).filter({!$0.isEmpty})
        let designatorValues = string.components(separatedBy: .decimalDigits).filter({!$0.isEmpty})
        
        guard componentValues.count == designatorValues.count else {
            //STRING HAS INVALID FORMAT
            return [:]
        }
        
        return Dictionary(uniqueKeysWithValues: zip(designatorValues, componentValues))
        
    }
    
}
