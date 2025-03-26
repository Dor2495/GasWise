// ContentView.swift

import SwiftUI
import SwiftData
import CoreLocation
import MapKit

struct ContentView: View {
    @StateObject private var viewModel: VehicleViewModel
    
    init(modelContext: ModelContext) {
        _viewModel = StateObject(wrappedValue: VehicleViewModel(modelContext: modelContext))
    }
    
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
        .environmentObject(viewModel)
    }
}

//#Preview {
//    ContentView()
//}
