// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let weather = try? JSONDecoder().decode(Weather.self, from: jsonData)

import Foundation

// MARK: - Weather
struct WeatherOfCity: Codable {
    let weather: [WeatherElement]?
    let main: MainTemp?
    let coord: Coord?
    let base: String?
    let visibility: Int?
    let wind: Wind?
    let snow: Snow?
    let clouds: Clouds?
    let dt: Int?
    let timezone, id: Int?
    let name: String?
    let cod: Int?
}


// MARK: - Main
struct MainTemp: Codable {
    let temp: Double?
}

// MARK: - WeatherElement
struct WeatherElement: Codable {
    let description: String?
}

// MARK: - Clouds
struct Clouds: Codable {
    let all: Int?
}

// MARK: - Coord
struct Coord: Codable {
    let lon, lat: Double?
}

// MARK: - Snow
struct Snow: Codable {
    let the1H: Double?

    enum CodingKeys: String, CodingKey {
        case the1H = "1h"
    }
}

// MARK: - Wind
struct Wind: Codable {
    let speed, deg: Int?
}
