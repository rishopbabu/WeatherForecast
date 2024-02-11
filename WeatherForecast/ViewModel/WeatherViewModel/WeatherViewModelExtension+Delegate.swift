//
//  WeatherViewModelExtension+Delegate.swift
//  WeatherForcast
//
//  Created by Rishop Babu on 10/02/24.
//

import Foundation
import CoreLocation
import UIKit

extension WeatherViewModel: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print("Received location update:", location)
            Task {
                await getWeatherData(location.coordinate.latitude, location.coordinate.longitude)
            }
            manager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager error:", error.localizedDescription)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
            case .authorizedWhenInUse, .authorizedAlways:
                manager.requestLocation()
            case .denied, .restricted:
                DispatchQueue.main.async {
                    self.showLocationPermissionAlert()
                }
            case .notDetermined:
                break
            @unknown default:
                break
        }
    }
    
    func getLocationName(for latitude: CLLocationDegrees, _ longitude: CLLocationDegrees) async -> String? {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        let geocoder = CLGeocoder()
        
        var locationName: String?
        do {
            if let placemark = try await geocoder.reverseGeocodeLocation(location).first {
                if let locality = placemark.name {
                    locationName = locality
                }
                if let country = placemark.country {
                    if let existingLocationName = locationName {
                        locationName = "\(existingLocationName), \(country)"
                    } else {
                        locationName = country
                    }
                }
            }
        } catch(let error) {
            print("getlocation error: ", error)
        }
        
        return locationName
    }
    
    
    func showLocationPermissionAlert() {
        let alert = UIAlertController(title: "Location Access Required", message: "Please enable location access in Settings to use this feature.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { _ in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
}
