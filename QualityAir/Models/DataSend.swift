//
//  DataSend.swift
//  QualityAir
//
//  Created by Cesar A. Guayara L. on 27/06/2019.
//  Copyright © 2019 INGCAG. All rights reserved.
//

import Foundation

struct ItLocation: Codable {
    let latitude: Double
    let longitude: Double
}

struct DataSend: Codable{
    
    let time: Date
    let temperature: Double
    let humidity: Double
    let windSpeed: Double
    let location: ItLocation
}
