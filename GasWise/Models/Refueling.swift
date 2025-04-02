import Foundation
import SwiftData

/// A model representing a vehicle refueling event in the GasWise application.
///
/// The `Refueling` class tracks detailed information about each time a vehicle is refueled,
/// including:
/// - Date and location details
/// - Fuel quantity and cost information
/// - Distance traveled since last refueling
/// - Performance metrics (efficiency, cost per distance)
///
/// The model supports different fuel types including traditional fuels (gasoline/diesel)
/// and electric charging events.
@Model
class Refueling: Equatable {
    /// Unique identifier for the refueling record.
    var id: UUID = UUID()
    
    /// Date when the refueling occurred.
    var date: Date
    
    /// Reference to the vehicle that was refueled.
    var vehicle: Vehicle
    
    /// Optional reference to the gas station where refueling occurred.
    var gasStation: GasStation?
    
    /// Type of fuel used in this refueling event.
    var fuelType: FuelType
    
    /// User notes or comments about this refueling event.
    var notes: String
    
    /// Distance traveled since the previous refueling, in kilometers.
    var distanceTraveled: Double
    
    /// Amount of fuel added in liters (for gasoline/diesel vehicles).
    var fuelAmount: Double?
    
    /// Price per liter of fuel (for gasoline/diesel vehicles).
    var pricePerLiter: Double?
    
    /// Amount of energy added in kilowatt-hours (for electric vehicles).
    var energyAmount: Double?
    
    /// Price per kilowatt-hour (for electric vehicles).
    var pricePerEnergyUnit: Double?
    
    /// Initializes a new refueling record with the specified properties.
    ///
    /// - Parameters:
    ///   - date: Date when the refueling occurred
    ///   - vehicle: Vehicle that was refueled
    ///   - fuelType: Type of fuel used
    ///   - notes: User notes about this refueling
    ///   - distanceTraveled: Distance traveled since previous refueling in kilometers
    ///   - fuelAmount: Amount of fuel added in liters (optional)
    ///   - pricePerLiter: Price per liter of fuel (optional)
    ///   - energyAmount: Amount of energy added in kilowatt-hours (optional)
    ///   - pricePerEnergyUnit: Price per kilowatt-hour (optional)
    init(
        date: Date,
        vehicle: Vehicle,
        fuelType: FuelType,
        notes: String,
        distanceTraveled: Double,
        fuelAmount: Double? = nil,
        pricePerLiter: Double? = nil,
        energyAmount: Double? = nil,
        pricePerEnergyUnit: Double? = nil
    ) {
        self.date = date
        self.vehicle = vehicle
        self.fuelType = fuelType
        self.notes = notes
        self.distanceTraveled = distanceTraveled
        self.fuelAmount = fuelAmount
        self.pricePerLiter = pricePerLiter
        self.energyAmount = energyAmount
        self.pricePerEnergyUnit = pricePerEnergyUnit
    }

    // **Computed Properties**
    
    /// Calculates the total price of the refueling event.
    ///
    /// For electric vehicles, calculates based on energy cost.
    /// For hybrid vehicles, combines both fuel and energy costs.
    /// For conventional vehicles, calculates based on fuel cost.
    ///
    /// - Returns: The total cost of the refueling event in the currency used for recording.
    var totalPrice: Double {
        switch fuelType {
        case .electric:
            return electricTotalPrice
        case .hybrid:
            return electricTotalPrice + dieselOrGasolineTotalPrice
        default:
            return dieselOrGasolineTotalPrice
        }
    }
    
    /// Calculates the total cost for conventional fuel (diesel or gasoline).
    ///
    /// - Returns: The total cost of the conventional fuel in the currency used for recording.
    var dieselOrGasolineTotalPrice: Double {
        pricePerLiter! * fuelAmount!
    }
    
    /// Calculates the total cost for electric charging.
    ///
    /// - Returns: The total cost of the electricity in the currency used for recording.
    var electricTotalPrice: Double {
        energyAmount! * pricePerEnergyUnit!
    }

    /// Calculates fuel efficiency as distance traveled per unit of fuel.
    ///
    /// - Returns: Fuel efficiency in kilometers per liter for gasoline/diesel vehicles,
    ///            or `nil` if no valid fuel data exists.
    var fuelEfficiency: Double? {
        if let fuel = fuelAmount, fuel > 0 {
            return distanceTraveled / fuel
        }
        return nil
    }

    /// Calculates energy efficiency for electric vehicles.
    ///
    /// - Returns: Energy efficiency in kilowatt-hours per kilometer for electric vehicles,
    ///            or `nil` if the vehicle is not electric or no valid energy data exists.
    var energyEfficiency: Double? {
        if fuelType == .electric, let energy = energyAmount, energy > 0 {
            return energy / distanceTraveled
        }
        return nil
    }

    /// Calculates the cost per distance unit traveled.
    ///
    /// This metric is useful for comparing the economic efficiency of different
    /// vehicles or fuel types.
    ///
    /// - Returns: Cost per kilometer in the currency used for recording,
    ///            or `nil` if no valid distance data exists.
    var costPerDistance: Double? {
        if distanceTraveled > 0 {
            
            if fuelType == .electric {
                return electricTotalPrice / distanceTraveled
            } else if fuelType == .hybrid {
                return electricTotalPrice / distanceTraveled + dieselOrGasolineTotalPrice / distanceTraveled
            } else {
                return dieselOrGasolineTotalPrice / distanceTraveled
            }
        }
        return nil
    }

    /// Calculates the cost per unit of fuel or energy.
    ///
    /// For electric vehicles, returns the price per kilowatt-hour.
    /// For hybrid vehicles, combines both fuel and energy costs.
    /// For conventional vehicles, returns the price per liter.
    ///
    /// - Returns: The cost per unit of fuel or energy in the currency used for recording.
    var costPerVolume: Double {
        if fuelType == .electric {
            return pricePerEnergyUnit!
        } else if fuelType == .hybrid {
            return pricePerLiter! + pricePerEnergyUnit!
        } else {
            return pricePerLiter!
        }
    }
}
