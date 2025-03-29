import SwiftUI
import SwiftData

@MainActor
class ViewModel: ObservableObject {
    
    static let container: ModelContainer = {
        let schema = Schema([
            Vehicle.self,
            Refueling.self,
            GasStation.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    // 2. Declare a static ModelContext derived from the container
    static var modelContext: ModelContext {
        container.mainContext
    }
    
    // You might also want a way to provide this context to your SwiftUI views
    static var sharedContext: ModelContext {
        container.mainContext
    }
//    
//    func deleteRefueling(offsets: IndexSet) {
//        offsets.map { allRefuelings[$0] }.forEach(ViewModel.modelContext!.delete)
//        do {
//            try ViewModel.modelContext!.save()
//            fetchRefuelings() // Refresh list
//        } catch {
//            print("Error saving context: \(error)")
//        }
//    }
//    
//    // MARK: Vehicle section
//    
//    func showVehicleStatistics() -> Bool {
//        for vehicle in allVehicles {
//            if vehicle.refuelings.count > 0 {
//                return true
//            }
//        }
//        return false
//    }
//    
//    func deleteVehicle(offsets: IndexSet) {
//        withAnimation {
//            offsets.map { allVehicles[$0] }.forEach { vehicle in
//                ViewModel.modelContext?.delete(vehicle)
//            }
//            do {
//                try modelContext?.save()
//                fetchVehicles() // Refresh list
//            } catch {
//                print("Error saving context: \(error)")
//            }
//        }
//    }
//    
//    func saveVehicle(plateNumber: String,
//                     name: String,
//                     make: String,
//                     model: String,
//                     year: String,
//                     fuelType: FuelType,
//                     tankCapacity: String?,
//                     batteryCapacity: String?,
//                     odometer: String) {
//
//        guard let odometerDouble = Double(odometer) else { return }
//        
//        let newVehicle = Vehicle(
//            id: plateNumber,
//            name: name,
//            make: make,
//            model: model,
//            year: year,
//            fuelType: fuelType,
//            odometer: odometerDouble
//        )
//        
//        if let tankCapacityDouble = Double(tankCapacity ?? "00.0") {
//            newVehicle.tankCapacity = tankCapacityDouble
//        }
//        
//        if let batteryCapacityDouble = Double(batteryCapacity ?? "00.0") {
//            newVehicle.batteryCapacity = batteryCapacityDouble
//        }
//        ViewModel.modelContext?.insert(newVehicle)
//        
//        do {
//            try ViewModel.modelContext?.save()
//            fetchVehicles() // Refresh list after saving
//        } catch {
//            print("Error saving context: \(error)")
//        }
//    }
}
