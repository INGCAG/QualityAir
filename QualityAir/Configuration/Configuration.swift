//
//  Configuration.swift
//  QualityAir
//
//  Created by Cesar A. Guayara L. on 25/06/2019.
//  Copyright © 2019 INGCAG. All rights reserved.
//

import Foundation

struct DarkSkyAPI{

    static let APIKey = "7609e3f4e69596c09340fcf15d73651d"
    static let BaseURL = URL(string: "https://api.darksky.net/forecast/")!
    //Sample API Call
    //https://api.darksky.net/forecast/7609e3f4e69596c09340fcf15d73651d/37.8267,-122.4233
    
    static var AuthenticatedBaseURL: URL {
        return BaseURL.appendingPathComponent(APIKey)
    }
}

struct DefaultLocation {
        
    static let Latitude: Double = 37.8267
    static let Longitude: Double = -122.423
    
}

struct IoTRestAPI{
    static let metricKey = "metric"
    static let addKey = "add"
    static let countKey = "count"
    static let listAllKey = "lst"
    static let IoTBaseURL = URL(string: "https://master-seu-iot-rest-api.herokuapp.com/")!
//    static let IoTBaseURL = URL(string: "http://192.168.0.14:8080")!
    //Sample API Call
    //https://master-seu-iot-rest-api.herokuapp.com/metric/add
    
    static var AuthenticatedBaseURL: URL {
        return IoTBaseURL.appendingPathComponent(metricKey)
    }
}

struct SensorAPI{
    static let sensorKey = "data"
    static let BaseURL = URL(string: "http://172.20.10.2:80/")!
    //Sample API Call
    //https://master-seu-iot-rest-api.herokuapp.com/sensor/1
    
    static var AuthenticatedBaseURL: URL {
        return BaseURL.appendingPathComponent(sensorKey)
    }
}
