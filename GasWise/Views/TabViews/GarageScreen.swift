//
//  RefuelingListSection.swift
//  GasWise
//
//  Created by Dor Mizrachi on 25/03/2025.
//
import SwiftUI
import SwiftData
import Charts

/// A view that displays the user's vehicle garage and related statistics.
///
/// `GarageScreen` is the primary interface for viewing and managing vehicles in the app.
/// It provides:
/// - A list of all vehicles in the garage
/// - Access to vehicle details and statistics
/// - Options to add and delete vehicles
///
/// This view is designed to handle both populated and empty states gracefully,
/// showing appropriate UI elements based on the current data state.
struct GarageScreen: View {
    /// Query to retrieve all vehicles from the database.
    @Query private var garage: [Vehicle]
    
    /// Query to retrieve all refueling records from the database.
    @Query private var bills: [Refueling]
    
    /// Callback function used when deleting a vehicle.
    var onDeleteVehicle: (Vehicle) -> Void?
    
    /// Callback function to show the add vehicle sheet.
    var showAddVehicleSheet: (() -> Void)?
    
    /// Initializes the garage screen with the required callbacks.
    ///
    /// - Parameters:
    ///   - onDeleteVehicle: Callback function executed when a vehicle is deleted
    ///   - showAddVehicleSheet: Optional callback to show the add vehicle sheet
    init(onDeleteVehicle: @escaping (Vehicle) -> Void, showAddVehicleSheet: (() -> Void)? = nil) {
        self.showAddVehicleSheet = showAddVehicleSheet
        self.onDeleteVehicle = onDeleteVehicle
    }
    
    /// State variable controlling visibility of vehicle statistics section.
    @State var showVehicleStatistics: Bool = false
    
    /// The body of the GarageScreen view defining its UI.
    var body: some View {
        NavigationStack {
            Group {
                if garage.isEmpty {
                    ContentUnavailableView("No vehicles in garage", systemImage: "house.lodge.fill" , description: Text("Add a vehicle to your garage"))
                    
                } else {
                    List {
                        if !bills.isEmpty {
                            VehicleStatisticsSection(showVehicleStatistics: $showVehicleStatistics, vehicles: garage)
                        }
                        
                        ForEach(garage) { vehicle in
                            NavigationLink(value: vehicle) {
                                VehicleRowView(vehicle: vehicle)
                            }
                        }
                        .onDelete(perform: deleteVehicle)
                    }
                }
            }
            .navigationTitle("Garage")
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button {
                        showAddVehicleSheet?()
                    } label: {
                        Image(systemName: "plus.circle")
                    }
                }
            }
            .navigationDestination(for: Vehicle.self) { vehicle in
                VehicleDetailsView(vehicle: vehicle)
            }
        }
    }
    
    /// Handles the deletion of vehicles from the IndexSet provided by SwiftUI's List.
    ///
    /// This method translates between SwiftUI's `IndexSet` deletion mechanism
    /// and the callback approach used by the parent view.
    ///
    /// - Parameter offset: The IndexSet containing indices of vehicles to delete
    private func deleteVehicle(at offset: IndexSet) {
        for index in offset {
            onDeleteVehicle(garage[index])
        }
    }
}

/// Observable class that manages state for the garage screen.
///
/// This class can be expanded to handle more complex state management
/// for the garage screen if needed in future development.
@Observable
class GarageManager {
    
}


#Preview {
    GarageScreen( onDeleteVehicle: {_ in })
}
