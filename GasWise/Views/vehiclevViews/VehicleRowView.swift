//
//  VehicleRowView.swift
//  GasWise
//
//  Created by Dor Mizrachi on 24/03/2025.
//

import SwiftUI

/// A row component for displaying summary information about a vehicle.
///
/// `VehicleRowView` provides a compact presentation of a vehicle designed
/// for use in lists. It displays key information including:
/// - Vehicle name and icon based on fuel type
/// - Make, model, and year
/// - Current odometer reading
/// - Fuel type with visual indicator
///
/// The view uses consistent styling and iconography to help users quickly identify
/// different vehicle types in their garage.
struct VehicleRowView: View {
    /// The vehicle to display.
    var vehicle: Vehicle

    /// The body of the VehicleRowView defining its UI.
    var body: some View {
        HStack {
            Image(systemName: fuelIcon(for: vehicle.fuelType))
                .font(.title2)
                .foregroundColor(.green)

            VStack(alignment: .leading) {
                Text(vehicle.name)
                    .font(.headline)

                Text("\(vehicle.make) \(vehicle.model) (\(vehicle.year))")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                Text("Odometer: \(String(format: "%.0f", vehicle.odometer)) km")
                    .font(.footnote)
                    .foregroundColor(.gray)
            }

            Spacer()

            Text(vehicle.fuelType.rawValue)
                .font(.footnote)
                .padding(6)
                .background(Color.green.opacity(0.2))
                .cornerRadius(8)
        }
        .padding(.vertical, 5)
    }

    /// Returns an appropriate SF Symbol icon name based on the vehicle's fuel type.
    ///
    /// This method maps each fuel type to a visually representative icon:
    /// - Gasoline: fuel pump icon
    /// - Diesel: drop icon
    /// - Electric: electric car icon
    /// - Hybrid: leaf icon (representing eco-friendliness)
    ///
    /// - Parameter fuelType: The fuel type to get an icon for
    /// - Returns: SF Symbol name for the appropriate icon
    internal func fuelIcon(for fuelType: FuelType) -> String {
        switch fuelType {
        case .gasoline:
            return "fuelpump.fill"
        case .diesel:
            return "drop.fill"
        case .electric:
            return "bolt.car.fill"
        case .hybrid:
            return "leaf.fill"
        }
    }
}

#Preview {
    VehicleRowView(vehicle: Vehicle(
        id: "123456",
        name: "Family Car",
        make: "Toyota",
        model: "Corolla",
        year: "2020",
        fuelType: .gasoline,
        tankCapacity: 50.0,
        odometer: 45200.5
    ))
}
