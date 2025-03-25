//
//  RefuelingListSection.swift
//  GasWise
//
//  Created by Dor Mizrachi on 25/03/2025.
//

import SwiftUI
import SwiftData


struct RefuelingListSection: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Refueling.date, order: .reverse) private var refuelings: [Refueling]
    
    @Binding var showRefuelingStatistics: Bool
    
    var body: some View {
        
        if refuelings.count > 1 {
            RefuelingStatisticsSection(showRefuelingStatistics: $showRefuelingStatistics, refuelings: refuelings)
        }
        
        Section(header:
                    Label("My Refuelings", systemImage: "list.bullet")
        ) {
            ForEach(refuelings) { refueling in
                NavigationLink(destination: RefuelingDetailsView(refueling: refueling)) {
                    RefuelingRowView(refueling: refueling)
                }
            }
            .onDelete(perform: deleteRefueling)
        }
    }
    
    private func deleteRefueling(offsets: IndexSet) {
        withAnimation {
            offsets.map { refuelings[$0] }.forEach(modelContext.delete)
            do {
                try modelContext.save()
            } catch {
                print("Error saving context: \(error)")
            }
        }
    }
    
}
//
//#Preview {
//    RefuelingListSection()
//}
