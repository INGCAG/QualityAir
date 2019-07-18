//
//  Metric.swift
//  QualityAir
//
//  Created by Cesar A. Guayara L. on 01/07/2019.
//  Copyright © 2019 INGCAG. All rights reserved.
//

import Foundation

/*
 "metricId": 5,
 "latitude": "-0.878710",
 "longitude": "41.686731",
 "temperature": "30.45",
 "humidity": "0.32",
 "windSpeed": "0.40",
 "dateTime": "2019-06-28T09:17:35",
 "userId": 1,
 "deviceId": 1,
 "icon": "icons/User1.png"
 */

struct Metric:Codable{
    let metricId: Int
    let latitude: Double
    let longitude: Double
    let temperature: Double
    let humidity: Double
    let windSpeed: Double
    let dateTime: String
    let userId: Int
    let deviceId: Int
    let icon: String
    let sensorTemperature: Double
}

extension Metric: JSONDecodable {
    
    public init?(JSON: Any) {
        guard let JSON = JSON as? [String: AnyObject] else { return nil }
        
        guard let metricId = JSON["metricId"] as? Int else { return nil }
        guard let latitude = JSON["latitude"] as? Double else { return nil }
        guard let longitude = JSON["longitude"] as? Double else { return nil }
        guard let temperature = JSON["temperature"] as? Double else { return nil }
        guard let humidity = JSON["humidity"] as? Double else { return nil }
        guard let windSpeed = JSON["windSpeed"] as? Double else { return nil }
        guard let dateTime = JSON["dateTime"] as? String else { return nil }
        guard let userId = JSON["userId"] as? Int else { return nil }
        guard let deviceId = JSON["deviceId"] as? Int else { return nil }
        guard let icon = JSON["icon"] as? String else { return nil }
        guard let sensorTemperature = JSON["sensorTemperature"] as? Double else { return nil }
        
        self.metricId = metricId
        self.latitude = latitude
        self.longitude = longitude
        self.temperature = temperature
        self.humidity = humidity
        self.windSpeed = windSpeed
        self.dateTime = dateTime
        self.userId = userId
        self.deviceId = deviceId
        self.icon = icon
        self.sensorTemperature = sensorTemperature
    }
    
}
