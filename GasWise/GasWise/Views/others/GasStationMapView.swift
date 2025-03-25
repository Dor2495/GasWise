//
//  GasStationMapView.swift
//  GasWise
//
//  Created by Dor Mizrachi on 23/03/2025.
//

import SwiftUI
import MapKit

struct GasStationMapView: View {
    
    var gasStation: GasStation
    
    var body: some View {
        NavigationView {
            Map {
                Marker("\(gasStation.name)", coordinate: gasStation.coordinate)
            }
            .navigationTitle(gasStation.name)
        }
    }
}

#Preview {
    @Previewable @State var gasStation: GasStation = .init(name: "", latitude: 0, longitude: 0)
    GasStationMapView(gasStation: gasStation)
}
