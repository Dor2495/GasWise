import Foundation
import SwiftData

@Model
class Refueling: Equatable {
    var id: UUID = UUID()
    var date: Date
    
    var vehicle: Vehicle
    var gasStation: GasStation?
    var fuelType: FuelType
    
    var notes: String
    var distanceTraveled: Double
    
    var fuelAmount: Double?
    var pricePerLiter: Double?
    
    var energyAmount: Double?
    var pricePerEnergyUnit: Double?
    
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
    
    /// **Total cost for this refueling**
    var dieselOrGasolineTotalPrice: Double {
        pricePerLiter! * fuelAmount!
    }
    
    var electricTotalPrice: Double {
        energyAmount! * pricePerEnergyUnit!
    }

    /// **Fuel efficiency: Distance traveled per unit of fuel (km/L for gasoline/diesel)**
    var fuelEfficiency: Double? {
        if let fuel = fuelAmount, fuel > 0 {
            return distanceTraveled / fuel
        }
        return nil
    }

    /// **Energy efficiency: Energy used per distance traveled (kWh/km for electric vehicles)**
    var energyEfficiency: Double? {
        if fuelType == .electric, let energy = energyAmount, energy > 0 {
            return energy / distanceTraveled
        }
        return nil
    }

    /// **Cost per distance unit (e.g., cost per km or mile)**
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

    /// **Cost per unit of fuel (same as price per unit)**
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
