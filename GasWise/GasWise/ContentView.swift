// ContentView.swift

import SwiftUI
import SwiftData
import CoreLocation
import MapKit

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    
    @State var selectedGasStation: GasStation? = nil
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
                .onAppear {
                    selectedGasStation = nil
                }

            MapView(selectedGasStation: $selectedGasStation)
                .tabItem {
                    Image(systemName: "map")
                    Text("Map View")
                }
        }
    }
}

//#Preview {
//    ContentView()
//}
