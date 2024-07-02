import SwiftUI
import CoreLocation

struct ContentView: View {
    @StateObject var locationManager = LocationManager()
    @State private var waveHeight: String = "Loading..."
    @State private var selectedBeach: String = "63rd Street Beach"
    
    let beaches = ["63rd Street Beach", "Montrose Beach", "Ohio Street Beach", "Oak Street Beach"] // Add other beach names as needed
    
    let defaultLocation = (latitude: 41.8781, longitude: -87.6298) // Chicago coordinates
    
    var body: some View {
        VStack {
            Picker("Select a Beach", selection: $selectedBeach) {
                ForEach(beaches, id: \.self) { beach in
                    Text(beach)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .padding()
            
            if let location = locationManager.location {
                Text("Your coordinates are: \(location.longitude), \(location.latitude)")
                    .padding()
                Text("Wave Height: \(waveHeight)")
                    .padding()
                Button("Fetch Wave Height") {
                    Task {
                        await fetchWaveHeight(latitude: location.latitude, longitude: location.longitude, beachName: selectedBeach)
                    }
                }
            } else {
                Text("Using default coordinates: \(defaultLocation.longitude), \(defaultLocation.latitude)")
                    .padding()
                Text("Wave Height: \(waveHeight)")
                    .padding()
                Button("Fetch Wave Height") {
                    Task {
                        await fetchWaveHeight(latitude: defaultLocation.latitude, longitude: defaultLocation.longitude, beachName: selectedBeach)
                    }
                }
                
                if locationManager.isLoading {
                    LoadingView()
                } else {
                    WelcomeView()
                        .environmentObject(locationManager)
                }
            }
        }
        .background(.black)
        .preferredColorScheme(.dark)
        .padding()
        .onAppear {
            if locationManager.location == nil {
                Task {
                    await fetchWaveHeight(latitude: defaultLocation.latitude, longitude: defaultLocation.longitude, beachName: selectedBeach)
                }
            }
        }
    }
    
    @MainActor
    func fetchWaveHeight(latitude: CLLocationDegrees, longitude: CLLocationDegrees, beachName: String) async {
        let weatherManager = WeatherManager()
        do {
            if let waveHeight = try await weatherManager.getCurrentWeather(latitude: latitude, longitude: longitude, beachName: beachName) {
                self.waveHeight = waveHeight.wave_height ?? "No wave height data available"
            } else {
                self.waveHeight = "No wave height data available"
            }
        } catch {
            self.waveHeight = "Failed to fetch wave height: \(error)"
        }
    }
}

#Preview {
    ContentView()
}
