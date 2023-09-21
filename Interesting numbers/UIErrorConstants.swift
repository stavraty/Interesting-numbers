//
//  UIErrorConstants.swift
//  Interesting numbers
//
//  Created by AS on 21.09.2023.
//

import UIKit

enum UIErrorConstants: Error {
    case emptyNumber
    case emptyRange
    case unknownMode
    case invalidRangeFormat
    case invalidRangeValues
    case networkError
    
    var title: String {
        return "Error"
    }
    
    var message: String {
        switch self {
        case .emptyNumber:
            return "User number is empty"
        case .emptyRange:
            return "The range is empty"
        case .unknownMode:
            return "Unknown mode"
        case .invalidRangeFormat:
            return "Invalid range format. Required format: min,max"
        case .invalidRangeValues:
            return "The second number must be greater than the first"
        case .networkError:
            return "Network error. Check your internet connection"
        }
    }
}
