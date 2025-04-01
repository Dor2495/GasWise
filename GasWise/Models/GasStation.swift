//
//  GasStation.swift
//  GasWise
//
//  Created by Dor Mizrachi on 20/03/2025.
//

import Foundation
import SwiftData
import CoreLocation

@Model
class GasStation: Equatable {
    var id: UUID = UUID()
    var name: String
    var latitude: Double
    var longitude: Double
    
    @Relationship(inverse: \Refueling.gasStation)
    var refuelings: [Refueling] = []

    init(name: String, latitude: Double, longitude: Double) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
    }
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
