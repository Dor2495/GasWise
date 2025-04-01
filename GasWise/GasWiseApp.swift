//
//  GasWiseApp.swift
//  GasWise
//
//  Created by Dor Mizrachi on 18/03/2025.
//

import SwiftUI
import SwiftData

@main
struct GasWiseApp: App {
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Refueling.self,
            GasStation.self,
            Vehicle.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
