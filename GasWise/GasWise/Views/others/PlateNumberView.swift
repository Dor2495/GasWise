//
//  PlateNumberView.swift
//  GasWise
//
//  Created by Dor Mizrachi on 25/03/2025.
//

import SwiftUI

struct PlateNumberView: View {
    
    var vehicle: Vehicle
    
    var body: some View {
        ZStack {
            HStack(spacing: 0) {
                Rectangle()
                    .frame(maxWidth: 30)
                    .foregroundStyle(.blue)
                
                ZStack {
                    Rectangle()
                        .foregroundStyle(.yellow)
                    
                    Text("\(vehicle.plateNumber)")
                        .font(.system(size: 42, weight: .bold, design: .monospaced))
                }
            }
            
            Rectangle()
                .stroke(lineWidth: 10)
                .foregroundStyle(.black)
            
        }
        .frame(maxHeight: 100, alignment: .leading)
        .cornerRadius(7)
        .padding(3)
    }
}

#Preview {
    PlateNumberView(
        vehicle: Vehicle(
            id: "40206502",
            name: "",
            make: "",
            model: "",
            year: "",
            fuelType: .diesel,
            odometer: 00.0
        )
    )
}
