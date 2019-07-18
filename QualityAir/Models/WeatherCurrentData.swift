import Foundation

struct WeatherCurrentData {
    
    public let temperature: Double
    public let humidity: Double

    public init(temperature: Double, humidity: Double) {
        self.temperature = temperature
        self.humidity = humidity
    }
    
}

extension WeatherCurrentData: JSONDecodable {
   
    public init?(JSON: Any) {
        guard let JSON = JSON as? [String: AnyObject] else { return nil }
        
        guard let temperature = JSON["temperature"] as? Double else { return nil }
        guard let humidity = JSON["humidity"] as? Double else { return nil }
        
        self.temperature = temperature
        self.humidity = humidity
    }
    /*
    public init(decoder: newJSONDecoder) throws {
        self.temperature = try decoder.decode(key: "temperature")
        self.humidity = try decoder.decode(key: "humidity")
       }
 */
    
}
