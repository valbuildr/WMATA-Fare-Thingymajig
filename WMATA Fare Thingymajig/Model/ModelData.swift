//
//  ModelData.swift
//  WMATA Fare Thingymajig
//
//  Created by Valentine Gacke on 4/11/25.
//

import Foundation

struct Settings {
    let useReducedFare: Bool
}

var stations: [Station] = load("stations.json")
var fares: [Fare] = load("fares.json")
var entranceData: [StationEntranceData] = load("entrances.json")
var mostUsedStations: [MostUsedStation] = load("mostUsedStations.json")

func load<T: Decodable>(_ filename: String) -> T {
    let data: Data

    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
    else {
        fatalError("Couldn't find \(filename) in main bundle.")
    }
    
    print("File URL: \(file)")

    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }

    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}
