//
//  WeatherModel.swift
//  WeatherForcast
//
//  Created by Rishop Babu on 10/02/24.
//

import Foundation

// MARK: - WeatherModel
struct WeatherModel: Codable {
    var latitude, longitude, generationtimeMS: Double?
    var utcOffsetSeconds: Int?
    var timezone, timezoneAbbreviation: String?
    var elevation: Int?
    var currentUnits: CurrentUnits?
    var current: Current?
    var dailyUnits: DailyUnits?
    var daily: Daily?
    var currentLocation: String?
    
    enum CodingKeys: String, CodingKey {
        case latitude, longitude
        case generationtimeMS = "generationtime_ms"
        case utcOffsetSeconds = "utc_offset_seconds"
        case timezone
        case timezoneAbbreviation = "timezone_abbreviation"
        case elevation
        case currentUnits = "current_units"
        case current
        case dailyUnits = "daily_units"
        case daily
        case currentLocation
    }
}

// MARK: - Current
struct Current: Codable {
    var time: String?
    var interval: Int?
    var temperature2M: Double?
    var isday: Int?
    
    enum CodingKeys: String, CodingKey {
        case time, interval
        case temperature2M = "temperature_2m"
        case isday = "is_day"
    }
}

// MARK: - CurrentUnits
struct CurrentUnits: Codable {
    var time, interval, temperature2M, isday: String?
    
    enum CodingKeys: String, CodingKey {
        case time, interval
        case temperature2M = "temperature_2m"
        case isday = "is_day"
    }
}

// MARK: - Daily
struct Daily: Codable {
    var time: [String]?
    var temperature2MMax, temperature2MMin: [Double]?
    var sunrise, sunset: [String]?
    var daylightDuration, sunshineDuration, uvIndexMax, uvIndexClearSkyMax: [Double]?
    var windSpeed10MMax, windGusts10MMax: [Double]?
    var windDirection10MDominant: [Int]?
    
    enum CodingKeys: String, CodingKey {
        case time
        case temperature2MMax = "temperature_2m_max"
        case temperature2MMin = "temperature_2m_min"
        case sunrise, sunset
        case daylightDuration = "daylight_duration"
        case sunshineDuration = "sunshine_duration"
        case uvIndexMax = "uv_index_max"
        case uvIndexClearSkyMax = "uv_index_clear_sky_max"
        case windSpeed10MMax = "wind_speed_10m_max"
        case windGusts10MMax = "wind_gusts_10m_max"
        case windDirection10MDominant = "wind_direction_10m_dominant"
    }
}

// MARK: - DailyUnits
struct DailyUnits: Codable {
    var time, temperature2MMax, temperature2MMin, sunrise: String?
    var sunset, daylightDuration, sunshineDuration, uvIndexMax: String?
    var uvIndexClearSkyMax, windSpeed10MMax, windGusts10MMax, windDirection10MDominant: String?
    
    enum CodingKeys: String, CodingKey {
        case time
        case temperature2MMax = "temperature_2m_max"
        case temperature2MMin = "temperature_2m_min"
        case sunrise, sunset
        case daylightDuration = "daylight_duration"
        case sunshineDuration = "sunshine_duration"
        case uvIndexMax = "uv_index_max"
        case uvIndexClearSkyMax = "uv_index_clear_sky_max"
        case windSpeed10MMax = "wind_speed_10m_max"
        case windGusts10MMax = "wind_gusts_10m_max"
        case windDirection10MDominant = "wind_direction_10m_dominant"
    }
}

