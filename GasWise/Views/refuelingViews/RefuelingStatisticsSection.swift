//
//  StatisticsSection.swift
//  GasWise
//
//  Created by Dor Mizrachi on 23/03/2025.
//

import SwiftUI

struct RefuelingStatisticsSection: View {
    
    @Binding var showRefuelingStatistics: Bool
    var refuelings: [Refueling]
    
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
