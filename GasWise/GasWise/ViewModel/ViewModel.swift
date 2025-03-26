import SwiftUI
import SwiftData

@Observable
class VehicleViewModel {
    var modelContext: ModelContext? = nil
    
    var allVehicles: [Vehicle] = []
    
    // MARK: Vehicle section
    
    func showVehicleStatistics() -> Bool {
        for vehicle in allVehicles {
            if vehicle.refuelings.count > 0 {
                return true
            }
        }
        return false
    }
    
    func fetchVehicles() {
        let request = FetchDescriptor<Vehicle>(sortBy: [SortDescriptor(\.id)])
        do {
            allVehicles = try modelContext?.fetch(request) ?? []
        } catch {
            print("Failed to fetch vehicles: \(error)")
        }
    }
    
    func deleteVehicle(offsets: IndexSet) {
        withAnimation {
            offsets.map { allVehicles[$0] }.forEach { vehicle in
                modelContext?.delete(vehicle)
            }
            do {
                try modelContext?.save()
                fetchVehicles() // Refresh list
            } catch {
                print("Error saving context: \(error)")
            }
        }
    }
    
    func saveVehicle(plateNumber: String,
                     name: String,
                     make: String,
                     model: String,
                     year: String,
                     fuelType: FuelType,
                     tankCapacity: String?,
                     batteryCapacity: String?,
                     odometer: String) {
        
        guard let odometerDouble = Double(odometer) else { return }
        
        let newVehicle = Vehicle(
            id: plateNumber,
            name: name,
            make: make,
            model: model,
            year: year,
            fuelType: fuelType,
            odometer: odometerDouble
        )
        
        if let tankCapacityDouble = Double(tankCapacity ?? "00.0") {
            newVehicle.tankCapacity = tankCapacityDouble
        }
        
        if let batteryCapacityDouble = Double(batteryCapacity ?? "00.0") {
            newVehicle.batteryCapacity = batteryCapacityDouble
        }
        modelContext?.insert(newVehicle)
        
        fetchVehicles() // Refresh list after saving
    }
}
