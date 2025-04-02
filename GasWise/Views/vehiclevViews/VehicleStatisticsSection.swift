//
//  VehicleStatisticsSection.swift
//  GasWise
//
//  Created by Dor Mizrachi on 25/03/2025.
//

import SwiftUI

/// A collapsible section that displays vehicle efficiency statistics with a chart visualization.
///
/// `VehicleStatisticsSection` provides a toggleable chart view that helps users
/// visualize and compare efficiency metrics across different vehicles. Features include:
/// - Expandable/collapsible section with animation
/// - Visual chart representation of vehicle efficiency data
/// - Interactive header with icon indicating the current state
///
/// This component improves the user experience by allowing selective display of
/// detailed statistics based on the user's current needs.
struct VehicleStatisticsSection: View {
    
    /// Binding to control the visibility of the statistics chart.
    ///
    /// This binding allows parent views to control the expanded/collapsed
    /// state of the statistics section.
    @Binding var showVehicleStatistics: Bool
    
    /// Array of vehicles whose efficiency data will be visualized.
    var vehicles: [Vehicle]
    
    
    /// The body of the VehicleStatisticsSection defining its UI.
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
