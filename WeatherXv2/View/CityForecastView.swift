//
//  CityForecastView.swift
//  CityForecastView
//
//  Created by Tino on 15.08.2021..
//

import SwiftUI

struct CityForecastView: View {
    
    @StateObject var fetchWeatherData = JsonParser()
    private let weekDaysArray = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    
    var body: some View {
        let cityInfo = fetchWeatherData.fetchedWeatherForecastData
        let navTitle = "\(cityInfo.name ?? "N/A") - \(cityInfo.country ?? "N/A")"
        
        List {
            ForEach(self.weekDaysArray, id: \.self) { (weekDay) in
                
                let weatherDataArray = cityInfo.cityForecast.filter({($0.day ?? .sun).toString() == weekDay})
                
                if !weatherDataArray.isEmpty {
                    Section(header: Text(weekDay)) {
                      
                        ForEach(weatherDataArray) { (weatherData) in
                            DefaultCell(weatherData: weatherData)
                        }
                    }
                }
            }
        }
        .navigationBarTitle(navTitle)
        .onAppear {
            fetchWeatherData.fetchForecastData()
        }
    }
}

struct CityForecastView_Previews: PreviewProvider {
    static var previews: some View {
        CityForecastView()
    }
}

struct DefaultCell: View {
    
    let weatherData: WeatherForecastModel
    
    var body: some View {
        HStack {
            Image(systemName: weatherData.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
            
            VStack(alignment: .leading) {
                Text("\(weatherData.weather ?? "") - \(weatherData.temp ?? "")")
                Text("\(weatherData.fullDate ?? "") \(weatherData.description ?? "")")
            }
            
        }
    }
}
