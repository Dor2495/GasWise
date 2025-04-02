//
//  AddVehicleView.swift
//  GasWise
//
//  Created by Dor Mizrachi on 24/03/2025.
//

import SwiftUI
import SwiftData

/// A view for adding a new vehicle to the GasWise application.
///
/// `AddVehicleView` provides a form-based interface allowing users to input
/// all necessary information to create a new vehicle record, including:
/// - Basic vehicle identification (plate number, name)
/// - Vehicle specifications (make, model, year)
/// - Fuel type and capacity details
/// - Current odometer reading
///
/// The view adapts dynamically based on the selected fuel type, showing
/// relevant input fields for conventional, electric, or hybrid vehicles.
struct AddVehicleView: View {
    /// Environment variable for dismissing the view.
    @Environment(\.dismiss) var dismiss
    
    /// Callback function used when saving a new vehicle.
    var saveVehicle: ((Vehicle) -> Void)?
    
    /// Initializes the add vehicle view with an optional save callback.
    ///
    /// - Parameter saveVehicle: Optional callback function executed when a new vehicle is saved
    init(saveVehicle: ((Vehicle) -> Void)? = nil) {
        self.saveVehicle = saveVehicle
    }
    
    /// Vehicle license plate number.
    @State private var plateNumber: String = ""
    
    /// User-defined name for the vehicle.
    @State private var name: String = ""
    
    /// Manufacturer of the vehicle.
    @State private var make: String = ""
    
    /// Specific model of the vehicle.
    @State private var model: String = ""
    
    /// Manufacturing year of the vehicle.
    @State private var year: String = ""
    
    /// Type of fuel used by the vehicle.
    @State private var fuelType: FuelType = .gasoline
    
    /// Fuel tank capacity in liters (for gasoline/diesel/hybrid vehicles).
    @State private var tankCapacity: String = ""
    
    /// Battery capacity in kilowatt-hours (for electric/hybrid vehicles).
    @State private var batteryCapacity: String = ""
    
    /// Current odometer reading in kilometers.
    @State private var odometer: String = ""

    /// The body of the AddVehicleView defining its UI.
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
    
    /// Validates if the form data is complete and correctly formatted.
    ///
    /// This computed property checks required fields to ensure:
    /// - Numeric values can be converted to Double
    /// - Text fields are not empty
    ///
    /// - Returns: A Boolean indicating if the form is valid and can be submitted.
    private var isFormValid: Bool {
        guard let _ = Double(tankCapacity), let _ = Double(odometer) else {
            return false
        }
        return !name.isEmpty && !make.isEmpty && !model.isEmpty
    }

    /// Creates a new Vehicle object from the form data and calls the save callback.
    ///
    /// This method validates critical numeric fields, creates a Vehicle instance
    /// with the appropriate properties based on form input, and then triggers
    /// the save callback to persist the new vehicle.
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
