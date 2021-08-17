//
//  JsonStructures.swift
//  JsonStructures
//
//  Created by Tino on 09.08.2021..
//

import Foundation

struct ForecastData: Decodable {
    let list: [CityData]?
    let city: CityForecastData?
}

struct CityData: Decodable {
    let id: Int?
    let name: String?
    let cod: Int?
    let dt_txt: String?
    let dt: Int?
    let weather: [WeatherData]?
    let main: MainData?
    let sys: sysData?
}

struct CityForecastData: Decodable {
    let name: String?
    let country: String?
}

struct WeatherData: Decodable {
    let main: String?
    let description: String?
}

struct MainData: Decodable {
    let temp: Double?
    let temp_min: Double?
    let temp_max: Double?
    let feels_like: Double?
    let humidity: Int?
}

struct sysData: Decodable {
    let country: String?
    let sunrise: Int?
    let sunset: Int?
}
