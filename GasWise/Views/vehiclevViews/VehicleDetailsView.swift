//
//  VehicleDetailsView.swift
//  GasWise
//
//  Created by Dor Mizrachi on 24/03/2025.
//

import SwiftUI
import SwiftData

/// A detailed view for displaying comprehensive information about a vehicle.
///
/// `VehicleDetailsView` presents a complete overview of a vehicle's information including:
/// - Basic vehicle specifications (make, model, year)
/// - Fuel/energy capacity details
/// - Current odometer reading
/// - License plate information
///
/// This view acts as a central hub for accessing all information related to a specific vehicle.
struct VehicleDetailsView: View {
    /// Query to retrieve all refueling records related to this vehicle.
    @Query private var refuelings: [Refueling]
    
    /// The vehicle to display details for.
    var vehicle: Vehicle

    /// The body of the VehicleDetailsView defining its UI.
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

/// A section that displays basic vehicle information in a grouped format.
///
/// This component encapsulates all essential vehicle specifications in a
/// consistent layout pattern, improving code organization and reusability.
struct VehicleInfoSection: View {
    /// The vehicle whose information is being displayed.
    let vehicle: Vehicle

    /// The body of the VehicleInfoSection defining its UI.
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

/// A reusable row component for displaying vehicle details.
///
/// This view provides a consistent layout for each data point in the vehicle details list,
/// with the label on the left and the corresponding value on the right.
struct VehicleDetailRow: View {
    /// The label describing the data being displayed.
    let label: String
    
    /// The value to display for this data point.
    let value: String

    /// The body of the VehicleDetailRow defining its UI.
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
