//
//  CityResultView.swift
//  WeatherApp
//
//  Created by Sneha Jaiswal on 9/8/25.
//

import SwiftUI

struct CityResultView: View {
    let city: String
    let temperature: String
    let description: String

    var body: some View {
        VStack(spacing: 24) {
            Text(city).font(.largeTitle).bold()
            Text(temperature).font(.system(size: 60, weight: .thin))
            Text(description).font(.title3).foregroundStyle(.secondary)
            Spacer()
        }
        .padding()
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}
