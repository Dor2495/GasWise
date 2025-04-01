//
//  RefuelingListSection.swift
//  GasWise
//
//  Created by Dor Mizrachi on 25/03/2025.
//
import SwiftUI
import SwiftData
import Charts

struct GarageScreen: View {
    @Query private var garage: [Vehicle]
    @Query private var bills: [Refueling]
    
    var onDeleteVehicle: (Vehicle) -> Void?
    var showAddVehicleSheet: (() -> Void)?
    
    init(onDeleteVehicle: @escaping (Vehicle) -> Void, showAddVehicleSheet: (() -> Void)? = nil) {
        self.showAddVehicleSheet = showAddVehicleSheet
        self.onDeleteVehicle = onDeleteVehicle
    }
    
    @State var showVehicleStatistics: Bool = false
    
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
    
    private func deleteVehicle(at offset: IndexSet) {
        for index in offset {
            onDeleteVehicle(garage[index])
        }
    }
}

@Observable
class GarageManager {
    
}


#Preview {
    GarageScreen( onDeleteVehicle: {_ in })
}
