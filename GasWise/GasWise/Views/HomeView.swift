//
//  RefuelingListSection.swift
//  GasWise
//
//  Created by Dor Mizrachi on 25/03/2025.
//
import SwiftUI
import SwiftData
import Charts

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Refueling.date, order: .reverse) private var refuelings: [Refueling]
    @Query private var vehicles: [Vehicle]
    
    @State private var showAddNewRefueling: Bool = false
    @State var showAddNewCar: Bool = false
    @State var showRefuelingStatistics: Bool = true
    @State var showVehicleStatistics: Bool = true
    @State private var selectedGasStation: GasStation?
    
    var body: some View {
        NavigationStack {
            VStack {
                if refuelings.isEmpty && vehicles.isEmpty {
                    
                    EmptyDataView(showAddNewCar: $showAddNewCar)
                    
                } else {
                    VStack(spacing: 20) {
                        List {
                            
                            VehicleListSection(showVehicleStatistics: $showVehicleStatistics)
                            
                            RefuelingListSection( showRefuelingStatistics: $showRefuelingStatistics)
                            
                        }
                    }
                }
            }
            
            .navigationTitle("My Garage")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    HStack(alignment: .firstTextBaseline) {
                        Button {
                            showAddNewCar = true
                        } label: {
                            Image(systemName: "car.2.fill")
                                .imageScale(.large)
                                .foregroundStyle(.green) 
                        }
                        Button {
                            showAddNewRefueling = true
                        } label: {
                            Image(systemName: "list.bullet.clipboard.fill")
                                .imageScale(.large)
                        }
                    }
                }
            }
            .sheet(isPresented: $showAddNewRefueling) {
                AddNewRefuelingView()
            }
            .sheet(isPresented: $showAddNewCar) {
                AddVehicleView()
            }
        }
    }
}
