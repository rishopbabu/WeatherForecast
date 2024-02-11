//
//  GetWeatherDetails.swift
//  WeatherForcast
//
//  Created by Rishop Babu on 10/02/24.
//

import Foundation
import CoreLocation

final class GetWeatherDetails {
    
    static func getWeatherReportData(_ lat: CLLocationDegrees, _ long: CLLocationDegrees) async throws -> WeatherModel {
        let urlString = "https://api.open-meteo.com/v1/forecast?latitude=\(lat)&longitude=\(long)&current=temperature_2m,is_day&daily=temperature_2m_max,temperature_2m_min,sunrise,sunset,daylight_duration,sunshine_duration,uv_index_max,uv_index_clear_sky_max,wind_speed_10m_max,wind_gusts_10m_max,wind_direction_10m_dominant&timezone=auto"
        
        guard let url = URL(string: urlString) else {
            throw ErrorCases.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse,
              response.statusCode == 200 else {
            throw ErrorCases.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            let weatherModel = try decoder.decode(WeatherModel.self, from: data)
            return weatherModel
        } catch {
            throw ErrorCases.invalidData
        }
    }
    
}

