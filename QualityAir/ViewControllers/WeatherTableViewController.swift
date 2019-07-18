//
//  WeatherTableViewController.swift
//  QualityAir
//
//  Created by Cesar A. Guayara L. on 26/06/2019.
//  Copyright © 2019 INGCAG. All rights reserved.
//

import UIKit

class WeatherTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let weatherAPI = WeatherAPIClient()
        let wetaherEndPoint = WeatherEndPoint.tenDayForecast(city: "Boston", state: "MA")
        weatherAPI.weather(with: wetaherEndPoint) { (either) in
            switch either {
                case .value(let forecastText):
                    print(forecastText)
                case .error(let error):
                    print(error)
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath)

        // Configure the cell...

        return cell
    }
}
