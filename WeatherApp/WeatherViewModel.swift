//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Sneha Jaiswal on 9/8/25.
//

import Foundation

@MainActor
final class WeatherViewModel: ObservableObject {
    @Published var cityQuery: String = ""
    @Published var isLoading = false
    @Published var errorMessage: String?

    @Published var temperatureText: String?
    @Published var descriptionText: String?

    private let service = WeatherService()
    private let locationManager = LocationManager()   // ← add this

    func search(units: AppState.Units) {
        let unitParam = (units == .metric) ? "metric" : "imperial"
        let symbol = (units == .metric) ? "°C" : "°F"
        guard !cityQuery.trimmingCharacters(in: .whitespaces).isEmpty else { return }

        Task {
            isLoading = true; errorMessage = nil
            defer { isLoading = false }
            do {
                let r = try await service.fetch(city: cityQuery, units: unitParam)
                temperatureText = "\(Int(round(r.main.temp)))\(symbol)"
                descriptionText = r.weather.first?.description.capitalized ?? ""
            } catch {
                temperatureText = nil; descriptionText = nil
                errorMessage = (error as NSError).localizedDescription
            }
        }
    }

    func useCurrentLocation(units: AppState.Units) {
        let unitParam = (units == .metric) ? "metric" : "imperial"
        let symbol = (units == .metric) ? "°C" : "°F"

        isLoading = true
        errorMessage = nil

        locationManager.requestOnce { [weak self] coord in
            guard let self else { return }
            Task { @MainActor in
                defer { self.isLoading = false }
                do {
                    let r = try await self.service.fetch(lat: coord.latitude,
                                                         lon: coord.longitude,
                                                         units: unitParam)
                    self.cityQuery = r.name
                    self.temperatureText = "\(Int(round(r.main.temp)))\(symbol)"
                    self.descriptionText = r.weather.first?.description.capitalized ?? ""
                } catch {
                    self.temperatureText = nil
                    self.descriptionText = nil
                    self.errorMessage = error.localizedDescription
                }
            }
        } failure: { [weak self] message in
            Task { @MainActor in
                self?.isLoading = false
                self?.errorMessage = message
            }
        }
    }

}


