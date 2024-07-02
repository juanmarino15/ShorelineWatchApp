//
//  ContentView.swift
//  ShorelineWatch
//
//  Created by Juan Marino on 6/30/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var locationManager = LocationManager()
    
    var body: some View {
        VStack {
            if let location = locationManager.location {
                Text("Your coordinates are: \(location.longitude), \(location.latitude)")
            } else {
                if locationManager.isLoading {
                    LoadingView()
                }else{
                    WelcomeView()
                        .environmentObject(locationManager)
                }
            }
           
        }
        .background(.black)
        .preferredColorScheme(.dark)
        .padding()
    }
}

#Preview {
    ContentView()
}
