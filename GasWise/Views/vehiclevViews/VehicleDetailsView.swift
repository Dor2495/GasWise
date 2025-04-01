//
//  VehicleDetailsView.swift
//  GasWise
//
//  Created by Dor Mizrachi on 24/03/2025.
//

import SwiftUI
import SwiftData

struct VehicleDetailsView: View {
    @Query private var refuelings: [Refueling]
    var vehicle: Vehicle

    var body: some View {
        NavigationView {
            List {
                VehicleInfoSection(vehicle: vehicle)
                
                Section(header: Label("Plate Number", systemImage: "number")) {
                    PlateNumberView(plateNumber: vehicle.plateNumber)
                }
            }
            .navigationTitle("\(vehicle.name) Details")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct VehicleInfoSection: View {
    let vehicle: Vehicle

    var body: some View {
        Section(header: Label("Vehicle Info", systemImage: "car.fill")) {
            VehicleDetailRow(label: "Name", value: vehicle.name)
            VehicleDetailRow(label: "Make", value: vehicle.make)
            VehicleDetailRow(label: "Model", value: vehicle.model)
            VehicleDetailRow(label: "Year", value: vehicle.year)
            VehicleDetailRow(label: "Fuel Type", value: vehicle.fuelType.rawValue)
            if let tankCapacity = vehicle.tankCapacity {
                VehicleDetailRow(label: "Tank Capacity", value: "\(String(format: "%.1f", tankCapacity)) L")
            }
            if let batteryCapacity = vehicle.batteryCapacity {
                VehicleDetailRow(label: "Battery Capacity", value: "\(String(format: "%.1f", batteryCapacity)) kWh")
            }
            VehicleDetailRow(label: "Odometer", value: "\(String(format: "%.1f", vehicle.odometer)) km")
        }
    }
}

struct VehicleDetailRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label + ":")
            Spacer()
            Text(value)
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    let sampleVehicle = Vehicle(
        id: "1234567",
        name: "Family Car",
        make: "Toyota",
        model: "Corolla",
        year: "2020",
        fuelType: .gasoline,
        tankCapacity: 50.0,
        batteryCapacity: nil,
        odometer: 45200.5
    )

    return VehicleDetailsView(vehicle: sampleVehicle)
}
