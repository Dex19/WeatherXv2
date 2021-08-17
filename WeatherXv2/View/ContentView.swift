//
//  ContentView.swift
//  WeatherXv2
//
//  Created by Tino on 09.08.2021..
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(entity: City.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \City.id, ascending: true)])
    var cities: FetchedResults<City>

    @State var selectedCity: City?
    @State private var showingPopover = false

    var body: some View {
        if cities.isEmpty {
            Text("There is no saved data.")
        } else {
            VStack {
                
                Button(selectedCity?.name ?? "N/A") {
                    showingPopover = true
                }.cornerRadius(5)
                    .font(.system(size: 20))
                    .popover(isPresented: $showingPopover) {
                        List {
                            ForEach(cities) { city in
                                Button(city.name ?? "N/A") {
                                    selectedCity = city
                                    showingPopover = false
                                }.font(.system(size: 20))
                                .padding()
                                
                            }
                        }
                    }
                
                
    
                let forecasts = selectedCity?.forecasts?.allObjects as? [Weather] ?? []
                let sortedForecasts = forecasts.sorted(by: {$0.date ?? Date() > $1.date ?? Date()})
                
                List {
                    ForEach(sortedForecasts) { forecast in
                        WeatherCell(weatherData: forecast)
                    }
                    .onDelete(perform: deleteItems)
                }
            }.onAppear {
                selectedCity = cities.first
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            let forecasts = selectedCity?.forecasts?.allObjects as! [Weather]

            offsets.map { forecasts[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
                
                cities.forEach { city in
                    if city.forecasts?.count == 0 {
                        viewContext.delete(city)
                        
                        do {
                            try viewContext.save()
                            selectedCity = cities.first
                        } catch {
                            // Replace this implementation with code to handle the error appropriately.
                            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                            let nsError = error as NSError
                            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                        }
                    }
                }
                
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
            
        }
    }
}

struct WeatherCell: View {
    
    let weatherData: Weather
    
    var body: some View {
        
        let formatedDate = API.shared.formatDateFromUnixDate(unixDate: Int((weatherData.date ?? Date()).timeIntervalSince1970))
        
        HStack {
            Image(systemName: weatherData.image ?? "")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
            
            VStack(alignment: .leading) {
                Text("\(weatherData.weather ?? "") - \(weatherData.temp ?? "")")
                Text("\(formatedDate) \(weatherData.desc ?? "")")
            }
            
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()


