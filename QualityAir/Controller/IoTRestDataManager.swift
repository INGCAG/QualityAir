//
//  IoTRestDataManager.swift
//  QualityAir
//
//  Created by Cesar A. Guayara L. on 03/07/2019.
//  Copyright © 2019 INGCAG. All rights reserved.
//

import Foundation

enum IoTRestDataManagerError: Error {
    
    case Unknown
    case FailedRequest
    case InvalidResponse
    
}

final class IoTRestDataManager{
    //    typealias WeatherDataCompletion = (AnyObject?, DataManagerError?) -> ()
    
    typealias IoTRestDataCompletion = (Metric?, IoTRestDataManagerError?) -> ()
    typealias IoTRestDataListCompletion = (MetricsList?, IoTRestDataManagerError?) -> ()
    
    let iotBaseURL: URL
    
    // MARK: - Initialization
    
    init(baseURL: URL) {
        self.iotBaseURL = baseURL
    }
    
    // MARK: - Requesting Data
    func ioTRestDataForMetricId(idMetric: Int, completion: @escaping IoTRestDataCompletion){
        let myURL = iotBaseURL.appendingPathComponent("\(idMetric)")
        var request = URLRequest(url: myURL)
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: myURL) { (data, response, error) in
            self.didFetchIoTRestData(data: data, response: response, error: error, completion: completion)
            }.resume()
    }
    
    func ioTRestDataForAll(completion: @escaping IoTRestDataListCompletion){
        let myURL = iotBaseURL.appendingPathComponent(IoTRestAPI.listAllKey)
        var request = URLRequest(url: myURL)
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: myURL) { (data, response, error) in
            self.didFetchListData(data: data, response: response, error: error, completion: completion)
            }.resume()
    }
    
    // MARK: - Helper Methods
    //process the response of the network request.
    private func didFetchIoTRestData(data: Data?, response: URLResponse?, error: Error?, completion: IoTRestDataCompletion){
        if let _ = error {
            completion(nil, .FailedRequest)
        } else if let data = data, let response = response as? HTTPURLResponse {
            if response.statusCode == 200 {
                processIoTRestMetricData(data: data, completion: completion)
            } else {
                completion(nil, .FailedRequest)
            }
        } else {
            completion(nil, .Unknown)
        }
    }
    
    private func processIoTRestMetricData(data: Data, completion: IoTRestDataCompletion) {
        if let JSON = try? JSONSerialization.jsonObject(with: data, options: []) {
            completion(Metric(JSON: JSON), nil)
        } else {
            completion(nil, .InvalidResponse)
        }
    }
    
    private func processIoTRestMetricListData(data: Data, completion: IoTRestDataListCompletion) {
        if let JSON = try? JSONSerialization.jsonObject(with: data, options: []) {
            completion(MetricsList(JSON: JSON), nil)
        } else {
            completion(nil, .InvalidResponse)
        }
    }
    
    func ioTRestDataToMetricsService(metric: Metric, completion: @escaping IoTRestDataCompletion){
        let myURL = iotBaseURL.appendingPathComponent(IoTRestAPI.addKey)
        var request = URLRequest(url: myURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")//;charset=UTF-8
        request.setValue("*/*", forHTTPHeaderField: "Accept")
        request.setValue("POST", forHTTPHeaderField: "Access-Control-Allow-Methods")
        
        let lat = (String(format: "%.6f", metric.latitude) as NSString).doubleValue
        let lon = (String(format: "%.6f", metric.longitude) as NSString).doubleValue
        
//        let json: [String: Any] = ["metricId": "9",
//                                   "temperature": "35.34",
//                                   "humidity": "0.52",
//                                   "windSpeed": "1.64",
//                                   "dateTime": "2019-06-27T10:56:01.000+0000",
//                                   "icon": "icons/User2.png",
//                                   "userId": "1",
//                                   "deviceId": "1",
//                                   "latitude": lat,
//                                   "longitude": lon,
//                                   "sensorTemperature": "25.2"]
//        let oJsonData = try? JSONSerialization.data(withJSONObject: json)
//        request.httpBody = oJsonData
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let jsonData = Metric(metricId: metric.metricId, latitude: lat, longitude: lon, temperature: metric.temperature, humidity: metric.humidity, windSpeed: metric.windSpeed, dateTime: metric.dateTime, userId: metric.userId, deviceId: metric.deviceId, icon: metric.icon, sensorTemperature: metric.sensorTemperature)

        do {
            let data = try encoder.encode(jsonData)
            request.httpBody = data
        } catch {
            print("Error preparando JSON para el servidor!")
        }
//        request.setValue((request.httpBody?.count as! NSNumber).stringValue , forHTTPHeaderField: "content-length")
//        print(request.httpMethod as Any)
//        URLSession.shared.dataTask(with: myURL) { (data, response, error) in
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            self.didSendIoTRestData(data: data, response: response, error: error, completion: completion)
            }.resume()
    }
    
    private func didSendIoTRestData(data: Data?, response: URLResponse?, error: Error?, completion: IoTRestDataCompletion){
            if let _ = error {
            completion(nil, .FailedRequest)
        } else if let data = data, let response = response as? HTTPURLResponse {
            guard (200 ... 299) ~= response.statusCode else {                    // check for http errors
                print("statusCode should be 2xx, but is \(response.statusCode)")
                print("response = \(response)")
                completion(nil, .FailedRequest)
                return
            }
            processIoTRestMetricData(data: data, completion: completion)
        } else {
            completion(nil, .Unknown)
        }
    }
    
    func ioTRestDataCountMetrics(completion: @escaping IoTRestDataCompletion){
        let myURL = iotBaseURL.appendingPathComponent(IoTRestAPI.countKey)
        var request = URLRequest(url: myURL)
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: myURL) { (data, response, error) in
            self.didFetchCountData(data: data, response: response, error: error, completion: completion)
            }.resume()
    }
    
    private func didFetchCountData(data: Data?, response: URLResponse?, error: Error?, completion: IoTRestDataCompletion){
        if let _ = error {
            completion(nil, .FailedRequest)
        } else if let data = data, let response = response as? HTTPURLResponse {
            guard (200 ... 299) ~= response.statusCode else {                    // check for http errors
                print("statusCode should be 2xx, but is \(response.statusCode)")
                print("response = \(response)")
                completion(nil, .FailedRequest)
                return
            }
            let count = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: count))")
            completion(Metric(metricId: Int(count!)! , latitude: 0.0, longitude: 0.0, temperature: 0.0, humidity: 0.0, windSpeed: 0.0, dateTime: "", userId: 0, deviceId: 0, icon: "", sensorTemperature: 0), nil)
        } else {
            completion(nil, .Unknown)
        }
    }
    
    private func didFetchListData(data: Data?, response: URLResponse?, error: Error?, completion: IoTRestDataListCompletion){
        if let _ = error {
            completion(nil, .FailedRequest)
        } else if let data = data, let response = response as? HTTPURLResponse {
            guard (200 ... 299) ~= response.statusCode else {                    // check for http errors
                print("statusCode should be 2xx, but is \(response.statusCode)")
                print("response = \(response)")
                completion(nil, .FailedRequest)
                return
            }
            processIoTRestMetricListData(data: data, completion: completion)
        } else {
            completion(nil, .Unknown)
        }
    }
}

