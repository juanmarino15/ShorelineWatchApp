import Foundation
import CoreLocation

struct WaveHeight: Codable {
    let measurement_timestamp: String
    let wave_height: String?
    
    enum CodingKeys: String, CodingKey {
        case measurement_timestamp
        case wave_height = "waveheight_ft" // Update this key based on the actual JSON response
    }
}

class WeatherManager {
    let appToken = "hhQnFt04xfik6LEaFhHXOBG1D" // Replace with your actual app token
    
    func getCurrentWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees, beachName: String) async throws -> WaveHeight? {
        // Get the current date and the first day of the current month
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        
        let today = Date()
        let calendar = Calendar.current
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: today))!
        
        let todayString = dateFormatter.string(from: today)
        let startOfMonthString = dateFormatter.string(from: startOfMonth)
        
        print(startOfMonthString)
        let urlString = "https://data.cityofchicago.org/resource/qmqz-2xku.json?beach_name=\(beachName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&measurement_timestamp=2024-07-02T08:00:00.000"
        guard let url = URL(string: urlString) else {
            fatalError("Missing URL")
        }
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(appToken, forHTTPHeaderField: "X-App-Token")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        // Print the JSON response for debugging
        if let jsonString = String(data: data, encoding: .utf8) {
            print("JSON Response: \(jsonString)")
        }
        
        let waveHeightData = try JSONDecoder().decode([WaveHeight].self, from: data)
        let validWaveHeightData = waveHeightData.filter { $0.wave_height != nil }
        let sortedData = validWaveHeightData.sorted { $0.measurement_timestamp > $1.measurement_timestamp }
        return sortedData.first
    }
}
