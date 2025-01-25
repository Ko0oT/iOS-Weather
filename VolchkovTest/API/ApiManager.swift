//
//  ApiManager.swift
//  VolchkovTest
//
//  Created by Citylink on 25.01.2025.
//

import Foundation

class ApiManager {
    
    static let shared = ApiManager()
    
    private let apiKey = "eed549a0b527acdf0486c49b6bb92fa9"
    private let baseURL = "https://api.openweathermap.org/data/2.5/"
    
    func getWeather(for city: String, completion: @escaping (Weather) -> Void) {
        let request = "\(self.baseURL)weather?q=\(city)&appid=\(self.apiKey)&units=metric&lang=ru"
        guard let url = URL(string: request) else { return }
        let task = URLSession.shared.dataTask(with: url) { data, responce, error in
            if let data = data, let weather = try? JSONDecoder().decode(Weather.self, from: data) {
                completion(weather)
            } else {
                print(error)
            }
        }
        task.resume()
    }
    
    func getForecast(for city: String, completion: @escaping (Forecast) -> Void) {
        let request = "\(self.baseURL)forecast?q=\(city)&appid=\(self.apiKey)&units=metric&lang=ru"
        guard let url = URL(string: request) else { return }
        let task = URLSession.shared.dataTask(with: url) { data, responce, error in
            if let data = data, let forecast = try? JSONDecoder().decode(Forecast.self, from: data) {
                completion(forecast)
            } else {
                print(error)
            }
        }
        task.resume()
    }
}
