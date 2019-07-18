//
//  Weather.swift
//  QualityAir
//
//  Created by Cesar A. Guayara L. on 26/06/2019.
//  Copyright © 2019 INGCAG. All rights reserved.
//

import Foundation

class Weather: Codable{
    let forecast: Forecast
}

struct Forecast: Codable {
    let forecastText: ForecastText
    
    public enum CodingKeys: String, CodingKey{
        case forecastText = "txt_forecast"
    }
}

struct ForecastText: Codable {
    let date: String
    let forecastDays: [ForecastDay]
    
    public enum CodingKeys: String, CodingKey{
        case date = "date"
        case forecastDays = "forecastdays"
    }
}

struct ForecastDay: Codable{
    let iconUrl: URL
    let day: String
    let description: String
    
    public enum CodingKeys: String, CodingKey{
        case iconUrl = "icon_url"
        case day = "title"
        case description = "fcttext"
    }
}
