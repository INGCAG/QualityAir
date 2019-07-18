//
//  ViewController.swift
//  QualityAir
//
//  Created by Cesar A. Guayara L. on 25/06/2019.
//  Copyright © 2019 INGCAG. All rights reserved.
//

import UIKit
import CoreLocation

struct MyLocation: Codable{
    let latitude: Double
    let longitude: Double
}

class RootViewController: UIViewController, CLLocationManagerDelegate {

    let GO_TO_WEATHER = String("goToWeather")
    let GO_TO_WEATHER_TABLE = String("goToWeatherTable")
    var locationValues : [Data]=[]
    
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var lblLatitude: UILabel!
    @IBOutlet weak var lblLongitude: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //for use when the application is open and is in background
        locationManager.requestAlwaysAuthorization()
        
        //for use when the application is open
        //locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first{
            
            let lat : Double = location.coordinate.latitude
            let lon : Double = location.coordinate.longitude
            
            saveLocationJSON(latitude: lat, longitude: lon)
            
            self.lblLatitude.text = String(format: "%.6f", lat)
            self.lblLongitude.text = String(format: "%.6f", lon)
        }
    }
    
    @IBAction func goToWeather(_ sender: Any) {
        performSegue(withIdentifier: GO_TO_WEATHER, sender: self.locationValues)
    }
    
    @IBAction func goToWeatherTable(_ sender: Any) {
        performSegue(withIdentifier: GO_TO_WEATHER_TABLE, sender: self.locationValues)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (GO_TO_WEATHER.elementsEqual(segue.identifier!)){
            let svc = segue.destination as! SecondViewController
            svc.locationData = sender as! [Data]
        } else if (GO_TO_WEATHER_TABLE.elementsEqual(segue.identifier!)){
            print("Hecho!")
        } else {
           //other view controller
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func saveLocationJSON(latitude: Double, longitude: Double){
        let jsonLocation = MyLocation(latitude: latitude, longitude: longitude)
        do{
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(jsonLocation)
            if locationValues.count > 0 { locationValues.removeLast() }
            locationValues.append(data)
        } catch{
            print("Error saving location JSON!")
        }
    }
}

