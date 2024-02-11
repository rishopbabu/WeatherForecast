//
//  WeatherForecastView.swift
//  WeatherForcast
//
//  Created by Rishop Babu on 10/02/24.
//

import SwiftUI

struct WeatherForecastView: View {
    let forecast: Daily
    let index: Int
    
    var body: some View {
        HStack {
            VStack(spacing: 10) {
                HStack {
                    Text("Date:")
                    Text("\(formattedDate(for: index))")
                    Spacer() // Add spacer to push image to the right
                    Image(systemName: "calendar")
                        .foregroundColor(.blue)
                }
                HStack {
                    Text("Day:")
                    Text("\(formattedDay(for: index))")
                    Spacer()
                    Image(systemName: "sun.max.fill")
                        .foregroundColor(.yellow)
                }
                HStack {
                    Text("Min Temp:")
                    Text("\(temperatureText(for: forecast.temperature2MMin?[index]))")
                    Spacer()
                    Image(systemName: "thermometer.snowflake")
                        .foregroundColor(.blue)
                }
                HStack {
                    Text("Max Temp:")
                    Text("\(temperatureText(for: forecast.temperature2MMax?[index]))")
                    Spacer()
                    Image(systemName: "thermometer.sun.fill")
                        .foregroundColor(.red)
                }
                HStack {
                    Text("Sunrise:")
                    Text("\(formattedTime(for: forecast.sunrise?[index]))")
                    Spacer()
                    Image(systemName: "sunrise.fill")
                        .foregroundColor(.orange)
                }
                HStack {
                    Text("Sunset:")
                    Text("\(formattedTime(for: forecast.sunset?[index]))")
                    Spacer()
                    Image(systemName: "sunset.fill")
                        .foregroundColor(.orange)
                }
                HStack {
                    Text("Wind Speed:")
                    Text("\(windSpeedText(for: forecast.windSpeed10MMax?[index]))")
                    Spacer()
                    Image(systemName: "wind")
                        .foregroundColor(.green)
                }
            }
            .padding(.all)
            .background(Color(.systemBackground))
            .cornerRadius(10)
            .shadow(radius: 5)
        }
    }
    
    private func formattedDate(for index: Int) -> String {
        guard let dateString = forecast.time?[index] else { return "N/A" }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let date = dateFormatter.date(from: dateString) else { return "N/A" }
        
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: date)
    }
    
    private func formattedDay(for index: Int) -> String {
        guard let dateString = forecast.time?[index] else { return "N/A" }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let date = dateFormatter.date(from: dateString) else { return "N/A" }
        
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: date)
    }
    
    private func formattedTime(for timeString: String?) -> String {
        guard let time = timeString else { return "N/A" }
        
        let components = time.components(separatedBy: "T")
        guard components.count == 2 else { return "N/A" }
        
        let timeComponents = components[1].components(separatedBy: ":")
        guard timeComponents.count >= 2 else { return "N/A" }
        
        return "\(timeComponents[0]):\(timeComponents[1])"
    }
    
    private func temperatureText(for temperature: Double?) -> String {
        guard let temp = temperature else { return "N/A" }
        return "\(temp)°C"
    }
    
    
    private func windSpeedText(for speed: Double?) -> String {
        guard let spd = speed else { return "N/A" }
        return "\(spd) km/h"
    }
}

#Preview {
    WeatherForecastView(forecast: Daily.init(), index: 0)
}
