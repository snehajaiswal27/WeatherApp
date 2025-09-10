//
//  ContentView.swift
//  WeatherApp
//
//  Created by Sneha Jaiswal on 9/7/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var vm = WeatherViewModel()

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {

                Picker("Units", selection: $appState.preferredUnits) {
                    Text("Metric (°C)").tag(AppState.Units.metric)
                    Text("Imperial (°F)").tag(AppState.Units.imperial)
                }
                .pickerStyle(.segmented)
                HStack {
                    TextField("Enter city (e.g., Atlanta)", text: $vm.cityQuery)
                        .textFieldStyle(.roundedBorder)
                        .submitLabel(.search)
                        .onSubmit { vm.search(units: appState.preferredUnits) }
                    
                    Button("Go") {
                        vm.search(units: appState.preferredUnits)
                    }
                    .buttonStyle(.borderedProminent)
                }

                if let temp = vm.temperatureText, let desc = vm.descriptionText {
                    InfoRow(title: "Now", value: "\(temp) • \(desc)")
                        .transition(.opacity)
                        .animation(.easeInOut, value: vm.temperatureText)
                }


                if vm.temperatureText != nil {
                    NavigationLink("See details") {
                        CityResultView(
                            city: vm.cityQuery,
                            temperature: vm.temperatureText ?? "--",
                            description: vm.descriptionText ?? "--"
                        )
                    }
                }

                Spacer()
            }
            .padding()
            .navigationTitle("WeatherApp")
            .background(
                LinearGradient(colors: [.blue.opacity(0.15), .clear],
                               startPoint: .top, endPoint: .bottom)
            )
            .alert("Error", isPresented: .constant(vm.errorMessage != nil)) {
                Button("OK") { vm.errorMessage = nil }
            } message: { Text(vm.errorMessage ?? "") }
        }

        .onAppear {
            let usage = Bundle.main.object(forInfoDictionaryKey: "NSLocationWhenInUseUsageDescription") as? String ?? "MISSING"
            print("UsageDesc:", usage)
        }
    }
}


struct InfoRow: View {
    let title: String
    let value: String
    var body: some View {
        HStack {
            Text(title).font(.headline)
            Spacer()
            Text(value).font(.body).foregroundStyle(.secondary)
        }
        .padding()
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview("Light - Metric") {
    ContentView()
        .environmentObject(AppState())
}

#Preview("Dark - Imperial") {
    let app = AppState(); app.preferredUnits = .imperial
    return ContentView()
        .environmentObject(app)
        .preferredColorScheme(.dark)
}
