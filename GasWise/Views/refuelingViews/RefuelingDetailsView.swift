import SwiftUI

struct RefuelingDetailsView: View {
    var refueling: Refueling

    var body: some View {
        NavigationView {
            List {
                Section(header: Label("Vehicle Details", systemImage: "car.fill")) {
                    HStack {
                        Image(systemName: "car")
                        Text("Vehicle:")
                        Spacer()
                        Text(refueling.vehicle.name)
                            .foregroundStyle(.blue)
                    }
                    HStack {
                        Image(systemName: "fuelpump")
                        Text("Fuel Type:")
                        Spacer()
                        Text(refueling.vehicle.fuelType.rawValue)
                            .foregroundStyle(.blue)
                    }
                }

                HStack {
                    Image(systemName: "calendar")
                    Text("Date:")
                    Spacer()
                    Text("\(refueling.date, style: .date)")
                }
                HStack {
                    Image(systemName: "clock")
                    Text("Time:")
                    Spacer()
                    Text("\(refueling.date, style: .time)")
                }
                if refueling.vehicle.fuelType != .electric {
                    Section(header: Label("Gasoline/Diesel Details", systemImage: "car.fill")) {
                        if let fuelAmount = refueling.fuelAmount {
                            RefuelingDetailRow(icon: "drop.fill", label: "Amount Filled:", value: "\(String(format: "%.2f", fuelAmount)) L")
                        }
                        if let pricePerUnit = refueling.pricePerLiter {
                            RefuelingDetailRow(icon: "dollarsign.circle", label: "Price per Unit:", value: "\(String(format: "%.2f", pricePerUnit)) NIS")
                        }
                        RefuelingDetailRow(icon: "creditcard.fill", label: "Total Price:", value: "\(String(format: "%.2f", refueling.dieselOrGasolineTotalPrice)) NIS")
                    }
                    if refueling.vehicle.fuelType == .hybrid {
                        
                        // section
                        Section(header: Label("Electric Details", systemImage: "car.fill")) {
                            if let batteryCharge = refueling.energyAmount {
                                RefuelingDetailRow(icon: "bolt.fill", label: "Battery Charge Added:", value: "\(String(format: "%.2f", batteryCharge)) kWh")
                            }
                            if let chargingCost = refueling.pricePerEnergyUnit {
                                RefuelingDetailRow(icon: "dollarsign.circle", label: "Charging Cost:", value: "\(String(format: "%.2f", chargingCost)) NIS")
                            }
                            RefuelingDetailRow(icon: "creditcard.fill", label: "Total Price:", value: "\(String(format: "%.2f", refueling.electricTotalPrice)) NIS")
                        }
                    }
                } else {
                    Section(header: Label("Electric Details", systemImage: "car.fill")) {
                        if let batteryCharge = refueling.pricePerEnergyUnit {
                            RefuelingDetailRow(icon: "bolt.fill", label: "Battery Charge Added:", value: "\(String(format: "%.2f", batteryCharge)) kWh")
                        }
                        RefuelingDetailRow(icon: "dollarsign.circle", label: "Charging Cost:", value: "\(String(format: "%.2f", refueling.electricTotalPrice)) NIS")
                    }
                }
                
                if refueling.fuelType == .hybrid {
                    Section(header: Label("Total Chraging Details", systemImage: "dollarsign.circle")) {
                        RefuelingDetailRow(icon: "dollarsign.circle", label: "Total Charging Cost:", value: "\(String(format: "%.2f", refueling.totalPrice)) NIS")
                    }
                }

                if let gasStation = refueling.gasStation {
                    Section(header: Label("Gas Station", systemImage: "building.2.fill")) {
                        HStack {
                            Image(systemName: "fuelpump")
                            Text("Name:")
                            Spacer()
                            NavigationLink(destination: GasStationMapView(gasStation: gasStation)) {
                                Text("\(gasStation.name)")
                            }
                        }
                    }
                }

                Section(header: Label("Statistics", systemImage: "chart.bar.fill")) {
                    HStack {
                        Image(systemName: "road.lanes")
                        Text("Distance Traveled:")
                        Spacer()
                        Text("\(String(format: "%.1f", refueling.distanceTraveled)) km")
                    }
                    HStack {
                        Image(systemName: "gauge.high")
                        Text("Fuel Efficiency:")
                        Spacer()
                        if let efficiency = refueling.fuelEfficiency {
                            Text("\(String(format: "%.2f", efficiency)) km/L")
                        } else {
                            Text("N/A")
                        }
                    }
                    HStack {
                        Image(systemName: "dollarsign.arrow.circlepath")
                        Text("Cost per Distance:")
                        Spacer()
                        if let cost = refueling.costPerDistance {
                            Text("\(String(format: "%.2f", cost)) NIS/km")
                        } else {
                            Text("N/A")
                        }
                    }
                }

                if !refueling.notes.isEmpty {
                    Section(header: Label("Notes", systemImage: "pencil")) {
                        Text(refueling.notes)
                            .padding(.vertical, 5)
                            .foregroundStyle(.gray)
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("\(refueling.gasStation?.name ?? "Default") Details")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}


struct RefuelingDetailRow: View {
    let icon: String
    let label: String
    let value: String

    var body: some View {
        HStack {
            Image(systemName: icon)
            Text(label)
            Spacer()
            Text(value)
        }
    }
}
