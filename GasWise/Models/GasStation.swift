//
//  GasStation.swift
//  GasWise
//
//  Created by Dor Mizrachi on 20/03/2025.
//

import Foundation
import SwiftData
import CoreLocation

/// A model representing a gas station or charging location in the GasWise application.
///
/// The `GasStation` class stores information about refueling locations including:
/// - Basic identification (name)
/// - Geographic coordinates for mapping
/// - Associated refueling records
///
/// This model enables location-based analysis of refueling patterns and 
/// supports features like mapping nearby stations and tracking price differences
/// between locations.
@Model
class GasStation: Equatable {
    /// Unique identifier for the gas station.
    var id: UUID = UUID()
    
    /// Name or brand of the gas station.
    var name: String
    
    /// Geographic latitude coordinate of the station's location.
    var latitude: Double
    
    /// Geographic longitude coordinate of the station's location.
    var longitude: Double
    
    /// Collection of refueling records that occurred at this gas station.
    /// This relationship is configured with an inverse that connects back to the refueling records.
    @Relationship(inverse: \Refueling.gasStation)
    var refuelings: [Refueling] = []

    /// Initializes a new gas station with the specified properties.
    ///
    /// - Parameters:
    ///   - name: Name or brand of the gas station
    ///   - latitude: Geographic latitude coordinate of the station
    ///   - longitude: Geographic longitude coordinate of the station
    init(name: String, latitude: Double, longitude: Double) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
    }
    
    /// Converts the station's latitude and longitude into a Core Location coordinate.
    ///
    /// This computed property provides easy integration with MapKit and
    /// other location-based services in the app.
    ///
    /// - Returns: A CLLocationCoordinate2D object representing the station's location.
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
