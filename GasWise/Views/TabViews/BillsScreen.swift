//
//  BiilsScreen.swift
//  GasWise
//
//  Created by Dor Mizrachi on 01/04/2025.
//

import SwiftUI
import SwiftData

struct BillsScreen: View {
    @Query private var bills: [Refueling]
    @Query private var garage: [Vehicle]
    
    var deleteRefueling: ((Refueling) -> Void)?
    
    var showAddRefuelingSheet: (() -> Void)?
    
    var showPopView: (() -> Bool)?
    
    var pop: ((Bool) -> Void)?
    
    init(deleteRefueling: ((Refueling) -> Void)? = nil,
         showAddRefuelingSheet: (() -> Void)? = nil, showPopView: (() -> Bool)? = nil, pop: ((Bool) -> Void)? = nil) {
        self.deleteRefueling = deleteRefueling
        self.showAddRefuelingSheet = showAddRefuelingSheet
        self.showPopView = showPopView
        self.pop = pop
    }
    
    @State private var showRefuelingStatistics: Bool = false
    
    var body: some View {
        NavigationStack {
            Group {
                if showPopView!() {
                    PopToAddVehicle { show in
                        pop!(show)
                    }
                } else {
                    if bills.isEmpty {
                        ContentUnavailableView("No bills yet", systemImage: "pencil.and.list.clipboard", description: Text("Add bills by tapping the plus button"))
                    } else {
                        List {
                            RefuelingStatisticsSection(showRefuelingStatistics: $showRefuelingStatistics, refuelings: bills)
                            
                            ForEach(bills) { bill in
                                NavigationLink(value: bill) {
                                    RefuelingRowView(refueling: bill)
                                }
                            }
                            .onDelete(perform: deleteRefueling)
                        }
                    }
                }
            }
            .navigationTitle("Bills")
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button {
                        showAddRefuelingSheet?()
                    } label: {
                        Image(systemName: "plus.circle")
                    }
                    .disabled(garage.isEmpty)
                }
            }
            .navigationDestination(for: Refueling.self) { bill in
                RefuelingDetailsView(refueling: bill)
            }
        }
    }
    
    private func deleteRefueling(at offsets: IndexSet) {
        for index in offsets {
            deleteRefueling?(bills[index])
        }
    }
}

#Preview {
    BillsScreen(deleteRefueling: {_ in})
}
