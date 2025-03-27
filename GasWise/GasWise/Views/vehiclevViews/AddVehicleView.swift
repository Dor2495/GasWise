//
//  AddVehicleView.swift
//  GasWise
//
//  Created by Dor Mizrachi on 24/03/2025.
//

import SwiftUI
import SwiftData

struct AddVehicleView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext // SwiftData context
    
    var viewModel = ViewModel()

    @Query var refuelings: [Refueling]
    
    @State private var plateNumber: String = "55555555"
    @State private var name: String = "dor"
    @State private var make: String = "make"
    @State private var model: String = "model"
    @State private var year: String = "2020"
    @State private var fuelType: FuelType = .gasoline
    @State private var tankCapacity: String = "90"
    @State private var batteryCapacity: String = "90"
    @State private var odometer: String = "0"

    var body: some View {
        NavigationView {
            
            Form {
                Section(header: Label("Vehicle Details", systemImage: "car.fill")) {
                    TextField("Plate Number", text: $plateNumber)
                        .keyboardType(.numberPad)
                    TextField("Name (e.g., My Car)", text: $name)
                    TextField("Make (e.g., Toyota)", text: $make)
                    TextField("Model (e.g., Corolla)", text: $model)
                    TextField("Year (e.g., 2020)", text: $year)
                        .keyboardType(.numberPad)
                }
                
                Section(header: Label("Fuel & Capacity", systemImage: "fuelpump.fill")) {
                    Picker("Fuel Type", selection: $fuelType) {
                        ForEach(FuelType.allCases, id: \.self) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                    if fuelType == .gasoline || fuelType == .diesel {
                        TextField("Tank Capacity (Liters)", text: $tankCapacity)
                            .keyboardType(.decimalPad)
                    }
                    
                    if fuelType == .hybrid  {
                        TextField("Tank Capacity (Liters)", text: $tankCapacity)
                            .keyboardType(.decimalPad)
                        
                        TextField("Battery Capacity (kWh)", text: $batteryCapacity)
                            .keyboardType(.decimalPad)
                    }
                    if fuelType == .electric {
                        TextField("Battery Capacity (kWh)", text: $tankCapacity)
                            .keyboardType(.decimalPad)
                    }
                    
                    TextField("Odometer (KM)", text: $odometer)
                        .keyboardType(.decimalPad)
                }
            }
            .scrollDismissesKeyboard(.interactively)
            .navigationTitle("Add New Vehicle")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        viewModel.saveVehicle(plateNumber: plateNumber, name: name, make: make, model: model, year: year, fuelType: fuelType, tankCapacity: tankCapacity, batteryCapacity: batteryCapacity, odometer: odometer)
                        // dismiss
                        dismiss()
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .imageScale(.large)
                            .foregroundStyle(.green)
                    }
                    .disabled(!isFormValid)
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Cancel")
                    }
                }
            }
            .onAppear {
                viewModel.modelContext = modelContext
                viewModel.fetchVehicles()
            }
        }
    }
    
    private var isFormValid: Bool {
        guard let _ = Double(tankCapacity), let _ = Double(odometer) else {
            return false
        }
        return !name.isEmpty && !make.isEmpty && !model.isEmpty && !plateNumber.isEmpty
    }

//    enum VehicleSaveError: Error {
//        case invalidInput
//    }
//
//    func createVehicle(
//        id: String,
//        name: String,
//        make: String,
//        model: String,
//        year: String,
//        fuelType: FuelType,
//        odometer: String,
//        tankCapacity: String,
//        batteryCapacity: String?
//    ) -> Result<Vehicle, VehicleSaveError> {
//        
//        guard let odometerDouble = Double(odometer),
//              let _ = Double(tankCapacity) else {
//            return .failure(.invalidInput)
//        }
//
//        let newVehicle = Vehicle(
//            id: id,
//            name: name,
//            make: make,
//            model: model,
//            year: year,
//            fuelType: fuelType,
//            odometer: odometerDouble
//        )
//        
//        return .success(newVehicle)
//    }
//
//    func saveVehicle() {
//        let result = createVehicle(
//            id: plateNumber,
//            name: name,
//            make: make,
//            model: model,
//            year: year,
//            fuelType: fuelType,
//            odometer: odometer,
//            tankCapacity: tankCapacity,
//            batteryCapacity: batteryCapacity
//        )
//        
//        switch result {
//        case .success(let vehicle):
//            modelContext.insert(vehicle)
//            dismiss()
//        case .failure:
//            print("Failed to create vehicle")
//        }
//    }
}

#Preview {
    AddVehicleView()
        .modelContainer(for: Vehicle.self, inMemory: true) // Preview with in-memory model container
}
