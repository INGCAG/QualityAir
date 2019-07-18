//
//  SensorDataManager.swift
//  QualityAir
//
//  Created by Cesar A. Guayara L. on 02/07/2019.
//  Copyright © 2019 INGCAG. All rights reserved.
//

import Foundation

enum SensorDataManagerError: Error {
    
    case Unknown
    case FailedRequest
    case InvalidResponse
    
}

final class SensorDataManager{
    //    typealias WeatherDataCompletion = (AnyObject?, DataManagerError?) -> ()
    
    typealias SensorDataCompletion = (Sensor?, SensorDataManagerError?) -> ()
    
    let baseURL: URL
    
    // MARK: - Initialization
    
    init(baseURL: URL) {
        self.baseURL = baseURL
    }
    
    // MARK: - Requesting Data
    func sensorDataForId(idSensor: Int, lastTemperature: Double, completion: @escaping SensorDataCompletion){
        var myURL = baseURL
        var request = URLRequest(url: myURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let lt = String(format: "%.2f", lastTemperature)
        let json: [String: Any] = ["sensorTemperature": "\(lt)"]
        let oJsonData = try? JSONSerialization.data(withJSONObject: json)
        request.httpBody = oJsonData
        myURL = baseURL.appendingPathComponent("?plain=\(json)")
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            self.didFetchSensorData1(data: data, response: response, error: error, completion: completion)
            }.resume()
    }
    
    // MARK: - Helper Methods
    //process the response of the network request.
    private func didFetchSensorData1(data: Data?, response: URLResponse?, error: Error?, completion: SensorDataCompletion){
        if let _ = error {
            completion(nil, .FailedRequest)
        } else if let data = data, let response = response as? HTTPURLResponse {
            if response.statusCode == 200 {
                self.processSensorData1(data: data, completion: completion)
            } else {
                completion(nil, .FailedRequest)
            }
        } else {
            completion(nil, .Unknown)
        }
    }
    
    private func processSensorData1(data: Data, completion: SensorDataCompletion) {
        if let JSON = try? JSONSerialization.jsonObject(with: data, options: []) {
            completion(Sensor(JSON: JSON), nil)
        } else {
            completion(nil, .InvalidResponse)
        }
    }
}

