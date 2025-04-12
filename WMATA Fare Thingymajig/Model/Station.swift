//
//  Station.swift
//  WMATA Fare Thingymajig
//
//  Created by Valentine Gacke on 4/11/25.
//

import Foundation
import CoreLocation

struct Station: Hashable, Codable, Identifiable {
    var id: String
    var name: String
    var lines: [String]
    
    var coordinates: Coordinates
    var locationCoordinates: CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: coordinates.lat,
            longitude: coordinates.lon
        )
    }
    
    var address: Address
    var stationAddress: String {
        return "\(address.street), \(address.city), \(address.state) \(address.zip)"
    }
    
    struct Address: Hashable, Codable {
        var street: String
        var city: String
        var state: String
        var zip: String
    }
    
    struct Coordinates: Hashable, Codable {
        var lat: Double
        var lon: Double
    }
}
