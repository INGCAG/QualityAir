//
//  Sensor.swift
//  QualityAir
//
//  Created by Cesar A. Guayara L. on 01/07/2019.
//  Copyright © 2019 INGCAG. All rights reserved.
//

import Foundation

struct Sensor {
    let sensorId: Int
    let sensorTemperature: Double
}

extension Sensor: JSONDecodable {
    public init?(JSON: Any) {
        guard let JSON = JSON as? [String: AnyObject] else { return nil }
        
        guard let id = JSON["sensorId"] as? Int else { return nil }
        guard let temp = JSON["sensorTemperature"] as? Double else { return nil }
        
        self.sensorId = id
        self.sensorTemperature = temp
    }
}
