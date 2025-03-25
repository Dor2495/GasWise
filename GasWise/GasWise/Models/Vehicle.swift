//
//  Viecel.swift
//  GasWise
//
//  Created by Dor Mizrachi on 24/03/2025.
//

import Foundation
import SwiftData

@Model
class Vehicle: Equatable {
    var id: String
    var name: String
    var make: String
    var model: String
    var year: String
    
    var fuelType: FuelType
    
    var odometer: Double // in kilometers
    @Relationship(deleteRule: .cascade) 
    var refuelings: [Refueling] = []
    
    var tankCapacity: Double? // in liters
    var batteryCapacity: Double?
    
    // diesel or gasoline
    init(
        id: String,
        name: String,
        make: String,
        model: String,
        year: String,
        fuelType: FuelType,
        tankCapacity: Double? = nil,
        batteryCapacity: Double? = nil,
        odometer: Double
    ) {
        self.id = id
        self.name = name
        self.make = make
        self.model = model
        self.year = year
        self.fuelType = fuelType
        self.tankCapacity = tankCapacity
        self.batteryCapacity = batteryCapacity
        self.odometer = odometer
    }
    
    // Computed property: Average fuel efficiency based on refuelings
    var averageFuelEfficiency: Double? {
        let validRefuelings = refuelings.filter { $0.fuelEfficiency != nil }
        guard !validRefuelings.isEmpty else { return nil }
        
        let totalEfficiency = validRefuelings.compactMap { $0.fuelEfficiency }.reduce(0, +)
        return totalEfficiency / Double(validRefuelings.count)
    }
    
    var plateNumber: String {
        let numbers = id.filter { $0.isNumber } // Extract only numbers from ID
        if numbers.count == 7 {
            return "\(numbers.prefix(2))-\(numbers.dropFirst(2).prefix(3))-\(numbers.suffix(2))"
        } else if numbers.count == 8 {
            return "\(numbers.prefix(3))-\(numbers.dropFirst(3).prefix(2))-\(numbers.suffix(3))"
        } else {
            return "Invalid Plate"
        }
    }
        
    // Computed property: Total fuel cost
    var totalFuelCost: Double {
        return refuelings.reduce(0) { $0 + $1.totalPrice }
    }
    
    // Computed property: Total distance traveled
    var totalDistance: Double {
        return refuelings.compactMap { $0.distanceTraveled }.reduce(0, +)
    }
}

// Enum for Fuel Type
enum FuelType: String, Codable, CaseIterable {
    case gasoline = "Gasoline"
    case diesel = "Diesel"
    case electric = "Electric"
    case hybrid = "Hybrid"
}
