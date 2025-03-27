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
    
    @State private var viewModel = ViewModel()
    
    @Binding var showRefuelingStatistics: Bool
    
    var body: some View {
        
        if viewModel.allRefuelings.count > 1 {
            RefuelingStatisticsSection(showRefuelingStatistics: $showRefuelingStatistics, refuelings: viewModel.allRefuelings)
        }
        
        Section(header:
                    Label("My Refuelings", systemImage: "list.bullet")
        ) {
            ForEach(viewModel.allRefuelings) { refueling in
                NavigationLink(destination: RefuelingDetailsView(refueling: refueling)) {
                    RefuelingRowView(refueling: refueling)
                }
            }
            .onDelete(perform: viewModel.deleteRefueling)
        }
        .onAppear {
            viewModel.modelContext = modelContext
            viewModel.fetchRefuelings()
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
