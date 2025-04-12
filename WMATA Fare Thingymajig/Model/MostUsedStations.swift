//
//  MostUsedStations.swift
//  WMATA Fare Thingymajig
//
//  Created by Valentine Gacke on 4/12/25.
//

import Foundation

struct MostUsedStation: Hashable, Decodable, Identifiable {
    let id: String
    let name: String
    
    var station: Station {
        if let ind = stations.firstIndex(where: { $0.id == self.id}) {
            return stations[ind]
        } else{
            return stations[0]
        }
    }
}
