//
//  WeatherAPIClient.swift
//  QualityAir
//
//  Created by Cesar A. Guayara L. on 26/06/2019.
//  Copyright © 2019 INGCAG. All rights reserved.
//

import Foundation

class WeatherAPIClient: APIClient {
    var session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func weather(with endPoint: WeatherEndPoint, completion: @escaping (Either<ForecastText, APIError>) -> Void) {
        let request = endPoint.request
        self.fetch(with: request) { (either: Either <Weather, APIError>) in
            switch either {
            case .value(let weather):
                let textForecast = weather.forecast.forecastText
                completion(.value(textForecast))
            case .error(let error):
                completion(.error(error))
            }
        }
    }
}
