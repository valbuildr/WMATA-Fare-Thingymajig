//
//  StationEntranceData.swift
//  WMATA Fare Thingymajig
//
//  Created by Valentine Gacke on 4/11/25.
//

import Foundation
import CoreLocation

struct StationEntranceData: Hashable, Decodable, Identifiable {
    let id: String
    let entrances: [Entrance]
    
    struct Entrance: Hashable, Decodable, Identifiable {
        let id: String
        let name: String
        let description: String
        let coordinates: Coordinates
        
        var entranceCoordinates: CLLocationCoordinate2D {
            CLLocationCoordinate2D(
                latitude: coordinates.lat,
                longitude: coordinates.lon
            )
        }
    }
    
    struct Coordinates: Hashable, Decodable {
        let lat: Double
        let lon: Double
    }
}
