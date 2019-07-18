//
//  Day.swift
//  QualityAir
//
//  Created by Cesar A. Guayara L. on 26/06/2019.
//  Copyright © 2019 INGCAG. All rights reserved.
//

import Foundation

struct WeatherDayData {
    
    let date: Date
    let min: Double
    let max: Double
    
}

extension WeatherDayData: JSONDecodable {
    public init?(JSON: Any) {
        guard let JSON = JSON as? [String: AnyObject] else { return nil }
        
        guard let time = JSON["time"] as? Double else { return nil }
        guard let min = JSON["temperatureMin"] as? Double else { return nil }
        guard let max = JSON["temperatureMax"] as? Double else { return nil }
        
        self.min = min
        self.max = max
        self.date = Date(timeIntervalSince1970: time)
    }
 /*
    public init(decoder: newJSONDecoder) throws {
        self.min = try decoder.decode(key: "temperatureMin")
        self.max = try decoder.decode(key: "temperatureMax")
        
        let date: Double = try decoder.decode(key: "time")
        self.date = Date(timeIntervalSince1970: date)
    }
    */
}
