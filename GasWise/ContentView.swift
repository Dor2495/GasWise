// ContentView.swift

import SwiftUI
import SwiftData
import CoreLocation
import MapKit

/// The main view controller for the GasWise application.
///
/// `ContentView` serves as the primary container for the app's interface,
/// implementing a tab-based navigation system with the following sections:
/// - Garage: Displays and manages user vehicles
/// - Bills: Shows refueling history and expenses
/// - Map: Provides geographic visualization of gas stations
///
/// This view also manages the app's navigation state and provides data management
/// functions for vehicles and refueling records using SwiftData.
struct ContentView: View {
    /// Manager for handling navigation state within the ContentView.
    @State private var navigationManager = ContentViewNavigationManager()
    
    /// The SwiftData model context for database operations.
    @Environment(\.modelContext) private var modelContext
    
    /// Query to retrieve all vehicles from the database.
    @Query private var garage: [Vehicle]
    
    /// The body of the ContentView, defining the tab-based interface and sheets.
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
    
    /// Adds a new vehicle to the database.
    ///
    /// - Parameter vehicle: The vehicle object to add.
    private func addVehicle(_ vehicle: Vehicle) {
        modelContext.insert(vehicle)
        try? modelContext.save()
        print("Vehicle added: \(vehicle.plateNumber)")
    }
    
    /// Deletes a vehicle from the database.
    ///
    /// This operation will also cascade delete all associated refueling records
    /// due to the relationship configuration in the Vehicle model.
    ///
    /// - Parameter vehicle: The vehicle object to delete.
    private func deleteVehicle(_ vehicle: Vehicle) {
        modelContext.delete(vehicle)
        try? modelContext.save()
        print("Vehicle deleted \(vehicle.plateNumber)")
    }
    
    /// Adds a new refueling record to the database.
    ///
    /// - Parameter refueling: The refueling object to add.
    private func addRefueling(_ refueling: Refueling) {
        modelContext.insert(refueling)
        try? modelContext.save()
        print("Refueling added: \(refueling.date)")
    }
    
    /// Deletes a refueling record from the database.
    ///
    /// - Parameter refueling: The refueling object to delete.
    private func deleteRefueling(_ refueling: Refueling) {
        modelContext.delete(refueling)
        try? modelContext.save()
        print("Refueling deleted \(refueling.totalPrice)")
    }
    
}

/// Observable class that manages navigation state for the ContentView.
///
/// This class tracks the currently selected tab and controls the visibility
/// of modal sheets for adding vehicles and refueling records.
@Observable
class ContentViewNavigationManager {
    
    /// The currently selected tab in the main interface.
    var selectedTab: Tabs = .garage
    
    /// Flag controlling visibility of the add vehicle sheet.
    var showAddVehicleSheet = false
    
    /// Flag controlling visibility of the add refueling sheet.
    var showAddRefuelingSheet = false
    
    /// Enumeration defining the available tabs in the main interface.
    enum Tabs {
        /// The garage tab showing vehicle management.
        case garage
        
        /// The bills tab showing refueling history.
        case bills
        
        /// The map tab showing geographic data.
        case map
    }
}

#Preview {
    ContentView()
}
