//
//  AppState.swift
//  WeatherApp
//
//  Created by Sneha Jaiswal on 9/8/25.
//

import SwiftUI

final class AppState: ObservableObject {
    @Published var preferredUnits: Units = .metric
    enum Units: String, CaseIterable { case metric, imperial }
}
