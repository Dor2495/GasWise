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
    
    @Query var allRefuelings:[Refueling]
    
    @Binding var showRefuelingStatistics: Bool
    
    var body: some View {
        
        if allRefuelings.count > 0 {
            RefuelingStatisticsSection(showRefuelingStatistics: $showRefuelingStatistics, refuelings: allRefuelings)
        }
        
        Section(header:
                    Label("My Refuelings", systemImage: "list.bullet")
        ) {
            ForEach(allRefuelings) { refueling in
                NavigationLink(destination: RefuelingDetailsView(refueling: refueling)) {
                    RefuelingRowView(refueling: refueling)
                }
            }
//            .onDelete(perform: viewModel.deleteRefueling)
            
        }.onAppear {
            print("RefuelingListSection.appear")
        }
    }
    
//    func deleteRefueling(offsets: IndexSet) {
//        withAnimation {
//            offsets.map { refuelingViewModel.allRefuelings[$0] }.forEach(refuelingViewModel.modelContext!.delete)
//            do {
//                try refuelingViewModel.modelContext.save()
//            } catch {
//                print("Error saving context: \(error)")
//            }
//        }
//    }
    
}
//
//#Preview {
//    RefuelingListSection()
//}
