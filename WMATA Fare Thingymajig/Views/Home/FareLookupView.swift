//
//  FareLookupView.swift
//  WMATA Fare Thingymajig
//
//  Created by Valentine Gacke on 4/11/25.
//

import SwiftUI
import MapKit

struct FareLookupView: View {
    var station1: String
    var station2: String
    
    @AppStorage("useReducedFare") private var useReducedFare = false
    
    var start: Station {
        if let ind = stations.firstIndex(where: { $0.id == station1 }) {
            return stations[ind]
        } else {
            // Default to Rhode Island Ave
            return stations[18]
        }
    }
    
    var end: Station {
        if let ind = stations.firstIndex(where: { $0.id == station2 }) {
            return stations[ind]
        } else {
            // Default to Farragut North
            return stations[1]
        }
    }
    
    var fare: Fare {
        if let ind = fares.firstIndex(where: { $0.start == station1 && $0.end == station2 }) {
            return fares[ind]
        } else{
            return fares[1817]
        }
    }
    
    var useFlatFare: Bool {
        let now = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: now)
        let minute = calendar.component(.minute, from: now)
        let weekday = calendar.component(.weekday, from: now)
        
        let isWeekend = (weekday == 1 || weekday == 7)
        
        let isWithinTime = (hour > 4 || (hour == 4 && minute >= 0)) && (hour < 21 || (hour == 21 && minute <= 30))
        
        return isWeekend || isWithinTime
    }
    
    var body: some View {
        List {
            Section {
                Map {
                    Annotation(
                        start.name,
                        coordinate: start.locationCoordinates,
                        anchor: .center
                    ) {
                        Image(systemName: "tram.fill")
                            .padding(4)
                            .foregroundStyle(.white)
                            .background(Color.green)
                            .cornerRadius(4)
                    }
                    Annotation(
                        end.name,
                        coordinate: end.locationCoordinates,
                        anchor: .center
                    ) {
                        Image(systemName: "tram.fill")
                            .padding(4)
                            .foregroundStyle(.white)
                            .background(Color.red)
                            .cornerRadius(4)
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
                    HStack {
                        Text("Regular")
                        if !useFlatFare && !useReducedFare {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(.secondary)
                        }
                    }
                    Spacer()
                    Text("$\(String(format: "%.2f", fare.regular))")
                        .foregroundStyle(.secondary)
                }
                HStack {
                    HStack {
                        Text("Flat")
                        if useFlatFare && !useReducedFare {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(.secondary)
                        }
                    }
                    Spacer()
                    Text("$\(String(format: "%.2f", fare.flat))")
                        .foregroundStyle(.secondary)
                }
                HStack {
                    HStack {
                        Text("Reduced")
                        if useReducedFare {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(.secondary)
                        }
                    }
                    Spacer()
                    Text("$\(String(format: "%.2f", fare.reduced))")
                        .foregroundStyle(.secondary)
                }
            } header: {
                Text("Fare Types")
            }
            
            Section {
                Button("Get Directions") {
                    openAppleMaps(origin: start.locationCoordinates, destination: end.locationCoordinates)
                }
            } header: {
                Text("Directions")
            }
        }
        .navigationTitle("Fare")
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

#Preview("Rhode Island Ave -> Farragut North") {
    FareLookupView(station1: "B04", station2: "A02")
}
#Preview("Metro Center -> Ashburn") {
    FareLookupView(station1: "A01", station2: "N12")
}
