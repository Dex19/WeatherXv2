//
//  API.swift
//  API
//
//  Created by Tino on 16.08.2021..
//

import Foundation

final class API {
    
    static let shared = API()

    private let timeConversionService = TimeConversionService()


    func formatDay(date: String) -> WeekDay {
      return timeConversionService.formatDay(date: date)
    }
    
    func formatDateFromUnixDate(unixDate: Int) -> String {
      return timeConversionService.formatDateFromUnixDate(unixDate: unixDate)
    }
    
    func getStringTimeFromUnixDate(unixDate: Int) -> String {
      return timeConversionService.getStringTimeFromUnixDate(unixDate: unixDate)
    }
    
    
}
