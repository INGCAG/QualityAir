//
//  APIClient.swift
//  QualityAir
//
//  Created by Cesar A. Guayara L. on 26/06/2019.
//  Copyright © 2019 INGCAG. All rights reserved.
//

import Foundation

enum Either <V,E: Error> {
    case value(V)
    case error(E)
}

enum APIError: Error {
    case apiError
    case badResponse
    case jsonDecoder
    case unknown(String)
}

protocol APIClient {
    var session: URLSession { get }
    func fetch <V: Codable> (with request: URLRequest, completition:@escaping(Either<V,APIError>) -> Void)
}

extension APIClient {
    func fetch <V: Codable> (with request: URLRequest, completition:@escaping(Either<V,APIError>) -> Void){
        
        let task = session.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                completition(.error(.apiError))
                return
            }
        
            guard let response = response as? HTTPURLResponse, 200..<300 ~= response.statusCode else {
                completition(.error(.badResponse))
                return
            }
            
            guard let value = try?JSONDecoder().decode(V.self, from: data!) else {
                completition(.error(.jsonDecoder))
                return
            }
            
            completition(.value(value))
        }
        task.resume()
    }
}
