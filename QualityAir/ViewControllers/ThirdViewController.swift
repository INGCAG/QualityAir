//
//  ThirdViewController.swift
//  QualityAir
//
//  Created by Cesar A. Guayara L. on 10/07/2019.
//  Copyright © 2019 INGCAG. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    
    final let url = URL(string: "https://master-seu-iot-rest-api.herokuapp.com/metric/lst")
    
    var mList = [Metric]()
    var userId: Int!
    
    @IBOutlet weak var tblMetrics: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        downloadJson()
//        loadData()
    }
    
    func loadData(){
        self.tblMetrics.reloadData()
    }
    
    func downloadJson(){
        guard let downloadURL = url else {return}
        URLSession.shared.dataTask(with: downloadURL) { ( data, urlResponse, error ) in
            guard let data = data, error == nil, urlResponse != nil else {
                print("Error downloading data")
                return
            }
            print("downloaded")
            do {
                let decoder = JSONDecoder()
                self.mList = try decoder.decode( [Metric].self, from: data)
                DispatchQueue.main.async {
                    self.loadData()
                    print("Data loaded")
                }
            } catch {
                print("Error decoding JSON metrics")
            }
        }.resume()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.mList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellMetric") as? MetricCell else {
            return UITableViewCell()
        }
        cell.lblLatitude.text = String( format:"%.2f", self.mList[indexPath.row].latitude )
        cell.lblLongitude.text = String( format:"%.2f", self.mList[indexPath.row].longitude )
        cell.lblTemperatureCelsius.text = String( format:"%.2f", self.mList[indexPath.row].temperature )
        cell.lblSensorTemperatureCelsius.text = String( format:"%.2f", self.mList[indexPath.row].sensorTemperature )
        
        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
//        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss +0000"
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.000+0000"
        
        guard let dt = dateFormatter.date( from: self.mList[indexPath.row].dateTime ) else { return cell }
        
        let dateFormatterHour = DateFormatter()
        dateFormatterHour.dateFormat = "HH:mm:ss"
        
        let dateFormatterDay = DateFormatter()
        dateFormatterDay.dateFormat = "dd-MMM-yyyy"
        
        let hour = dateFormatterHour.string(from: dt)
        cell.lblHour.text = hour
        
        let day = dateFormatterDay.string(from: dt)
        cell.lblDay.text = day
        
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tblMetrics.estimatedRowHeight = 150
        self.tblMetrics.rowHeight = 150//UITableView.automaticDimension
    }
}
