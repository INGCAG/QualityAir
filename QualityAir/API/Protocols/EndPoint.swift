//
//  EndPoint.swift
//  QualityAir
//
//  Created by Cesar A. Guayara L. on 26/06/2019.
//  Copyright © 2019 INGCAG. All rights reserved.
//

import Foundation

protocol EndPoint {
    var baseULR: String { get }
    var path: String { get }
    var queryItems: [URLQueryItem] { get }
}

extension EndPoint{
    var urlComponent: URLComponents {
        var component = URLComponents(string: baseULR)
        component?.path = path
        component?.queryItems = queryItems
        return component!
    }
    
    var request: URLRequest {
        return URLRequest(url: urlComponent.url!)
    }
    
}

enum WeatherEndPoint: EndPoint{
    case tenDayForecast(city:String, state: String)
    
    var baseULR: String {
//        return ""
        return "https://api.wunderground.com"
    }
    
    var path: String{
        switch self {
        case .tenDayForecast(let city, let state):
//            return ""
//            return "/api/c6bb6d63e8547b6e/forecast10day/q/CA/San_Francisco.json"
            return "/api/c6bb6d63e8547b6e/forecast10day/q/\(state)/\(city).json"
        }
    }
    
    var queryItems: [URLQueryItem]{
        return []
    }
}
