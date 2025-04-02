//
//  VehicleListSection.swift
//  GasWise
//
//  Created by Dor Mizrachi on 25/03/2025.
//

import SwiftUI
import Charts

/// A chart visualization component for displaying vehicle fuel efficiency data.
///
/// `VehicleChartView` creates a line chart that visualizes fuel efficiency trends
/// over time for one or multiple vehicles. The chart supports:
/// - Multiple vehicle data series with different colors
/// - Temporal x-axis showing progression of efficiency over time
/// - Scrolling capability for viewing extended time periods
/// - Automatic legend for identifying different vehicles
///
/// This visualization helps users identify efficiency patterns and compare
/// performance between different vehicles in their garage.
struct VehicleChartView: View {
    /// Array of vehicles whose fuel efficiency data will be displayed.
    var vehicles: [Vehicle]
    
    /// Calendar used for date calculations and formatting.
    let calendar = Calendar.autoupdatingCurrent
    
    /// Calculates the appropriate chart height based on screen dimensions.
    ///
    /// This computed property ensures the chart has a consistent
    /// aspect ratio across different device sizes.
    ///
    /// - Returns: Appropriate chart height in points.
    var chartHeight: Double {
        UIScreen.main.bounds.width * 0.3
    }
    
    /// The body of the VehicleChartView defining its UI.
    var body: some View {
        ScrollView([.horizontal, .vertical]) {
            Chart {
                ForEach(vehicles) { vehicle in
                    let refuelings = vehicle.refuelings
                    let sortedRefuelings = refuelings.sorted { $0.date < $1.date }
                    
                    ForEach(sortedRefuelings, id: \.id) { refueling in
                        LineMark(
                            x: .value("Date", calendar.startOfDay(for: refueling.date)),
                            
                            y: .value("Fuel Efficiency (km/L)", refueling.fuelEfficiency ?? -1)
                        )
                        .symbol(Circle().strokeBorder(lineWidth: 2))
                        .foregroundStyle(by: .value("Vehicle", vehicle.name))
                    }
                }
            }
            .chartLegend(.visible)
            
            .chartXAxis {
                AxisMarks {
                    AxisValueLabel()
                    AxisGridLine()
                }
            }
            .chartYAxis {
                AxisMarks {
                    AxisValueLabel()
                    AxisGridLine()
                }
            }
            .frame(width: UIScreen.main.bounds.width * 1.2, height: chartHeight)
        }
        .defaultScrollAnchor(.trailing)
        .scrollIndicators(.hidden)
    }
}

#Preview {
    VehicleChartView(vehicles: [])
}
