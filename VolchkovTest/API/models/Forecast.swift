// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let forecast = try? JSONDecoder().decode(Forecast.self, from: jsonData)

import Foundation

// MARK: - Forecast
struct Forecast: Codable {
    let cod: String?
    let message, cnt: Int?
    let list: [List]?
    let city: City?
}

// MARK: - City
struct City: Codable {
    let id: Int?
    let name: String?
    let coord: Coord?
    let country: String?
    let population, timezone, sunrise, sunset: Int?
}

// MARK: - Coord
struct Coord: Codable {
    let lat, lon: Double?
}

// MARK: - List
struct List: Codable {
    let dt: Int?
    let main: MainClass?
    let weatherForecast: [WeatherForecast]?
    let clouds: Clouds?
    let visibility: Int?
    let pop: Double?
    let snow: SnowForecast?
    let sys: SysForecast?
    let dtTxt: String?

    enum CodingKeys: String, CodingKey {
        case dt, main, weatherForecast, clouds, visibility, pop, snow, sys
        case dtTxt = "dt_txt"
    }
}

// MARK: - Clouds
struct Clouds: Codable {
    let all: Int?
}

// MARK: - MainClass
struct MainClass: Codable {
    let temp, feelsLike, tempMin, tempMax: Double?
    let pressure, seaLevel, grndLevel, humidity: Int?
    let tempKf: Double?

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
        case humidity
        case tempKf = "temp_kf"
    }
}

// MARK: - SnowForecast
struct SnowForecast: Codable {
    let the3H: Double?

    enum CodingKeys: String, CodingKey {
        case the3H = "3h"
    }
}

// MARK: - SysForecast
struct SysForecast: Codable {
    let pod: Pod?
}

enum Pod: String, Codable {
    case d = "d"
    case n = "n"
}

// MARK: - WeatherForecast
struct WeatherForecast: Codable {
    let id: Int?
    let main: String?
    let description: String?
    let icon: String?
}


