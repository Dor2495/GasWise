import SwiftUI
import SwiftData

/// A form-based view for adding a new refueling record to the GasWise application.
///
/// `AddNewRefuelingView` provides an interface for users to input all necessary information
/// when recording a new refueling event. The view adapts dynamically based on the selected
/// vehicle's fuel type to show relevant input fields for:
/// - Conventional fuel vehicles (gasoline/diesel)
/// - Electric vehicles (battery charging)
/// - Hybrid vehicles (both fuel and electric)
///
/// The form includes fields for recording fuel/energy amounts, prices, distance traveled,
/// and station information, with appropriate validation and calculation of totals.
struct AddNewRefuelingView: View {
    /// Environment variable for dismissing the view.
    @Environment(\.dismiss) private var dismiss
    
    /// Query to retrieve all vehicles from the database.
    @Query private var vehicles: [Vehicle]
    
    /// Callback function used when saving a new refueling record.
    var saveRefueling: ((Refueling) -> Void)?
    
    /// Initializes the view with an optional save callback.
    ///
    /// - Parameter saveRefueling: Optional callback function executed when a new refueling record is saved
    init(saveRefueling: ((Refueling) -> Void)? = nil) {
        self.saveRefueling = saveRefueling
    }
    
    /// The gas station where refueling occurred (optional).
    @State var selectedGasStation: GasStation? = nil
    
    /// The vehicle being refueled.
    @State private var selectedVehicle: Vehicle? = nil
    
    /// Date and time when the refueling occurred.
    @State private var date: Date = Date()
    
    /// User notes or comments about this refueling event.
    @State private var notes: String = ""
    
    /// Distance traveled since the previous refueling, in kilometers.
    @State private var distanceTravelled: Double = 0
    
    // For diesel or gasoline vehicle
    /// Amount of fuel added in liters (for gasoline/diesel vehicles).
    @State private var fuelAmount: Double = 0
    
    /// Price per liter of fuel (for gasoline/diesel vehicles).
    @State private var pricePerLiter: Double = 0
    
    /// Name of the gas station where refueling occurred.
    @State private var stationName: String = ""
    
    // For electric or hybrid vehicle
    /// Amount of energy added in kilowatt-hours (for electric vehicles).
    @State private var energyAmount: Double = 0
    
    /// Price per kilowatt-hour (for electric vehicles).
    @State private var pricePerEnergyUnit: Double = 0
    
    /// The body of the AddNewRefuelingView defining its UI.
    var body: some View {
        NavigationStack {
            Form {
                Picker("Vehicle", selection: $selectedVehicle) {
                    ForEach(vehicles, id: \.id) { vehicle in
                        Text(vehicle.name)
                            .tag(vehicle as Vehicle)
                    }
                }
                .pickerStyle(.menu)
                
                // Check if vehicle is diesel/gasoline or electric
                if let selectedVehicle = selectedVehicle {
                    
                    DatePicker("Date and Time", selection: $date)
                    if selectedVehicle.fuelType == .gasoline || selectedVehicle.fuelType == .diesel {
                        // Diesel or Gasoline Refueling Info
                        
                        Section("Fuel Amount (Liters)") {
                            TextField("Fuel Amount (Liters)", value: $fuelAmount, format: .number)
                                .keyboardType(.decimalPad)
                        }
                        Section("Price per Liter") {
                            TextField("Price per Liter", value: $pricePerLiter, format: .number)
                                .keyboardType(.decimalPad)
                        }
                        Text("Total Amount: \(totalCost.formatted())")
                        
                    }
                    
                    else if selectedVehicle.fuelType == .hybrid {
                        //  Hybrid Refueling Info
                        Section("Fuel Amount (Liters)") {
                            TextField("Fuel Amount (Liters)", value: $fuelAmount, format: .number)
                                .keyboardType(.decimalPad)
                        }
                        Section("Price per Liter") {
                            TextField("Price per Liter", value: $pricePerLiter, format: .number)
                                .keyboardType(.decimalPad)
                        }
                        Section("Energy Amount (kWh)") {
                            TextField("Energy Amount (kWh)", value: $energyAmount, format: .number)
                                .keyboardType(.decimalPad)
                        }
                        Section("Price per kWh") {
                            TextField("Price per kWh", value: $pricePerEnergyUnit, format: .number)
                                .keyboardType(.decimalPad)
                        }
                        Text("Total Amount: \(totalCost.formatted())")
                        
                    } else if selectedVehicle.fuelType == .electric {
                        // Electric Vehicle Charging Info
                        Section("Energy Amount (kWh)") {
                            TextField("Energy Amount (kWh)", value: $energyAmount, format: .number)
                                .keyboardType(.decimalPad)
                        }
                        Section("Price per kWh") {
                            TextField("Price per kWh", value: $pricePerEnergyUnit, format: .number)
                                .keyboardType(.decimalPad)
                        }
                        Text("Total Amount: \(totalCost.formatted())")
                        
                    }
                    Section("Distance Travelled") {
                        TextField("Price per kWh", value: $distanceTravelled, format: .number)
                            .keyboardType(.decimalPad)
                    }
                    
                    Section("Station Information") {
//                        NavigationLink(destination: MapView(selectedGasStation: $selectedGasStation)) {
//                            VStack(alignment: .leading, spacing: 10) {
//                                Text("Select Gas Station")
//                                if selectedGasStation != nil {
//                                    TextField("Gas Station Name", text: $stationName, prompt: Text("Enter Gas Station Name"))
//                                }
//                            }
//                        }
                    }
                }
                
            }
            .scrollDismissesKeyboard(.interactively)
            .navigationTitle("Fueling/Charging Information")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        saveNewRefueling()
                        dismiss()
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .imageScale(.large)
                    }
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
                selectedVehicle = vehicles.first
            }
        }
    }
    
    /// Creates and saves a new Refueling record based on form input.
    ///
    /// This method:
    /// 1. Creates a new Refueling object with common fields
    /// 2. Adds fuel or energy details based on vehicle type
    /// 3. Associates gas station information if available
    /// 4. Updates the vehicle's odometer reading
    /// 5. Triggers the save callback to persist the record
    private func saveNewRefueling() {
        if let selectedVehicle = selectedVehicle {
            // Create new refueling or charging record
            let newRecord: Refueling = Refueling(
                date: date,
                vehicle: selectedVehicle,
                fuelType: selectedVehicle.fuelType,
                notes: notes,
                distanceTraveled: distanceTravelled
            )
            
            if selectedVehicle.fuelType == .gasoline || selectedVehicle.fuelType == .diesel {
                // Diesel or Gasoline
                newRecord.fuelAmount = fuelAmount
                newRecord.pricePerLiter = pricePerLiter
                
            } else if selectedVehicle.fuelType == .hybrid {
                newRecord.fuelAmount = fuelAmount
                newRecord.pricePerLiter = pricePerLiter
                newRecord.energyAmount = energyAmount
                newRecord.pricePerEnergyUnit = pricePerEnergyUnit
                
            } else {
                // Electric Vehicle
                newRecord.energyAmount = energyAmount
                newRecord.pricePerEnergyUnit = pricePerEnergyUnit
                
            }
            
            if let station = selectedGasStation {
                newRecord.gasStation = station
            }
            
            selectedVehicle.refuelings.append(newRecord)
            selectedVehicle.odometer += distanceTravelled
            
            saveRefueling?(newRecord)
        }
    }
    
    /// Calculates the total cost of the refueling based on current form values.
    ///
    /// This computed property dynamically calculates the total cost based on:
    /// - Selected vehicle's fuel type
    /// - Fuel amount and price (for gasoline/diesel vehicles)
    /// - Energy amount and price (for electric vehicles)
    /// - Both fuel and energy (for hybrid vehicles)
    ///
    /// - Returns: The total cost of the refueling in the currency used for recording.
    var totalCost: Double {
        if let selectedVehicle = selectedVehicle {
            if selectedVehicle.fuelType == .gasoline || selectedVehicle.fuelType == .diesel {
                return fuelAmount * pricePerLiter
            } else if selectedVehicle.fuelType == .electric {
                return energyAmount * pricePerEnergyUnit
            } else if selectedVehicle.fuelType == .hybrid {
                return (energyAmount * pricePerEnergyUnit) + (fuelAmount * pricePerLiter)
            }
        }
        return 0
    }
}
