//
//  Fare.swift
//  WMATA Fare Thingymajig
//
//  Created by Valentine Gacke on 4/11/25.
//

import Foundation

struct Fare: Hashable, Decodable {
    let start: String
    let end: String
    let regular: Double
    let flat: Double
    let reduced: Double
}
