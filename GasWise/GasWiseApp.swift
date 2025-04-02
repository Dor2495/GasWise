//
//  GasWiseApp.swift
//  GasWise
//
//  Created by Dor Mizrachi on 18/03/2025.
//

import SwiftUI
import SwiftData

/// A fuel tracking application that helps users monitor and analyze their vehicle refueling history.
///
/// GasWise allows users to:
/// - Track vehicle refueling events
/// - Manage multiple vehicles
/// - Record gas station information
/// - Analyze fuel consumption patterns
///
/// The app uses SwiftData for persistent storage of refueling records, gas station information,
/// and vehicle details.
@main
struct GasWiseApp: App {
    
    /// The shared SwiftData model container for the application.
    ///
    /// This container manages the persistent storage for the following model types:
    /// - `Refueling`: Represents individual vehicle refueling events
    /// - `GasStation`: Stores information about gas stations
    /// - `Vehicle`: Contains details about user vehicles
    ///
    /// The container is configured with persistent storage (not memory-only)
    /// to ensure data is preserved between app launches.
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

    
    
    /// The body property that defines the app's scene structure.
    ///
    /// Creates a window group containing the main content view and attaches
    /// the shared model container to provide SwiftData access throughout the app.
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
