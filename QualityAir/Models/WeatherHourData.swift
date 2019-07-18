import Foundation

struct WeatherHourData {
    
    public let time: Date
    public let windSpeed: Int
    public let temperature: Double
    public let precipitation: Double
    public let humidity: Double
    
    public init(time: Date, windSpeed: Int, temperature: Double, precipitation: Double, humidity: Double) {
        self.time = time
        self.windSpeed = windSpeed
        self.temperature = temperature
        self.precipitation = precipitation
        self.humidity = humidity
    }
    
}

extension WeatherHourData: JSONDecodable {
    
    public init?(JSON: Any) {
        guard let JSON = JSON as? [String: AnyObject] else { return nil }
        
        guard let time = JSON["time"] as? Double else { return nil }
        guard let windSpeed = JSON["windSpeed"] as? Int else { return nil }
        guard let temperature = JSON["temperature"] as? Double else { return nil }
        guard let precipitation = JSON["precipitation"] as? Double else { return nil }
        guard let humidity = JSON["humidity"] as? Double else { return nil }
        
        self.windSpeed = windSpeed
        self.temperature = temperature
        self.precipitation = precipitation
        self.humidity = humidity
        self.time = Date(timeIntervalSince1970: time)
    }
    
    /*
    public init(decoder: newJSONDecoder) throws {
        self.windSpeed = try decoder.decode(key: "windSpeed")
        self.temperature = try decoder.decode(key: "temperature")
        self.precipitation = try decoder.decode(key: "precipIntensity")
        self.humidity = try decoder.decode(key: "humidity")
        
        let time: Double = try decoder.decode(key: "time")
        self.time = Date(timeIntervalSince1970: time)
    }
    */
}
