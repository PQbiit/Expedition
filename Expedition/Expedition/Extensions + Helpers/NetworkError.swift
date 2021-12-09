//
//  NetworkError.swift
//  Expedition
//
//  Created by Luis Alfonso Arriaga Quezada on 08/12/21.
//

import Foundation

enum NetworkError: LocalizedError {
    case invalidURL
    case thrownError(Error)
    case noData
    case unableToDecode
    
    var errorDescription: String? {
        switch self {
            case .invalidURL:
                return "Unable to reach the server due to a bad URL"
            case .thrownError(let error):
                return error.localizedDescription
            case .noData:
                return "Server responded with no data"
            case .unableToDecode:
                return "Unable to decode data"
        }
    }
    
}
