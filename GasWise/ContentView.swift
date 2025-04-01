// ContentView.swift

import SwiftUI
import SwiftData
import CoreLocation
import MapKit

struct ContentView: View {
    @State private var navigationManager = ContentViewNavigationManager()
    @Environment(\.modelContext) private var modelContext
    
    @Query private var garage: [Vehicle]
    
    var body: some View {
        TabView(selection: $navigationManager.selectedTab) {

            Tab("Garage", systemImage: "house.fill", value: .garage) {
                GarageScreen(onDeleteVehicle: deleteVehicle) {
                    navigationManager.showAddVehicleSheet = true
                }
            }
            
            Tab("Bills", systemImage: "list.bullet", value: .bills) {
                BillsScreen(deleteRefueling: deleteRefueling) {
                    navigationManager.showAddRefuelingSheet = true
                } showPopView: {
                    garage.isEmpty
                } pop: { _ in
                    navigationManager.showAddVehicleSheet = true
                    navigationManager.selectedTab = .garage
                }
            }
            
            Tab("Map", systemImage: "map", value: .map) {
                StationOnMapScreen()
            }
        }
        .sheet(isPresented: $navigationManager.showAddRefuelingSheet) {
            AddNewRefuelingView(saveRefueling: addRefueling)
        }
        
        .sheet(isPresented: $navigationManager.showAddVehicleSheet) {
            AddVehicleView(saveVehicle: addVehicle)
        }
    }
    
    private func addVehicle(_ vehicle: Vehicle) {
        modelContext.insert(vehicle)
        try? modelContext.save()
        print("Vehicle added: \(vehicle.plateNumber)")
    }
    
    private func deleteVehicle(_ vehicle: Vehicle) {
        modelContext.delete(vehicle)
        try? modelContext.save()
        print("Vehicle deleted \(vehicle.plateNumber)")
    }
    
    private func addRefueling(_ refueling: Refueling) {
        modelContext.insert(refueling)
        try? modelContext.save()
        print("Refueling added: \(refueling.date)")
    }
    
    private func deleteRefueling(_ refueling: Refueling) {
        modelContext.delete(refueling)
        try? modelContext.save()
        print("Refueling deleted \(refueling.totalPrice)")
    }
    
}

@Observable
class ContentViewNavigationManager {
    
    var selectedTab: Tabs = .garage
    var showAddVehicleSheet = false
    var showAddRefuelingSheet = false
    
    enum Tabs {
        case garage
        case bills
        case map
    }
}

#Preview {
    ContentView()
}
