//
//  WeatherResponse.swift
//  WeatherApp
//
//  Created by Sneha Jaiswal on 9/9/25.
//

import Foundation

struct WeatherResponse: Decodable {
    let name: String              // city name
    let weather: [Condition]      // array but we’ll use the first
    let main: Main
    let wind: Wind?

    struct Condition: Decodable {
        let description: String
        let icon: String
    }

    struct Main: Decodable {
        let temp: Double
        let humidity: Int
    }

    struct Wind: Decodable {
        let speed: Double?
    }
}
