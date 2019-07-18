//
//  Current.swift
//  QualityAir
//
//  Created by Cesar A. Guayara L. on 27/06/2019.
//  Copyright © 2019 INGCAG. All rights reserved.
//

import Foundation

struct Current {
    
    let time: Date
    let temperature: Double
    let humidity: Double
    let windSpeed: Double
    
}

extension Current: JSONDecodable {
    
    public init?(JSON: Any) {
        guard let JSON = JSON as? [String: AnyObject] else { return nil }
        
        guard let time = JSON["time"] as? Double else { return nil }
        guard let temperature = JSON["temperature"] as? Double else { return nil }
        guard let humidity = JSON["humidity"] as? Double else { return nil }
        guard let windSpeed = JSON["windSpeed"] as? Double else { return nil }
        
        self.temperature = temperature
        self.humidity = humidity
        self.windSpeed = windSpeed
        self.time = Date(timeIntervalSince1970: time)
    }
    
}
