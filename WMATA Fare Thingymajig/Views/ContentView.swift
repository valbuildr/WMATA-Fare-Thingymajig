//
//  ContentView.swift
//  WMATA Fare Thingymajig
//
//  Created by Valentine Gacke on 4/11/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            Tab("Home", systemImage: "house.fill") {
                HomeView()
            }
            Tab("Stations", systemImage: "tram.fill") {
                StationList()
            }
            Tab("Settings", systemImage: "gear") {
                SettingsView()
            }

        }
    }
}

#Preview {
    ContentView()
}
