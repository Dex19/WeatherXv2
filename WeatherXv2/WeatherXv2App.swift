//
//  WeatherXv2App.swift
//  WeatherXv2
//
//  Created by Tino on 09.08.2021..
//

import SwiftUI

@main
struct WeatherXv2App: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            TabBarView()
        }
    }
}
