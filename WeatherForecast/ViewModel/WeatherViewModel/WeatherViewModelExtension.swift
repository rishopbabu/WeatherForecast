//
//  WeatherViewModelExtension.swift
//  WeatherForcast
//
//  Created by Rishop Babu on 10/02/24.
//

import Foundation
import RealmSwift

extension WeatherViewModel {
    
    func updateWeatherModel(_ weatherReport: WeatherModel) {
        var updatedWeatherData = weatherReport
        
        // Convert all the time formats to local time
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        
        // Update current time
        if let currentTimeString = weatherReport.current?.time,
           let currentTime = dateFormatter.date(from: currentTimeString) {
            dateFormatter.timeZone = TimeZone.autoupdatingCurrent
            let updatedCurrent = Current(time: dateFormatter.string(from: currentTime),
                                         interval: weatherReport.current?.interval,
                                         temperature2M: weatherReport.current?.temperature2M)
            updatedWeatherData.current = updatedCurrent
        }
        
        // Update daily times
        if let sunriseArray = weatherReport.daily?.sunrise,
           let sunsetArray = weatherReport.daily?.sunset {
            for index in 0..<sunriseArray.count {
                if let sunriseTimeUTC = dateFormatter.date(from: sunriseArray[index]),
                   let sunsetTimeUTC = dateFormatter.date(from: sunsetArray[index]) {
                    dateFormatter.timeZone = TimeZone.autoupdatingCurrent
                    let sunriseLocal = sunriseTimeUTC.addingTimeInterval(TimeInterval(TimeZone.autoupdatingCurrent.secondsFromGMT()))
                    let sunsetLocal = sunsetTimeUTC.addingTimeInterval(TimeInterval(TimeZone.autoupdatingCurrent.secondsFromGMT()))
                    updatedWeatherData.daily?.sunrise?[index] = dateFormatter.string(from: sunriseLocal)
                    updatedWeatherData.daily?.sunset?[index] = dateFormatter.string(from: sunsetLocal)
                }
            }
        }
        
        // Round off all double values to two decimal points
        if let currentTemperature = updatedWeatherData.current?.temperature2M {
            updatedWeatherData.current?.temperature2M = round(currentTemperature * 100) / 100
        }
        
        if let dailyTemperatureMax = updatedWeatherData.daily?.temperature2MMax {
            updatedWeatherData.daily?.temperature2MMax = dailyTemperatureMax.map { round($0 * 100) / 100 }
        }
        
        if let dailyTemperatureMin = updatedWeatherData.daily?.temperature2MMin {
            updatedWeatherData.daily?.temperature2MMin = dailyTemperatureMin.map { round($0 * 100) / 100 }
        }
        
        if let dailyUVIndexMax = updatedWeatherData.daily?.uvIndexMax {
            updatedWeatherData.daily?.uvIndexMax = dailyUVIndexMax.map { round($0 * 100) / 100 }
        }
        
        if let dailyUVIndexClearSkyMax = updatedWeatherData.daily?.uvIndexClearSkyMax {
            updatedWeatherData.daily?.uvIndexClearSkyMax = dailyUVIndexClearSkyMax.map { round($0 * 100) / 100 }
        }
        
        if let dailyWindSpeedMax = updatedWeatherData.daily?.windSpeed10MMax {
            updatedWeatherData.daily?.windSpeed10MMax = dailyWindSpeedMax.map { round($0 * 100) / 100 }
        }
        
        if let dailyWindGustsMax = updatedWeatherData.daily?.windGusts10MMax {
            updatedWeatherData.daily?.windGusts10MMax = dailyWindGustsMax.map { round($0 * 100) / 100 }
        }
        
        
        // Convert sunshine and daylight duration to hours and minutes
        if let daylightDurationArray = updatedWeatherData.daily?.daylightDuration {
            updatedWeatherData.daily?.daylightDuration = daylightDurationArray.map { secondsToHours(seconds: Int($0) ) }
        }
        
        if let sunshineDurationArray = updatedWeatherData.daily?.sunshineDuration {
            updatedWeatherData.daily?.sunshineDuration = sunshineDurationArray.map { secondsToHours(seconds: Int($0) ) }
        }
        
        // Assign updated data to weatherData
        self.weatherData = updatedWeatherData
        
    }
    
    // Helper method to convert seconds to hours and minutes
    private func secondsToHoursMinutes(seconds: Int) -> String {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        return "\(hours) hours \(minutes) minutes"
    }
    
    private func secondsToHours(seconds: Int) -> Double {
        return Double(seconds) / 3600.0
    }
    
}


extension WeatherViewModel {
    
    func convertToRealm(weatherModel: WeatherModel) -> WeatherRealmModel {
        let realmModel = WeatherRealmModel()
        realmModel.latitude = weatherModel.latitude ?? 0.0
        realmModel.longitude = weatherModel.longitude ?? 0.0
        realmModel.generationtimeMS = weatherModel.generationtimeMS ?? 0.0
        realmModel.utcOffsetSeconds = weatherModel.utcOffsetSeconds ?? 0
        realmModel.timezone = weatherModel.timezone ?? ""
        realmModel.timezoneAbbreviation = weatherModel.timezoneAbbreviation ?? ""
        realmModel.elevation = weatherModel.elevation ?? 0
        realmModel.currentUnits = convertToRealm(currentUnits: weatherModel.currentUnits)
        realmModel.current = convertToRealm(current: weatherModel.current)
        realmModel.dailyUnits = convertToRealm(dailyUnits: weatherModel.dailyUnits)
        realmModel.daily = convertToRealm(daily: weatherModel.daily)
        return realmModel
    }
    
    func convertToRealm(currentUnits: CurrentUnits?) -> CurrentUnitsRealm? {
        guard let currentUnits = currentUnits else { return nil }
        let realmModel = CurrentUnitsRealm()
        realmModel.time = currentUnits.time
        realmModel.interval = currentUnits.interval ?? ""
        realmModel.temperature2M = currentUnits.temperature2M ?? ""
        realmModel.isday = currentUnits.isday ?? ""
        return realmModel
    }
    
    func convertToRealm(current: Current?) -> CurrentRealm? {
        guard let current = current else { return nil }
        let realmModel = CurrentRealm()
        realmModel.time = current.time
        realmModel.interval = current.interval ?? 0
        realmModel.temperature2M = current.temperature2M ?? 0.0
        realmModel.isday = current.isday ?? 0
        return realmModel
    }
    
    func convertToRealm(dailyUnits: DailyUnits?) -> DailyUnitsRealm? {
        guard let dailyUnits = dailyUnits else { return nil }
        let realmModel = DailyUnitsRealm()
        realmModel.time = dailyUnits.time
        realmModel.temperature2MMax = dailyUnits.temperature2MMax ?? ""
        realmModel.temperature2MMin = dailyUnits.temperature2MMin ?? ""
        realmModel.sunrise = dailyUnits.sunrise ?? ""
        realmModel.sunset = dailyUnits.sunset ?? ""
        realmModel.daylightDuration = dailyUnits.daylightDuration ?? ""
        realmModel.sunshineDuration = dailyUnits.sunshineDuration ?? ""
        realmModel.uvIndexMax = dailyUnits.uvIndexMax ?? ""
        realmModel.uvIndexClearSkyMax = dailyUnits.uvIndexClearSkyMax ?? ""
        realmModel.windSpeed10MMax = dailyUnits.windSpeed10MMax ?? ""
        realmModel.windGusts10MMax = dailyUnits.windGusts10MMax ?? ""
        realmModel.windDirection10MDominant = dailyUnits.windDirection10MDominant ?? ""
        return realmModel
    }
    
    func convertToRealm(daily: Daily?) -> DailyRealm? {
        guard let daily = daily else { return nil }
        let realmModel = DailyRealm()
        realmModel.time.append(objectsIn: daily.time ?? [])
        realmModel.temperature2MMax.append(objectsIn: daily.temperature2MMax ?? [])
        realmModel.temperature2MMin.append(objectsIn: daily.temperature2MMin ?? [])
        realmModel.sunrise.append(objectsIn: daily.sunrise ?? [])
        realmModel.sunset.append(objectsIn: daily.sunset ?? [])
        realmModel.daylightDuration.append(objectsIn: daily.daylightDuration ?? [])
        realmModel.sunshineDuration.append(objectsIn: daily.sunshineDuration ?? [])
        realmModel.uvIndexMax.append(objectsIn: daily.uvIndexMax ?? [])
        realmModel.uvIndexClearSkyMax.append(objectsIn: daily.uvIndexClearSkyMax ?? [])
        realmModel.windSpeed10MMax.append(objectsIn: daily.windSpeed10MMax ?? [])
        realmModel.windGusts10MMax.append(objectsIn: daily.windGusts10MMax ?? [])
        realmModel.windDirection10MDominant.append(objectsIn: daily.windDirection10MDominant ?? [])
        return realmModel
    }
    
    func fetchWeatherDataFromRealm() async -> WeatherModel? {
        do {
            let realm = try await Realm()
            if let weatherRealmModel = realm.objects(WeatherRealmModel.self).first {
                return convertFromRealm(weatherRealmModel)
            } else {
                return nil
            }
        } catch {
            print("Error fetching data from Realm: \(error.localizedDescription)")
            return nil
        }
    }
    
    
    func convertFromRealm(_ realmModel: WeatherRealmModel) -> WeatherModel {
        var weatherModel = WeatherModel()
        weatherModel.latitude = realmModel.latitude
        weatherModel.longitude = realmModel.longitude
        weatherModel.generationtimeMS = realmModel.generationtimeMS
        weatherModel.utcOffsetSeconds = realmModel.utcOffsetSeconds
        weatherModel.timezone = realmModel.timezone
        weatherModel.timezoneAbbreviation = realmModel.timezoneAbbreviation
        weatherModel.elevation = realmModel.elevation
        weatherModel.currentUnits = convertFromRealm(realmModel.currentUnits!)
        weatherModel.current = convertFromRealm(realmModel.current!)
        weatherModel.dailyUnits = convertFromRealm(realmModel.dailyUnits!)
        weatherModel.daily = convertFromRealm(realmModel.daily!)
        weatherModel.currentLocation = realmModel.location?.location
        return weatherModel
    }
    
    func convertFromRealm(_ realmUnits: CurrentUnitsRealm) -> CurrentUnits? {
        guard let time = realmUnits.time, let interval = realmUnits.interval, let temperature2M = realmUnits.temperature2M, let isday = realmUnits.isday else {
            return nil
        }
        return CurrentUnits(time: time, interval: interval, temperature2M: temperature2M, isday: isday)
    }
    
    func convertFromRealm(_ realmCurrent: CurrentRealm) -> Current {
        let time = realmCurrent.time
        let interval = realmCurrent.interval
        let temperature2M = realmCurrent.temperature2M
        let isday = realmCurrent.isday
        
        return Current(time: time, interval: interval, temperature2M: temperature2M, isday: isday)
    }
    
    
    func convertFromRealm(_ realmUnits: DailyUnitsRealm) -> DailyUnits? {
        guard let time = realmUnits.time, let temperature2MMax = realmUnits.temperature2MMax, let temperature2MMin = realmUnits.temperature2MMin, let sunrise = realmUnits.sunrise, let sunset = realmUnits.sunset, let daylightDuration = realmUnits.daylightDuration, let sunshineDuration = realmUnits.sunshineDuration, let uvIndexMax = realmUnits.uvIndexMax, let uvIndexClearSkyMax = realmUnits.uvIndexClearSkyMax, let windSpeed10MMax = realmUnits.windSpeed10MMax, let windGusts10MMax = realmUnits.windGusts10MMax, let windDirection10MDominant = realmUnits.windDirection10MDominant else {
            return nil
        }
        return DailyUnits(time: time, temperature2MMax: temperature2MMax, temperature2MMin: temperature2MMin, sunrise: sunrise, sunset: sunset, daylightDuration: daylightDuration, sunshineDuration: sunshineDuration, uvIndexMax: uvIndexMax, uvIndexClearSkyMax: uvIndexClearSkyMax, windSpeed10MMax: windSpeed10MMax, windGusts10MMax: windGusts10MMax, windDirection10MDominant: windDirection10MDominant)
    }
    
    func convertFromRealm(_ realmDaily: DailyRealm) -> Daily {
        let time = Array(realmDaily.time) // Convert Realm List to Array
        let temperature2MMax = Array(realmDaily.temperature2MMax)
        let temperature2MMin = Array(realmDaily.temperature2MMin)
        let sunrise = Array(realmDaily.sunrise)
        let sunset = Array(realmDaily.sunset)
        let daylightDuration = Array(realmDaily.daylightDuration)
        let sunshineDuration = Array(realmDaily.sunshineDuration)
        let uvIndexMax = Array(realmDaily.uvIndexMax)
        let uvIndexClearSkyMax = Array(realmDaily.uvIndexClearSkyMax)
        let windSpeed10MMax = Array(realmDaily.windSpeed10MMax)
        let windGusts10MMax = Array(realmDaily.windGusts10MMax)
        let windDirection10MDominant = Array(realmDaily.windDirection10MDominant)
        
        return Daily(time: time, temperature2MMax: temperature2MMax, temperature2MMin: temperature2MMin, sunrise: sunrise, sunset: sunset, daylightDuration: daylightDuration, sunshineDuration: sunshineDuration, uvIndexMax: uvIndexMax, uvIndexClearSkyMax: uvIndexClearSkyMax, windSpeed10MMax: windSpeed10MMax, windGusts10MMax: windGusts10MMax, windDirection10MDominant: windDirection10MDominant)
    }
    
}
