import SwiftUI
import Charts

/// A chart visualization component for displaying refueling cost trends over time.
///
/// `RefuelingChartView` creates a line chart that visualizes refueling costs
/// across dates, helping users identify patterns in their fuel expenses. The chart supports:
/// - Time-based visualization of refueling costs
/// - Color-coded data series by vehicle
/// - Horizontal scrolling for viewing extended history
/// - Interactive elements (symbols) marking each data point
///
/// This visualization helps users track their spending patterns and identify
/// potential cost-saving opportunities.
struct RefuelingChartView: View {
    /// Array of refueling records to visualize in the chart.
    var refuelings: [Refueling]
    
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
    
    /// The body of the RefuelingChartView defining its UI.
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

