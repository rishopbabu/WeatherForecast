//
//  WeatherRealmModel.swift
//  WeatherForcast
//
//  Created by Rishop Babu on 11/02/24.
//

import Foundation
import RealmSwift


class WeatherRealmModel: Object {
    @objc dynamic var id = "1"
    @objc dynamic var latitude: Double = 0.0
    @objc dynamic var longitude: Double = 0.0
    @objc dynamic var generationtimeMS: Double = 0.0
    @objc dynamic var utcOffsetSeconds: Int = 0
    @objc dynamic var timezone: String = ""
    @objc dynamic var timezoneAbbreviation: String = ""
    @objc dynamic var elevation: Int = 0
    @objc dynamic var currentUnits: CurrentUnitsRealm?
    @objc dynamic var current: CurrentRealm?
    @objc dynamic var dailyUnits: DailyUnitsRealm?
    @objc dynamic var daily: DailyRealm?
    @objc dynamic var location: LocationRealmModel?
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

class LocationRealmModel: Object {
    @objc dynamic var location: String = ""
}

class CurrentRealm: Object {
    @objc dynamic var time: String?
    @objc dynamic var interval: Int = 0
    @objc dynamic var temperature2M: Double = 0.0
    @objc dynamic var isday: Int = 0
}

class CurrentUnitsRealm: Object {
    @objc dynamic var time: String?
    @objc dynamic var interval: String?
    @objc dynamic var temperature2M: String?
    @objc dynamic var isday: String?
}

class DailyRealm: Object {
    let time = List<String>()
    let temperature2MMax = List<Double>()
    let temperature2MMin = List<Double>()
    let sunrise = List<String>()
    let sunset = List<String>()
    let daylightDuration = List<Double>()
    let sunshineDuration = List<Double>()
    let uvIndexMax = List<Double>()
    let uvIndexClearSkyMax = List<Double>()
    let windSpeed10MMax = List<Double>()
    let windGusts10MMax = List<Double>()
    let windDirection10MDominant = List<Int>()
}

class DailyUnitsRealm: Object {
    @objc dynamic var time: String?
    @objc dynamic var temperature2MMax: String?
    @objc dynamic var temperature2MMin: String?
    @objc dynamic var sunrise: String?
    @objc dynamic var sunset: String?
    @objc dynamic var daylightDuration: String?
    @objc dynamic var sunshineDuration: String?
    @objc dynamic var uvIndexMax: String?
    @objc dynamic var uvIndexClearSkyMax: String?
    @objc dynamic var windSpeed10MMax: String?
    @objc dynamic var windGusts10MMax: String?
    @objc dynamic var windDirection10MDominant: String?
}
