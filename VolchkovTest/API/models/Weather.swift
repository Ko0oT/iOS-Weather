// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let weather = try? JSONDecoder().decode(Weather.self, from: jsonData)

import Foundation

// MARK: - Weather
struct WeatherOfCity: Codable {
    let weather: [WeatherElement]?
    let main: MainTemp?
}


// MARK: - Main
struct MainTemp: Codable {
    let temp: Double?
}

// MARK: - WeatherElement
struct WeatherElement: Codable {
    let description: String?
}
