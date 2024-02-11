//
//  ContentView.swift
//  WeatherForcast
//
//  Created by Rishop Babu on 10/02/24.
//

import SwiftUI
import CoreLocation

struct ContentView: View {
    @ObservedObject var viewModel = WeatherViewModel()
    @State private var locationPermissionDenied = false
    @State private var isLoading = true
    @State private var isInternetAvailable = true
    
    var body: some View {
        NavigationView {
            if isLoading {
                ProgressView {
                    Text("Fetching Weather Data...")
                }
                .progressViewStyle(.circular)
            } else {
                VStack(alignment: .center, spacing: 5) {
                    HStack {
                        Text("Current Location: \(viewModel.weatherData?.currentLocation ?? viewModel.currentLocationName)")
                            .font(.headline)
                            .foregroundColor(.primary)
                        Spacer()
                        Image(systemName: "location.circle.fill")
                            .foregroundColor(.blue)
                    }
                    HStack {
                        Text("Current Temperature: \(temperatureText(temperature: viewModel.weatherData?.current?.temperature2M))")
                            .font(.headline)
                            .foregroundColor(.primary)
                        Spacer()
                        Image(systemName: "thermometer.variable.and.figure")
                            .foregroundColor(.yellow)
                    }
                    HStack {
                        Text("Current Day/Night: \(dayNightonversion(dayOrNight: viewModel.weatherData?.current?.isday))")
                            .font(.headline)
                            .foregroundColor(.primary)
                        Spacer()
                        switch viewModel.weatherData?.current?.isday {
                            case 0:
                                Image(systemName: "moon.zzz.fill")
                                    .foregroundColor(.black)
                            case 1:
                                Image(systemName: "sun.max")
                                    .foregroundColor(.black)
                            default:
                                Image(systemName: "sun.max")
                                    .foregroundColor(.black)
                        }
                    }
                    HStack {
                        Text("Last Updated: \(formattedTime(timeString: viewModel.weatherData?.current?.time))")
                            .font(.headline)
                            .foregroundColor(.primary)
                        Spacer()
                        Image(systemName: "timer")
                            .foregroundColor(.blue)
                    }
                    
                    HStack {
                        if viewModel.isInternetAvailable {
                            Text("Online Status: Online")
                                .font(.headline)
                                .foregroundColor(.primary)
                            Spacer()
                            Image(systemName: "circle.fill")
                                .foregroundColor(.green)
                        } else {
                            Text("Online Status: Offline")
                                .font(.headline)
                                .foregroundColor(.primary)
                            Spacer()
                            Image(systemName: "circle.fill")
                                .foregroundColor(.red)
                        }
                        
                    }
                    
                    Divider()
                    
                    Group {
                        List {
                            ForEach(viewModel.weatherData?.daily?.time?.indices ?? 0..<0, id: \.self) { index in
                                if let forecast = viewModel.weatherData?.daily {
                                    WeatherForecastView(forecast: forecast, index: index)
                                }
                            }
                        }.listStyle(.sidebar)
                    }
                }
                .navigationTitle("Weather Forecast")
            }
        }
        .alert(isPresented: $locationPermissionDenied) {
            Alert(title: Text("Location Permission Denied"),
                  message: Text("Please enable location services in settings to fetch weather data"),
                  dismissButton: .default(Text("OK")))
        }
        .onReceive(viewModel.$isInternetAvailable) { internetAvailable in
            if internetAvailable {
                isLoading = true
                Task {
                    await updateLocationAndWeatherData()
                }
            } else {
                isLoading = true
                Task {
                    await updateLocationAndWeatherData()
                }
            }
        }
        .onAppear {
            isLoading = true
            Task {
                await updateLocationAndWeatherData()
            }
        }
        
    }
    
    func updateLocationAndWeatherData() async {
        if let location = viewModel.getLocation() {
            if viewModel.isInternetAvailable {
                await viewModel.getWeatherData(location.coordinate.latitude, location.coordinate.longitude)
                isLoading = false
            } else {
                if let weatherDataFromRelam = await viewModel.fetchWeatherDataFromRealm() {
                    viewModel.weatherData = weatherDataFromRelam
                }
                isLoading = false
            }
        } else {
            print("Error: Location not available")
            isLoading = false
        }
    }
    
    private func temperatureText(temperature: Double?) -> String {
        guard let temp = temperature else { return "N/A" }
        return "\(temp)°C"
    }
    
    private func dayNightonversion(dayOrNight: Int?) -> String {
        if dayOrNight == 1 {
            return "Day"
        } else {
            return "Night"
        }
    }
    
    private func formattedTime(timeString: String?) -> String {
        guard let time = timeString else { return "N/A" }
        
        let components = time.components(separatedBy: "T")
        guard components.count == 2 else { return "N/A" }
        
        let timeComponents = components[1].components(separatedBy: ":")
        guard timeComponents.count >= 2 else { return "N/A" }
        
        return "\(timeComponents[0]):\(timeComponents[1])"
    }
}



#Preview {
    ContentView()
}
