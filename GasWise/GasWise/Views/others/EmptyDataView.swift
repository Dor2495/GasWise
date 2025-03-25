//
//  EmptyDataView.swift
//  GasWise
//
//  Created by Dor Mizrachi on 25/03/2025.
//

import SwiftUI

struct EmptyDataView: View {
    
    
    @Binding var showAddNewCar: Bool
    
    var body: some View {
        ContentUnavailableView {
            Label("No Data Found!", systemImage: "fuelpump.slash.fill")
                .font(.title)
        } description: {
            Text("Add your first refueling record to get started")
                .font(.body)
        } actions: {
            Button {
                showAddNewCar = true
            } label: {
                Text("Add New Car")
                    .font(.system(size: 17, weight: .bold))
            }
            .foregroundStyle(.green)
            
        }
    }
}

//#Preview {
//    EmptyDataView()
//}
