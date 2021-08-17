//
//  TabBarView.swift
//  TabBarView
//
//  Created by Tino on 15.08.2021..
//

import SwiftUI

struct TabBarView: View {
    @State private var selection = 0
    let persistenceController = PersistenceController.shared
    var body: some View {
        TabView(selection: $selection) {
            NavigationView {
                CityWeatherView().environment(\.managedObjectContext, persistenceController.container.viewContext)
            }.tabItem {
                VStack {
                    Image(systemName: "sun.haze.fill")
                    Text("Weather")
                }
            }
            .tag(0)
            NavigationView {
                CityForecastView()
            }.tabItem {
                VStack {
                    Image(systemName: "thermometer")
                    Text("Forecast")
                }
            }
            .tag(1)
            NavigationView {
                ContentView().environment(\.managedObjectContext, persistenceController.container.viewContext)
            }.tabItem {
                VStack {
                    Image(systemName: "chart.bar.xaxis")
                    Text("Forecast Archive")
                }
            }
            .tag(2)
        }
        .edgesIgnoringSafeArea(.top)
        .accentColor(.blue)
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
