//
//  StatisticsSection.swift
//  GasWise
//
//  Created by Dor Mizrachi on 23/03/2025.
//

import SwiftUI

/// A collapsible section that displays refueling cost statistics with a chart visualization.
///
/// `RefuelingStatisticsSection` provides a toggleable chart view that helps users
/// visualize and analyze their refueling costs over time. Features include:
/// - Expandable/collapsible section with animation
/// - Visual chart representation of refueling costs
/// - Interactive header with icon indicating the current state
///
/// This component improves the user experience by allowing them to show or hide
/// detailed statistics based on their current needs.
struct RefuelingStatisticsSection: View {
    
    /// Binding to control the visibility of the statistics chart.
    ///
    /// This binding allows parent views to control the expanded/collapsed
    /// state of the statistics section.
    @Binding var showRefuelingStatistics: Bool
    
    /// Array of refueling records to analyze and visualize.
    var refuelings: [Refueling]
    
    /// The body of the RefuelingStatisticsSection defining its UI.
    var body: some View {
        Section {
            if showRefuelingStatistics {
                RefuelingChartView(refuelings: refuelings)
            }
        } header: {
            HStack {
                Label("Refueling Costs Statistics", systemImage: "chart.bar.fill")
                Spacer()
                Image(systemName: showRefuelingStatistics ? "minus.circle" : "plus.circle")
                    .imageScale(.large)
                    .onTapGesture {
                        withAnimation(.default) {
                            showRefuelingStatistics.toggle()
                        }
                    }
                    .rotationEffect(showRefuelingStatistics ? .degrees(180) : .degrees(0))
            }
        }
    }
}

//#Preview {
//    @Previewable @State var showStatistics: Bool = false
//    let refuelings: [Refueling] = []
//    StatisticsSection(showStatistics: $showStatistics, refuelings: refuelings)
//}
