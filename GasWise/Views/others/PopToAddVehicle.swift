//
//  PopToAddVehicle.swift
//  GasWise
//
//  Created by Dor Mizrachi on 01/04/2025.
//

import SwiftUI

struct PopToAddVehicle: View {
    
    var addVehicle: ((Bool) -> Void)?
    
    init(addVehicle: ((Bool) -> Void)? = nil) {
        self.addVehicle = addVehicle
    }
    
    var body: some View {
        
        ContentUnavailableView {
            Button {
                addVehicle?(true)
            } label: {
                Text("Add Vehicle")
            }
        } description: {
            VStack {
                Text("No Vehicles in the Garage yet ...")
                Text("Add your first vehicle to get started!")
            }
        }

        
        
        
    }
}

#Preview {
    
}
