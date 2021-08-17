//
//  jsonParser.swift
//  jsonParser
//
//  Created by Tino on 13.08.2021..
//

import Foundation
import SwiftUI
import CoreLocation

class JsonParser: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    @Published var fetchedWeatherCityData = WeatherCityModel()
    @Published var fetchedWeatherForecastData = CityInfo()
    var lat = ""
    var lon = ""
    
    let manager = CLLocationManager()

    override init() {
        super.init()
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    func fetchLocationData() {
        
        let url = urlBuilder(forecastType: .city, latitude: lat, longitude: lon)
        
        jsonFetchDayData(url: url) { weatherCityData, error in
            if let safeError = error {
                print(safeError.localizedDescription)
            } else {
                if let safeWeatherCityData = weatherCityData {
                    DispatchQueue.main.async {
                        self.fetchedWeatherCityData = safeWeatherCityData
                    }
                }
            }
        }
    }
    
    func fetchForecastData() {

        let url = urlBuilder(forecastType: .forecast, latitude: lat, longitude: lon)
                
        jsonFetchForecastData(url: url) { cityInfo, error in
            if let safeError = error {
                print(safeError.localizedDescription)
            } else {
                DispatchQueue.main.async {
                    if let safeCityInfo = cityInfo {
                        self.fetchedWeatherForecastData = safeCityInfo
                    }
                }
            }
        }
    }
    
    private func jsonFetchDayData(url: URL, completion: @escaping (WeatherCityModel?, Error?) -> ()) {
        var weatherDayData = WeatherCityModel()
        
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in

            guard let data = data else {
                return
            }
            
            do {
                
                let json = try JSONDecoder().decode(CityData.self, from: data)
                
                var xMain = ""
                var xDescription = ""
                
                for x in json.weather ?? [] {
                    xMain = x.main!
                    xDescription = x.description!
                }
                
                weatherDayData.city = json.name ?? "N/A"
                weatherDayData.cityId = json.id ?? 0
                weatherDayData.description = xDescription
                weatherDayData.weather = xMain
                
                if let safeJsonMain = json.main {
                    weatherDayData.temp = self.kelvintoc(value: safeJsonMain.temp ?? 0)
                    weatherDayData.feelsLike = self.kelvintoc(value: safeJsonMain.feels_like ?? 0)
                    weatherDayData.tempMax = self.kelvintoc(value: safeJsonMain.temp_max ?? 0)
                    weatherDayData.tempMin = self.kelvintoc(value: safeJsonMain.temp_min ?? 0)
                    weatherDayData.humidity = "\(safeJsonMain.humidity ?? 0)%"
                }
                
                if let safeJsonSys = json.sys {
                    weatherDayData.country = safeJsonSys.country ?? "N/A"
                    weatherDayData.sunrise = API.shared.getStringTimeFromUnixDate(unixDate: safeJsonSys.sunrise ?? 0)
                    weatherDayData.sunset = API.shared.getStringTimeFromUnixDate(unixDate: safeJsonSys.sunset ?? 0)
                }
                
                weatherDayData.date = API.shared.formatDateFromUnixDate(unixDate: json.dt ?? 0)
                weatherDayData.image = self.getPicture(weather: xMain)
                weatherDayData.systemImage = self.pictureString(weather: xMain)
                weatherDayData.backgroundImage = self.getBackgroundPicture(weather: xMain)
                
                completion(weatherDayData, nil)
            }
            catch let error {
                completion(nil, error)
            }
        })
        task.resume()
    }
    
    
    private func jsonFetchForecastData(url: URL, completion: @escaping (CityInfo?, Error?) -> ()) {

        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        var cityInfo =  CityInfo()
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard let data = data else {
                return
            }
            
            do {
                let json = try JSONDecoder().decode(ForecastData.self, from: data)
                
                if let safeJsonCity = json.city {
                    cityInfo.name = safeJsonCity.name
                    cityInfo.country = safeJsonCity.country
                }
                
                if let safeJsonList = json.list {
                    
                    for (index, x) in safeJsonList.enumerated() {
                        
                        var weatherData = WeatherForecastModel(id: index)
                        
                        for n in x.weather!{
                            weatherData.weather = n.main!
                            weatherData.description = n.description!
                        }
                        weatherData.temp = self.kelvintoc(value: x.main!.temp!)
                        weatherData.day = API.shared.formatDay(date: x.dt_txt!)
                        weatherData.fullDate = API.shared.formatDateFromUnixDate(unixDate: x.dt ?? 0)
                        weatherData.image = self.pictureString(weather: weatherData.weather ?? "")
                        
                        cityInfo.cityForecast.append(weatherData)
                    }
                }
                completion(cityInfo, nil)
            }
            catch let error {
                completion(nil, error)
            }
            
        })
        task.resume()
    }
    
    
    // MARK: - Private Functions
    
    private func kelvintoc(value: Double) -> String {
        let celsius = value - 273.15
        let strcel = String(format: "%.0f", celsius)
        
        return strcel+"°";
    }
    
    private func getBackgroundPicture(weather: String) -> UIImage {
        
        switch weather {
            
        case "Clear":
            return #imageLiteral(resourceName: "Sunny")
        case "Clouds":
            return #imageLiteral(resourceName: "Cloudy")
        case "Rain":
            return #imageLiteral(resourceName: "Rain-1")
        case "Thunderstorm":
            return #imageLiteral(resourceName: "thunderstormy")
        default:
            return #imageLiteral(resourceName: "Snow-1")
            
        }
    }
    
    private func pictureString(weather: String) -> String {
        
        switch weather {
            
        case "Clear":
            return "sun.max.fill"
        case "Clouds":
            return "cloud.fill"
        case "Rain":
            return "cloud.rain.fill"
        case "Thunderstorm":
            return "cloud.bolt.fill"
        default:
            return "cloud.snow.fill"
            
        }
    }
    
    private func getPicture(weather: String) -> UIImage {
        
        switch weather {
            
        case "Clear":
            return #imageLiteral(resourceName: "Clear")
        case "Clouds":
            return #imageLiteral(resourceName: "Clouds")
        case "Rain":
            return #imageLiteral(resourceName: "Rain")
        case "Thunderstorm":
            return #imageLiteral(resourceName: "Thunderstorm")
        default:
            return #imageLiteral(resourceName: "Snow")
            
        }
    }
    
    
    private func urlBuilder(forecastType: ForecastType, latitude: String , longitude: String) -> URL {
        switch forecastType {
        case .city:
            let url = "\(Constants.baseUrl)lat=\(latitude)&lon=\(longitude)&appid=\(Constants.apikey)"
            return URL(string: url)!
            
        case .forecast:
            let url = "\(Constants.forecasUrl)lat=\(latitude)&lon=\(longitude)&appid=\(Constants.apikey)"
            return URL(string: url)!
        }
    }
    
    // CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first{
            lat = location.coordinate.latitude.description
            lon = location.coordinate.longitude.description
            
            fetchLocationData()
            fetchForecastData()
        }
    }
    
}
