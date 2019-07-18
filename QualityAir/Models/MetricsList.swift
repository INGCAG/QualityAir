//
//  MetricsList.swift
//  QualityAir
//
//  Created by Cesar A. Guayara L. on 10/07/2019.
//  Copyright © 2019 INGCAG. All rights reserved.
//

import Foundation

struct MetricsList: Codable {
    
    let metrics: [Metric]
    
}

extension MetricsList: JSONDecodable {
    
    init?(JSON: Any) {
        guard let JSON = JSON as? [String: AnyObject] else { return nil }
        
//        guard let metricData = JSON["metrics"] as? [[String: AnyObject]] else { return nil }
        
        var buffer = [Metric]()
        
        
        for metricDataPoint in JSON {
            if let metric = Metric(JSON: metricDataPoint) {
                buffer.append(metric)
            }
        }
        
        self.metrics = buffer
    }
    
}
