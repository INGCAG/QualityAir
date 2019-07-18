//
//  SecondViewController.swift
//  QualityAir
//
//  Created by Cesar A. Guayara L. on 25/06/2019.
//  Copyright © 2019 INGCAG. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    
    final let GO_TO_VALUES = String("goToValues")
    final let USER_ID = 1
    final let USER_ICON = String("icons/User1.png")
    
    var locationData: [Data]=[]
//    var sendingData : [Data]=[]
//    var days = [WeatherDayData]()
    var days = [Day]()
    var current: Current!
    var dataToSend: DataSend!
    var sensorTemperature: Double!
    var metricId = 0
    
    private let dataManager = DataManager(baseURL: DarkSkyAPI.AuthenticatedBaseURL)
    private let sensorDataManager = SensorDataManager(baseURL: SensorAPI.AuthenticatedBaseURL)
    private let iotRestDataManager = IoTRestDataManager(baseURL: IoTRestAPI.AuthenticatedBaseURL)
    
    @IBOutlet weak var lblTempCelsiusValue: UILabel!
    @IBOutlet weak var lblTempFarenheithValue: UILabel!
    @IBOutlet weak var lblHumidityValue: UILabel!
    @IBOutlet weak var lblWindSpeedValue: UILabel!
    @IBOutlet weak var lblTimeValue: UILabel!
    
    @IBOutlet weak var lblSensTempCelsiusValue: UILabel!
    @IBOutlet weak var lblSensTempFarenheithValue: UILabel!
    
    @IBOutlet weak var txtSensorId: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //setupView()--->
        let location = getSavedLocationJSON()
        // Fetch Weather Data
        fetchWeatherData(loc: location)
//        fetchSensorData()
//        getNewMetricId()
        getLastMetricId()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getSavedLocationJSON() -> MyLocation {
        let lat = DefaultLocation.Latitude
        let lon = DefaultLocation.Longitude
        
        var location = MyLocation(latitude: lat, longitude: lon)
        
        if locationData.count > 0 {
            let decoder = UIKit.JSONDecoder()
            do{
                location = try decoder.decode(MyLocation.self, from: locationData[0])
                print("latitude: " + String(format: "%.6f", location.latitude) + " longitude:" + String(format: "%.6f", location.longitude))
            } catch {
                print("Error saved location data!")
            }
        }
        return location
    }
    // MARK: - Helper Methods
    private func fetchWeatherData(loc: MyLocation) {
        dataManager.weatherDataForLocation(latitude: loc.latitude, longitude: loc.longitude) { (location, error) in
            DispatchQueue.main.async {
                if let location = location {
                    //print(location)
                    self.days = location.days
                    self.current = location.current
                    self.showValues()
                }
            }
        }
    }
    
    private func fetchSensorData(sensorId: Int, lastTemp: Double) -> Bool {
//        let id = 1
//        var lt = 25.4
//        if (self.sensorTemperature != nil) {lt = self.sensorTemperature}
        var res = false
        sensorDataManager.sensorDataForId(idSensor: sensorId, lastTemperature: lastTemp ){(sensor,error) in
            DispatchQueue.main.sync {
                guard let sen = sensor, error == nil else {
                    return
                }
                self.sensorTemperature = sen.sensorTemperature
                self.showValues()
                res = true
            }
        }
        return res
    }
    
    private func showValues(){
        self.lblTempFarenheithValue.text = String(format: "%.2f", current.temperature) + " F"
        self.lblHumidityValue.text = String(format: "%.2f", current.humidity )
        self.lblWindSpeedValue.text = String(format: "%.2f", current.windSpeed )
        
        let tempCelsius = ((current.temperature - 32.0)/1.8)
        self.lblTempCelsiusValue.text = String(format: "%.2f", tempCelsius) + " C"
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss +0000"//2019-06-26 23:25:48 +0000
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "HH:mm:ss"
        
        let hour = dateFormatterPrint.string(from: current.time)
        self.lblTimeValue.text = hour
        
        if ( self.sensorTemperature != nil ) {
            self.lblSensTempCelsiusValue.text = String(format: "%.2f", self.sensorTemperature) + " C"
            let tempFarenheith = ( ( self.sensorTemperature * 1.8) + 32.0)
            self.lblSensTempFarenheithValue.text = String(format: "%.2f", tempFarenheith) + " F"
        }
    }
    
    private func getDataFromSensor(idSensor: Int, lastTemperature: Double) -> Bool{
        return fetchSensorData(sensorId: idSensor, lastTemp: lastTemperature)
    }
    
    private func prepareJSONMessage() -> Data {
        var data: Data!
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let location = getSavedLocationJSON()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        let dt = dateFormatter.string(from: self.current.time)
        
//        getNewMetricId()
//        let metricId = self.metricId
        
        let jsonData = Metric(metricId: 0, latitude: location.latitude, longitude: location.longitude, temperature: self.current.temperature, humidity: self.current.humidity, windSpeed: self.current.windSpeed, dateTime: dt, userId: self.USER_ID, deviceId: 0, icon: self.USER_ICON, sensorTemperature: 0.0)
        
        do {
            data = try encoder.encode(jsonData)
        } catch {
            print("Error preparando JSON!")
        }
        return data
    }
    
    private func sendToServer(m: Metric)->Bool{
        iotRestDataManager.ioTRestDataToMetricsService(metric: m){(metric,error) in
            DispatchQueue.main.sync {
                if let met = metric {
                    print(met)
                }
            }
        }
        return true
    }
    
    @IBAction func goToValues(_ sender: UIButton) {
        performSegue(withIdentifier: GO_TO_VALUES, sender: USER_ID)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (GO_TO_VALUES.elementsEqual(segue.identifier!)){
            let tvc = segue.destination as! ThirdViewController
            tvc.userId = sender as? Int
        }
    }
    
    @IBAction func readSensor(_ sender: UIButton) {
        let val = self.txtSensorId.text
        self.txtSensorId.resignFirstResponder()
        
        if val?.isEmpty ?? true {
            let alert = UIAlertController(title: "¡Aviso!", message: "Ingrese el id del sensor", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Continuar", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        } else{
            let sensorId = Int(val!)!
            let lastTemp = self.sensorTemperature == nil ? 25.5 : self.sensorTemperature as Double
            if getDataFromSensor(idSensor: sensorId, lastTemperature: lastTemp) {
                print("Recibido!")
                self.showValues()
            } else {
                print("Error recibiendo data del sensor!")
                let alert = UIAlertController(title: "¡Aviso!", message: "No se ha podido comunicar con el sensor: " + "\(sensorId)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Continuar", style: .cancel, handler: nil))
                self.present(alert, animated: true)
            }
        }
    }
    @IBAction func saveData(_ sender: UIButton) {
        if (self.sensorTemperature == nil){
            let alert = UIAlertController(title: "¡Aviso!", message: "No hay datos del sensor. Desa añadir valor por defecto?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Si", style: .default, handler: { action in self.saveAll(withDefault: true)}))
            self.present(alert, animated: true)
        } else {
            self.saveAll(withDefault: false)
        }
    }
    
    func saveAll(withDefault: Bool){
        if (withDefault){
            self.sensorTemperature = 25.5
            self.showValues()
        }
        if (self.sensorTemperature != nil){
            let data = prepareJSONMessage()
            let decoder = UIKit.JSONDecoder()
            do{
                var m = Metric(metricId: 0, latitude: 0.0, longitude: 0.0, temperature: 0.0, humidity: 0.0, windSpeed: 0.0, dateTime: "", userId: 0, deviceId: 0, icon: "", sensorTemperature: self.sensorTemperature)
                m = try decoder.decode(Metric.self, from: data)
                let temperatureCelsius = ((m.temperature - 32.0)/1.8)
                let id = self.getNewMetricId()
                print("Nueva medicion: " + "\(id)")
                let metric = Metric(metricId: id, latitude: m.latitude, longitude: m.longitude, temperature: temperatureCelsius, humidity: m.humidity, windSpeed: m.windSpeed, dateTime: m.dateTime, userId: m.userId, deviceId: m.deviceId, icon: m.icon, sensorTemperature: self.sensorTemperature)
                print(metric)
                if sendToServer(m: metric){
                    print("Enviado!")
                    self.getLastMetricId()
                } else {
                    print("Error enviando a servidor")
                }
            } catch {
                print("Error saved location data!")
            }
        }
    }
    
    func getNewMetricId() -> Int{
        print("getId")
        iotRestDataManager.ioTRestDataCountMetrics(){(count,error) in
            DispatchQueue.main.sync {
                if let c = count {
                    print("\(c.metricId)")
                    self.metricId = c.metricId + 1
                }
            }
        }
        return self.metricId
    }
    
    func getLastMetricId(){
        print("getLast")
        var lastId = 0
        if (self.metricId > 0){ lastId = self.metricId - 1}
        iotRestDataManager.ioTRestDataForMetricId(idMetric: lastId){(metric,error) in
            DispatchQueue.main.sync {
                if let m = metric {
                    self.sensorTemperature = m.sensorTemperature
                }
            }
        }
    }
}

