//
//  SelectedMode.swift
//  Interesting numbers
//
//  Created by AS on 21.09.2023.
//

import UIKit

enum SelectedMode: String {
    case userNumber = "userNumber"
    case randomNumber = "randomNumber"
    case numberInRange = "numberInRange"
    case multipleNumbers = "multipleNumbers"
    
    var placeholderText: String {
        switch self {
        case .userNumber:
            return "Just write any number here..."
        case .multipleNumbers:
            return "Write several numbers separated by a comma"
        case .randomNumber:
            return "Click the button below"
        case .numberInRange:
            return "Write the range by a comma (min,max)"
        }
    }
}
