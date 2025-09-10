//
//  WeatherService.swift
//  WeatherApp
//
//  Created by Sneha Jaiswal on 9/9/25.
//

import Foundation

struct OWErrorResponse: Decodable {
    let cod: String?
    let message: String?
}

final class WeatherService {
    private let session = URLSession.shared

    func fetch(city: String, units: String) async throws -> WeatherResponse {
        let q = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? city
        let apiKey = Secrets.weatherAPIKey

        let url = URL(string:
            "https://api.openweathermap.org/data/2.5/weather?q=\(q)&appid=\(apiKey)&units=\(units)"
        )!

        let (data, response) = try await session.data(from: url)
        guard let http = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }

        if http.statusCode != 200 {
            // Try to decode OpenWeather's error message for clarity
            if let ow = try? JSONDecoder().decode(OWErrorResponse.self, from: data),
               let msg = ow.message {
                throw NSError(domain: "OpenWeather", code: http.statusCode,
                              userInfo: [NSLocalizedDescriptionKey: "HTTP \(http.statusCode): \(msg)"])
            }
            let body = String(data: data, encoding: .utf8) ?? ""
            throw NSError(domain: "OpenWeather", code: http.statusCode,
                          userInfo: [NSLocalizedDescriptionKey: "HTTP \(http.statusCode). Body: \(body)"])
        }

        return try JSONDecoder().decode(WeatherResponse.self, from: data)
    }
    
    func fetch(lat: Double, lon: Double, units: String) async throws -> WeatherResponse {
        let apiKey = Secrets.weatherAPIKey
        let url = URL(string:
          "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=\(units)"
        )!
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        return try JSONDecoder().decode(WeatherResponse.self, from: data)
    }
    
}

