//
//  Enums.swift
//  Enums
//
//  Created by Tino on 15.08.2021..
//

import Foundation

enum WeekDay: String {
    case mon = "Mon"
    case tue = "Tue"
    case wed = "Wed"
    case thu = "Thu"
    case fri = "Fri"
    case sat = "Sat"
    case sun = "Sun"
    
    func toString() -> String {
        switch self {
        case .mon:
          return "Monday"
        case .tue:
          return "Tuesday"
        case .wed:
          return "Wednesday"
        case .thu:
          return "Thursday"
        case .fri:
          return "Friday"
        case .sat:
          return "Saturday"
        case .sun:
          return "Sunday"
        }
    }
}


enum ForecastType {
    case city
    case forecast
}
