//
//  VehicleListSection.swift
//  GasWise
//
//  Created by Dor Mizrachi on 25/03/2025.
//

import SwiftUI
import Charts

struct VehicleChartView: View {
    var vehicles: [Vehicle]
    
    let calendar = Calendar.autoupdatingCurrent
    
    
    var chartHeight: Double {
        UIScreen.main.bounds.width * 0.3
    }
    
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
