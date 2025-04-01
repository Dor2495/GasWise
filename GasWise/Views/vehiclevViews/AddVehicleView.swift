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
    
    var saveVehicle: ((Vehicle) -> Void)?
    
    init(saveVehicle: ((Vehicle) -> Void)? = nil) {
        self.saveVehicle = saveVehicle
    }
    
    @State private var plateNumber: String = ""
    @State private var name: String = ""
    @State private var make: String = ""
    @State private var model: String = ""
    @State private var year: String = ""
    @State private var fuelType: FuelType = .gasoline
    @State private var tankCapacity: String = ""
    @State private var batteryCapacity: String = ""
    @State private var odometer: String = ""

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
                        createVehicle()
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
        }
    }
    
    private var isFormValid: Bool {
        guard let _ = Double(tankCapacity), let _ = Double(odometer) else {
            return false
        }
        return !name.isEmpty && !make.isEmpty && !model.isEmpty
    }

    func createVehicle() {
        
        guard let odometerDouble = Double(odometer),
              let _ = Double(tankCapacity) else {
            return
        }

        let newVehicle = Vehicle(
            id: plateNumber,
            name: name,
            make: make,
            model: model,
            year: year,
            fuelType: fuelType,
            odometer: odometerDouble
        )
        
        saveVehicle?(newVehicle)
        
    }
}

#Preview {
    AddVehicleView()
        .modelContainer(for: Vehicle.self, inMemory: true) // Preview with in-memory model container
}
