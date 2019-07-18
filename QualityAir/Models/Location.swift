//
//  Location.swift
//  QualityAir
//
//  Created by Cesar A. Guayara L. on 26/06/2019.
//  Copyright © 2019 INGCAG. All rights reserved.
//
import Foundation

struct Location {
    
    let lat: Double
    let long: Double
    
    let days: [Day]
    let current: Current
    
}

extension Location: JSONDecodable {
    
    init?(JSON: Any) {
        guard let JSON = JSON as? [String: AnyObject] else { return nil }
        
        guard let lat = JSON["latitude"] as? Double else { return nil }
        guard let long = JSON["longitude"] as? Double else { return nil }
        guard let dailyData = JSON["daily"]?["data"] as? [[String: AnyObject]] else { return nil }
        
        self.lat = lat
        self.long = long
        
        var buffer = [Day]()
        
        
        for dailyDataPoint in dailyData {
            if let day = Day(JSON: dailyDataPoint) {
                buffer.append(day)
            }
        }
        
        self.days = buffer
        
        guard let currently = JSON["currently"] else { return nil }
        
        self.current = Current(JSON: currently)!
    }
    
}


/*
struct Location {
    
    let lat: Double
    let long: Double
    
    let weatherCurrentData: [WeatherCurrentData]
    let weatherDayData: [WeatherDayData]
    let weatherHourData: [WeatherHourData]
    
}

extension Location: JSONDecodable {
    public init(decoder: newJSONDecoder) throws {
        self.lat = try decoder.decode(key: "latitude")
        self.long = try decoder.decode(key: "longitude")
        self.weatherCurrentData = try decoder.decode(key: "currently.data")
        self.weatherDayData = try decoder.decode(key: "daily.data")
        self.weatherHourData = try decoder.decode(key: "hourly.data")
    }
}
 */
