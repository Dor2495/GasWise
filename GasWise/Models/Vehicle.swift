//
//  Viecel.swift
//  GasWise
//
//  Created by Dor Mizrachi on 24/03/2025.
//

import Foundation
import SwiftData

/// A model representing a vehicle tracked in the GasWise application.
///
/// The `Vehicle` class stores comprehensive information about a user's vehicle including:
/// - Basic vehicle details (make, model, year)
/// - Fuel-related properties (fuel type, tank capacity)
/// - Performance metrics (odometer reading)
/// - Associated refueling records
///
/// This model uses SwiftData for persistence and maintains relationships
/// with refueling records for tracking fuel consumption patterns.
@Model
class Vehicle: Equatable {
    /// Unique identifier for the vehicle, typically based on license plate.
    var id: String
    
    /// User-defined name for the vehicle.
    var name: String
    
    /// Manufacturer of the vehicle.
    var make: String
    
    /// Specific model of the vehicle.
    var model: String
    
    /// Manufacturing year of the vehicle.
    var year: String
    
    /// Type of fuel used by the vehicle (gasoline, diesel, electric, hybrid).
    var fuelType: FuelType
    
    /// Current odometer reading in kilometers.
    var odometer: Double // in kilometers
    
    /// Collection of refueling records associated with this vehicle.
    /// The relationship is configured with cascade deletion to ensure
    /// when a vehicle is deleted, all its refueling records are deleted as well.
    @Relationship(deleteRule: .cascade) 
    var refuelings: [Refueling] = []
    
    /// Fuel tank capacity in liters, optional for electric vehicles.
    var tankCapacity: Double? // in liters
    
    /// Battery capacity in kilowatt-hours, applicable for electric and hybrid vehicles.
    var batteryCapacity: Double?
    
    /// Initializes a new vehicle with the specified properties.
    ///
    /// - Parameters:
    ///   - id: Unique identifier for the vehicle
    ///   - name: User-defined name for the vehicle
    ///   - make: Manufacturer of the vehicle
    ///   - model: Specific model of the vehicle
    ///   - year: Manufacturing year of the vehicle
    ///   - fuelType: Type of fuel used by the vehicle
    ///   - tankCapacity: Fuel tank capacity in liters (optional)
    ///   - batteryCapacity: Battery capacity in kilowatt-hours (optional)
    ///   - odometer: Current odometer reading in kilometers
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
    
    /// Calculates the average fuel efficiency across all refueling records.
    ///
    /// This computed property analyzes all refueling records with valid
    /// fuel efficiency data and returns the average consumption.
    ///
    /// - Returns: Average fuel efficiency in liters per 100 kilometers,
    ///            or `nil` if no valid refueling records exist.
    var averageFuelEfficiency: Double? {
        let validRefuelings = refuelings.filter { $0.fuelEfficiency != nil }
        guard !validRefuelings.isEmpty else { return nil }
        
        let totalEfficiency = validRefuelings.compactMap { $0.fuelEfficiency }.reduce(0, +)
        return totalEfficiency / Double(validRefuelings.count)
    }
    
    /// Formats the vehicle's ID into a standardized license plate format.
    ///
    /// This computed property extracts numeric characters from the ID
    /// and formats them according to common license plate patterns.
    ///
    /// - Returns: A formatted license plate string or "Invalid Plate" if the
    ///            ID doesn't match expected formats.
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
        
    /// Calculates the total cost of all refueling events for this vehicle.
    ///
    /// - Returns: Sum of all refueling costs in the currency used for recording.
    var totalFuelCost: Double {
        return refuelings.reduce(0) { $0 + $1.totalPrice }
    }
    
    /// Calculates the total distance traveled based on refueling records.
    ///
    /// - Returns: Total distance in kilometers.
    var totalDistance: Double {
        return refuelings.compactMap { $0.distanceTraveled }.reduce(0, +)
    }
}

/// Represents the types of fuel or energy sources a vehicle can use.
///
/// This enumeration provides standard fuel types used in the automotive industry
/// and supports the app's functionality for tracking different vehicle energy sources.
enum FuelType: String, Codable, CaseIterable {
    /// Standard gasoline/petrol fuel
    case gasoline = "Gasoline"
    
    /// Diesel fuel typically used in diesel engines
    case diesel = "Diesel"
    
    /// Electric power (battery only)
    case electric = "Electric"
    
    /// Combination of conventional fuel and electric power
    case hybrid = "Hybrid"
}
