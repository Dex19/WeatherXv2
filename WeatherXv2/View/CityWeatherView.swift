//
//  CityWeatherView.swift
//  CityWeatherView
//
//  Created by Tino on 15.08.2021..
//

import SwiftUI

struct CityWeatherView: View {
    
    @StateObject var fetchWeatherData = JsonParser()
    @Environment(\.managedObjectContext) private var managedContext
    @FetchRequest(entity: City.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \City.id, ascending: true)])
    var cities: FetchedResults<City>

    var body: some View {
        
        let todayWeatherData = fetchWeatherData.fetchedWeatherCityData

        ZStack {
            VStack {
                Image(uiImage: todayWeatherData.image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 125, height: 125)
                
                Text(todayWeatherData.city)
                    .foregroundColor(Color.black)
                    .font(.system(size: 35))
                
                Text(todayWeatherData.temp)
                    .foregroundColor(Color.black)
                    .font(.system(size: 60))
                    .bold()
                Text(todayWeatherData.weather)
                    .foregroundColor(Color.black)
                    .font(.system(size: 20))
                Text(todayWeatherData.description)
                    .foregroundColor(Color.black)

        
                List {
                    HStack {
                        Image(systemName: "sunrise.fill")
                        Text(todayWeatherData.sunrise)
                            .font(.system(size: 20))
                        Spacer()
                        Image(systemName: "sunset.fill")
                        Text(todayWeatherData.sunset)
                            .font(.system(size: 20))
                    }
                    HStack {
                        Image(systemName: "thermometer.snowflake")
                        Text(todayWeatherData.tempMin)
                            .font(.system(size: 20))
                        Spacer()
                        Image(systemName: "thermometer.sun.fill")
                        Text(todayWeatherData.tempMax)
                            .font(.system(size: 20))
                    }
                    HStack {
                        Text("Humidity")
                            .font(.system(size: 20))
                        Spacer()
                        Text(todayWeatherData.humidity)
                            .font(.system(size: 20))
                    }
                    HStack {
                        Text("Feels Like")
                            .font(.system(size: 20))
                        Spacer()
                        Text(todayWeatherData.feelsLike)
                            .font(.system(size: 20))
                    }
                    HStack {
                        Spacer()
                            Button("Save this forecast") {
                                saveObjetToCoreData(weatherData: todayWeatherData)
                            }.foregroundColor(.blue)
                        Spacer()
                    }
                }
                .font(.title)
            }
        }.onAppear {
            fetchWeatherData.fetchLocationData()
        }.background(
            Image(uiImage: todayWeatherData.backgroundImage)
                .resizable()
                .ignoresSafeArea()
                .scaledToFill()
                .blur(radius: 15)
        )
    }
    
    private func saveObjetToCoreData(weatherData: WeatherCityModel) {
        withAnimation {
                        
            let newWeatherObject = Weather(context: managedContext)
            newWeatherObject.date = Date()
            newWeatherObject.temp = weatherData.temp
            newWeatherObject.weather = weatherData.weather
            newWeatherObject.image = weatherData.systemImage
            newWeatherObject.desc = weatherData.description
            
            if !cities.contains(where: {$0.id == weatherData.cityId}) {
                
                let newCityObject = City(context: managedContext)
                newCityObject.id = Int64(weatherData.cityId)
                newCityObject.country = weatherData.country
                newCityObject.name = weatherData.city
                newWeatherObject.city = newCityObject
                
            } else {
                newWeatherObject.city = cities.first(where: {$0.id == weatherData.cityId})
            }
            do {
                try managedContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct CityWeatherView_Previews: PreviewProvider {
    static var previews: some View {
        CityWeatherView()
    }
}
