//
//  WeatherViewModel.swift
//  WeatherForcast
//
//  Created by Rishop Babu on 10/02/24.
//

import Foundation
import CoreLocation
import UIKit
import Network
import RealmSwift

@MainActor
class WeatherViewModel: NSObject, ObservableObject {
    @Published var weatherData: WeatherModel?
    @Published var isLoading = false
    @Published var isInternetAvailable = false
    @Published var locationPermissionDenied = false
    @Published var currentLocationName = ""
    @Published var currentTemperature = 0.0
    @Published var isDayOrNight = 0
    @Published var currentLocationFromRealm = ""
    
    let realmManager = RealmManager.shared
    
    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        setupLocationManager()
        checkInternetConnectivity()
        realmManager.configureRealm()
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        let status = locationManager.authorizationStatus
        if status == .authorizedWhenInUse, status == .authorizedAlways {
            locationManager.startUpdatingLocation()
        } else if status == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        else {
            locationManager.requestLocation()
        }
    }
    
    private func checkInternetConnectivity() {
        let monitor = NWPathMonitor()
        
        monitor.pathUpdateHandler = { path in
            let isConnectedtoInternet = path.status == .satisfied
            DispatchQueue.main.async {
                self.isInternetAvailable = isConnectedtoInternet
            }
        }
        monitor.start(queue: DispatchQueue.global())
    }
    
    func getWeatherData(_ lat: CLLocationDegrees, _ long: CLLocationDegrees) async {
        isLoading = true
        
        let result = await getLocationName(for: lat, long)
        guard let locationData = result else {
            return print("Location data is nil")
        }
        currentLocationName = locationData
        
        // Fetch data from API
        do {
            let weatherReport = try await GetWeatherDetails.getWeatherReportData(lat, long)
            updateWeatherModel(weatherReport)
            // Save to realm
            saveToRealm(weatherModel: weatherReport, location: currentLocationName)
            isLoading = false
        } catch(let error) {
            print("Error fetching weather data: ", error)
            isLoading = false
        }
        
    }
    
    func getLocation() -> CLLocation? {
        guard let location = locationManager.location else {
            print("Location manager not available")
            return nil
        }
        return location
    }
    
    func saveToRealm(weatherModel: WeatherModel, location: String) {
        let realModel = convertToRealm(weatherModel: weatherModel)
        let locationModel = LocationRealmModel()
        locationModel.location = location
        currentLocationFromRealm = location
        do {
            let realm = try Realm()
            try realm.write {
                realm.deleteAll()
                if let existingModel = realm.object(ofType: WeatherRealmModel.self, forPrimaryKey: realModel.id) {
                    existingModel.location = locationModel
                    realm.add(existingModel, update: .modified)
                } else {
                    realModel.location = locationModel
                    realm.add(realModel)
                }
            }
        } catch {
            print("Error saving data to Realm: \(error.localizedDescription)")
        }
    }
    
}
