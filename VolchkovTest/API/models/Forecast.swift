// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let forecast = try? JSONDecoder().decode(Forecast.self, from: jsonData)

import Foundation

// MARK: - Forecast
struct Forecast: Codable {
    let list: [ForecastList]?
}

// MARK: - List
struct ForecastList: Codable {
    let dt: Double?
    let main: MainTemp?
    let weather: [Weather]?
}


// MARK: - Weather
struct Weather: Codable {
    let description: String?
}


