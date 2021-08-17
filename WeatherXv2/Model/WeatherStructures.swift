//
//  WeatherStructure.swift
//  WeatherStructure
//
//  Created by Tino on 14.08.2021..
//

import Foundation
import SwiftUI

struct CityInfo {
    var name: String?
    var country: String?
    var cityForecast = [WeatherForecastModel]()
}

struct WeatherForecastModel: Identifiable {
    var id: Int
    var day: WeekDay?
    var fullDate: String?
    var temp: String?
    var weather: String?
    var description: String?
    var image: String = "cloud.sun.rain.fill"
    var city: String = ""
    
}

struct WeatherCityModel {
    var cityId: Int = 0
    var city: String = ""
    var temp: String = ""
    var tempMin: String = ""
    var tempMax: String = ""
    var feelsLike: String = ""
    var humidity: String = ""
    var weather: String = ""
    var description: String = ""
    var country: String = ""
    var sunrise: String = "00:00"
    var sunset: String = "00:00"
    var date: String = "DD-MM-YYYY"
    var image: UIImage = #imageLiteral(resourceName: "Clouds Mini")
    var systemImage: String = "cloud.sun.rain.fill"
    var backgroundImage: UIImage = #imageLiteral(resourceName: "Snow-1")
}
