//
//  LocationManager.swift
//  WeatherApp
//
//  Created by Sneha Jaiswal on 9/9/25.
//

import CoreLocation
import Foundation

final class LocationManager: NSObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    private var onSuccess: ((CLLocationCoordinate2D) -> Void)?
    private var onFailure: ((String) -> Void)?
    private var timeoutWorkItem: DispatchWorkItem?

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        print("[Loc] init; auth=\(manager.authorizationStatus.rawValue)")
    }

    /// Request one coordinate. Prints detailed logs and times out after 10s.
    func requestOnce(success: @escaping (CLLocationCoordinate2D) -> Void,
                     failure: @escaping (String) -> Void) {
        print("[Loc] requestOnce() called; auth=\(manager.authorizationStatus.rawValue)")
        onSuccess = success
        onFailure = failure

        // fire a timeout so we never spin forever
        timeoutWorkItem?.cancel()
        let work = DispatchWorkItem { [weak self] in
            guard let self else { return }
            self.fail("[Loc] Timed out waiting for location. Check Simulator → Features → Location.")
        }
        timeoutWorkItem = work
        DispatchQueue.main.asyncAfter(deadline: .now() + 10, execute: work)

        switch manager.authorizationStatus {
        case .notDetermined:
            print("[Loc] requesting when-in-use authorization…")
            manager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            print("[Loc] already authorized — requesting location…")
            manager.requestLocation()
        case .denied, .restricted:
            fail("[Loc] Permission denied/restricted. Enable in Settings.")
        @unknown default:
            fail("[Loc] Unknown authorization state.")
        }
    }

    private func succeed(_ coord: CLLocationCoordinate2D) {
        print("[Loc] SUCCESS lat=\(coord.latitude), lon=\(coord.longitude)")
        timeoutWorkItem?.cancel()
        onSuccess?(coord)
        onSuccess = nil; onFailure = nil
    }

    private func fail(_ message: String) {
        print(message)
        timeoutWorkItem?.cancel()
        onFailure?(message)
        onSuccess = nil; onFailure = nil
    }

    // MARK: CLLocationManagerDelegate

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print("[Loc] auth changed → \(manager.authorizationStatus.rawValue)")
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            print("[Loc] now authorized — requesting location…")
            manager.requestLocation()
        case .denied, .restricted:
            fail("[Loc] Permission denied. Settings → Privacy → Location Services.")
        case .notDetermined:
            // waiting on the system prompt
            break
        @unknown default:
            fail("[Loc] Unknown authorization state.")
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("[Loc] didUpdateLocations count=\(locations.count)")
        guard let loc = locations.first else {
            fail("[Loc] No locations returned.")
            return
        }
        succeed(loc.coordinate)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        fail("[Loc] didFailWithError: \(error.localizedDescription)")
    }
}
