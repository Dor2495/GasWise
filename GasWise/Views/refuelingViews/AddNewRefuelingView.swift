import SwiftUI
import SwiftData

struct AddNewRefuelingView: View {
    @Environment(\.dismiss) private var dismiss
    
    @Query private var vehicles: [Vehicle]
    
    var saveRefueling: ((Refueling) -> Void)?
    
    init(saveRefueling: ((Refueling) -> Void)? = nil) {
        self.saveRefueling = saveRefueling
    }
    
    @State var selectedGasStation: GasStation? = nil
    @State private var selectedVehicle: Vehicle? = nil
    @State private var date: Date = Date()
    @State private var notes: String = ""
    @State private var distanceTravelled: Double = 0
    
    // For diesel or gasoline vehicle
    @State private var fuelAmount: Double = 0
    @State private var pricePerLiter: Double = 0
    @State private var stationName: String = ""
    
    // For electric or hybrid vehicle
    @State private var energyAmount: Double = 0
    @State private var pricePerEnergyUnit: Double = 0
    
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
