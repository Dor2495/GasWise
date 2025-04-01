//
//  PlateNumberView.swift
//  GasWise
//
//  Created by Dor Mizrachi on 25/03/2025.
//

import SwiftUI

struct PlateNumberView: View {
    
    var plateNumber: String
    
    var body: some View {
        ZStack {
            HStack(spacing: 0) {
                Rectangle()
                    .frame(maxWidth: 30)
                    .foregroundStyle(.blue)
                
                ZStack {
                    Rectangle()
                        .foregroundStyle(.yellow)
                    
                    Text("\(plateNumber)")
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
    PlateNumberView(plateNumber: "12345567")
}
