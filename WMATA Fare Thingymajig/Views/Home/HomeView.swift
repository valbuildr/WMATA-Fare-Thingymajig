//
//  HomeView.swift
//  WMATA Fare Thingymajig
//
//  Created by Valentine Gacke on 4/11/25.
//

import SwiftUI

struct HomeView: View {
    @State private var inputStation1 = ""
    @State private var inputStation2 = ""
    
    @State private var sheetShowStation1Autofill = false
    @State private var sheetShowStation2Autofill = false
    
    var body: some View {
        NavigationSplitView {
            List {
                Section {
                    HStack {
                        TextField("Starting station", text: $inputStation1)
                        
                        Button("Choose a station", systemImage: "link") {
                            sheetShowStation1Autofill = true
                        }
                        .buttonStyle(.borderedProminent)
                        .labelStyle(.iconOnly)
                        .sheet(isPresented: $sheetShowStation1Autofill) {
                            List(stations) { station in
                                Button("\(station.name) (\(station.id))") {
                                    inputStation1 = station.id
                                    sheetShowStation1Autofill = false
                                }
                            }
                        }
                    }
                    Button("Swap", systemImage: "arrow.up.arrow.down") {
                        (inputStation1, inputStation2) = (inputStation2, inputStation1)
                    }
                    .disabled(inputStation1.isEmpty)
                    .disabled(inputStation2.isEmpty)
                    .disabled(inputStation1 == inputStation2)
                    HStack {
                        TextField("Destination station", text: $inputStation2)
                        
                        Button("Choose a station", systemImage: "link") {
                            sheetShowStation2Autofill = true
                        }
                        .buttonStyle(.borderedProminent)
                        .labelStyle(.iconOnly)
                        .sheet(isPresented: $sheetShowStation2Autofill) {
                            List(stations) { station in
                                Button("\(station.name) (\(station.id))") {
                                    inputStation2 = station.id
                                    sheetShowStation2Autofill = false
                                }
                            }
                        }
                    }
                    NavigationLink {
                        FareLookupView(station1: inputStation1, station2: inputStation2)
                    } label: {
                        Label("Get Fare", systemImage: "arrow.right")
                    }
                    .disabled(inputStation1.isEmpty)
                    .disabled(inputStation2.isEmpty)
                    .disabled(inputStation1 == inputStation2)
                }
                
                Section {
                    ForEach(mostUsedStations) { station in
                        NavigationLink(station.name) {
                            StationDetails(station: station.station)
                        }
                    }
                } header: {
                    Text("Most Used Stations")
                }
            }
            
            .navigationTitle("Home")
        } detail: {
            Text("Choose two stations in the sidebar to see fares between them.")
        }
    }
}

#Preview {
    HomeView()
}
