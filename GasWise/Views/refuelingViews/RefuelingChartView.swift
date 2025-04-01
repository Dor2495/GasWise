import SwiftUI
import Charts

struct RefuelingChartView: View {
    var refuelings: [Refueling]
    
    
    let calendar = Calendar.autoupdatingCurrent
    
    var chartHeight: Double {
        UIScreen.main.bounds.width * 0.3
    }
    
    var body: some View {
        ScrollView([.horizontal, .vertical]) {
            Chart {
                ForEach(refuelings, id: \.id) { refueling in
                    LineMark(
                        x: .value("Date", calendar.startOfDay(for: refueling.date)),
                        y: .value("Fuel Efficiency", refueling.totalPrice)
                    )
                    .symbol(Circle().strokeBorder(lineWidth: 2)) // Symbol for efficiency
                    .foregroundStyle(by: .value("Vehicle", refueling.vehicle.name))
                }
            }
            .chartLegend(.visible)
            .chartXAxis {
                AxisMarks(position: .bottom)
            }
            .chartYAxis {
                AxisMarks(position: AxisMarkPosition.trailing)
            }
            .frame(width: max(CGFloat(refuelings.count) * 50, UIScreen.main.bounds.width * 1.2), height: chartHeight) // Ensures the chart is wider than the screen
            .foregroundStyle(Color.green)
        }
        .defaultScrollAnchor(.trailing)
        .scrollIndicators(.hidden) // Hide scroll indicators
    }
}

