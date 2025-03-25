//
//  RefuelingRowView.swift
//  GasWise
//
//  Created by Dor Mizrachi on 22/03/2025.
//

import SwiftUI

struct RefuelingRowView: View {
    @Bindable var refueling: Refueling
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(refueling.vehicle.name)
                    .font(.headline)
                Text(dateFormatter.string(from: refueling.date))
                    .font(.subheadline)
                
                if let fuelAmount = refueling.fuelAmount {
                    Text("\(String(format: "%.2f", fuelAmount)) L")
                        .font(.subheadline)
                }
                if let energyAmount = refueling.energyAmount {
                    Text("\(String(format: "%.2f", energyAmount)) kWh")
                        .font(.subheadline)
                }
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text("\(refueling.fuelType.rawValue)")
                    .font(.headline)
                
                Text("\(String(format: "%.2f", refueling.totalPrice))")
                    .font(.headline)
            }
        }
    }
}

//#Preview {
//    // Create a sample Refueling object for the preview
//    let sampleGasStation = GasStation(name: "Test Station", latitude: 34.0522, longitude: -118.2437)
//    let sampleVehicle = Vehicle(make: "Toyota", model: "Corolla", year: 2020)
//    let sampleRefueling = Refueling(
//        date: Date(),
//        pricePerUnit: 5,
//        notes: "",
//        amountFilled: 41,
//        distanceTraveled: 300,
//        gasStation: sampleGasStation,
//        vehicle: sampleVehicle
//    )
//
//    RefuelingRowView(refueling: sampleRefueling)
//        .modelContainer(for: [Refueling.self, GasStation.self], inMemory: true) // Provide a temporary in-memory container for the preview
//}
