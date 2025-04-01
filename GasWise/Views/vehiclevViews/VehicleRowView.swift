//
//  VehicleRowView.swift
//  GasWise
//
//  Created by Dor Mizrachi on 24/03/2025.
//

import SwiftUI

struct VehicleRowView: View {
    var vehicle: Vehicle

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
