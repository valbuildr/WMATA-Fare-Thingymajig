//
//  StationList.swift
//  WMATA Fare Thingymajig
//
//  Created by Valentine Gacke on 4/11/25.
//

import SwiftUI
import MapKit

extension Color {
    public static let OffBG = Color("OffBG")
    public static let OffItem = Color("OffItem")
}

struct StationList: View {
    @State private var searchQuery = ""
    
    var searchFilteredStations: [Station] {
        if searchQuery.isEmpty {
            return stations
        } else {
            return stations.filter { $0.name.localizedCaseInsensitiveContains(searchQuery) }
        }
    }
    
    var body: some View {
        NavigationStack {
            List(searchFilteredStations) { station in
                NavigationLink(station.name) {
                    StationDetails(station: station)
                }
            }
            .navigationTitle("Station List")
        }
        .searchable(text: $searchQuery)
    }
}

struct StationDetails: View {
    var station: Station
    
    var entrances: StationEntranceData {
        if let ind = entranceData.firstIndex(where: { $0.id == station.id}) {
            return entranceData[ind]
        } else{
            return entranceData[0]
        }
    }
    
    @State private var inputGetFareTo = ""
    @State private var sheetGetFareToAutofill = false
    
    @State private var selectedResult: MKMapItem?
    
    var body: some View {
        List {
            Section {
                Map(selection: $selectedResult) {
                    Marker(station.name, coordinate: station.locationCoordinates)
                    ForEach(entrances.entrances) { entrance in
                        Annotation(
                            entrance.name,
                            coordinate: entrance.entranceCoordinates,
                            anchor: .center
                        ) {
                            Image(systemName: "door.left.hand.open")
                                .padding(4)
                                .foregroundStyle(.white)
                                .background(Color.indigo)
                                .cornerRadius(4)
                        }
                        .annotationTitles(.hidden)
                    }
                }
                .frame(height: 250)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .mapStyle(.hybrid(pointsOfInterest: .excludingAll))
                .mapControls {
                    MapCompass()
                    MapScaleView()
                }
            }
            Section {
                HStack {
                    TextField("End station", text: $inputGetFareTo)
                    
                    Button("Choose a station", systemImage: "link") {
                        sheetGetFareToAutofill = true
                    }
                    .buttonStyle(.borderedProminent)
                    .labelStyle(.iconOnly)
                    .sheet(isPresented: $sheetGetFareToAutofill) {
                        List(stations) { station in
                            Button("\(station.name) (\(station.id))") {
                                inputGetFareTo = station.id
                                sheetGetFareToAutofill = false
                            }
                        }
                    }
                }
                
                NavigationLink {
                    FareLookupView(station1: station.id, station2: inputGetFareTo)
                } label: {
                    Label("Get Fare", systemImage: "arrow.right")
                }
                .disabled(inputGetFareTo.isEmpty)
            } header: {
                Text("Calculate Fare")
            }
            Section {
                HStack {
                    ForEach(station.lines, id: \.self) { line in
                        Image(line)
                    }
                }
            } header: {
                Text("Lines Served")
            }
            Section {
                Button(station.stationAddress) {
                    openAppleMaps(destination: station.locationCoordinates)
                }
                .foregroundStyle(.primary)
            } header: {
                Text("Station Address")
            }
        }
        .navigationTitle(station.name)
    }
    
    func openAppleMaps(origin: CLLocationCoordinate2D? = nil, destination: CLLocationCoordinate2D) {
        var components = URLComponents(string: "maps://")!
        var queryItems: [URLQueryItem] = []
        
        if let origin = origin {
            queryItems.append(URLQueryItem(name: "saddr", value: "\(origin.latitude), \(origin.longitude)"))
        }
        queryItems.append(URLQueryItem(name: "daddr", value: "\(destination.latitude), \(destination.longitude)"))
        queryItems.append(URLQueryItem(name: "dirflg", value: "r"))
        
        components.queryItems = queryItems

        if let url = components.url {
            #if os(iOS)
            UIApplication.shared.open(url)
            #elseif os(macOS)
            NSWorkspace.shared.open(url)
            #endif
        }
    }
}

#Preview("Station List") {
    StationList()
}
#Preview("Station Details") {
    StationDetails(station: stations[0])
}
