import SwiftUI

struct VehicleListSection: View {
    @EnvironmentObject var viewModel: VehicleViewModel

    @Binding var showVehicleStatistics: Bool

    var body: some View {
        if !viewModel.allVehicles.isEmpty {
            Section(header: Label("My Cars", systemImage: "list.bullet")) {
                ForEach(viewModel.allVehicles) { vehicle in
                    NavigationLink(destination: VehicleDetailsView(vehicle: vehicle)) {
                        VehicleRowView(vehicle: vehicle)
                    }
                }
                .onDelete(perform: viewModel.deleteVehicle)
            }
        }
    }
    
    
}
