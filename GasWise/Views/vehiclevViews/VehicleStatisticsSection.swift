//
//  VehicleStatisticsSection.swift
//  GasWise
//
//  Created by Dor Mizrachi on 25/03/2025.
//

import SwiftUI

struct VehicleStatisticsSection: View {
    
    @Binding var showVehicleStatistics: Bool
    var vehicles: [Vehicle]
    
    
    var body: some View {
        Section {
            if showVehicleStatistics {
                VehicleChartView(vehicles: vehicles)
            }
        } header: {
            HStack {
                Label("Vehicles Efficiency Statistics", systemImage: "chart.bar.fill")
                Spacer()
                Image(systemName: showVehicleStatistics ? "minus.circle" : "plus.circle")
                    .imageScale(.large)
                    .onTapGesture {
                        withAnimation(.default) {
                            showVehicleStatistics.toggle()
                        }
                    }
                    .rotationEffect(showVehicleStatistics ? .degrees(180) : .degrees(0))
            }
        }
    }
}

#Preview {
    VehicleStatisticsSection(showVehicleStatistics: .constant(true), vehicles: [])
}
