//
//  VehicleListSection.swift
//  GasWise
//
//  Created by Dor Mizrachi on 25/03/2025.
//

import SwiftUI
import SwiftData

struct VehicleListSection: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var vehicles: [Vehicle]
    @Query private var refuelings: [Refueling]
    
    @Binding var showVehicleStatistics: Bool
    
    var body: some View {
        
        if !refuelings.isEmpty {
            VehicleStatisticsSection(showVehicleStatistics: $showVehicleStatistics, vehicles: vehicles)
        }
        
        Section(header:
                    Label("My Cars", systemImage: "list.bullet")
        ) {
            ForEach(vehicles) { vehicle in
                NavigationLink(destination: VehicleDetailsView(vehicle: vehicle)) {
                    VehicleRowView(vehicle: vehicle)
                }
            }
            .onDelete(perform: deleteVehicle)
        }
    }
    
    private func deleteVehicle(offsets: IndexSet) {
        withAnimation {
            offsets.map { vehicles[$0] }.forEach(modelContext.delete)
            do {
                try modelContext.save()
            } catch {
                print("Error saving context: \(error)")
            }
        }
    }
}

//#Preview {
//    VehicleListSection()
//}
