import SwiftUI

struct VehicleListSection: View { 
    @Environment(\.modelContext) var modelContext
    
    
    var viewModel = ViewModel()

    @Binding var showVehicleStatistics: Bool

    var body: some View {
        if viewModel.showVehicleStatistics() {
            VehicleChartView(vehicles: viewModel.allVehicles)
        }
        Section(header: Label("My Cars", systemImage: "list.bullet")) {
            ForEach(viewModel.allVehicles) { vehicle in
                NavigationLink(destination: VehicleDetailsView(vehicle: vehicle)) {
                    VehicleRowView(vehicle: vehicle)
                }
            }
            .onDelete(perform: viewModel.deleteVehicle)
            .onAppear {
                viewModel.modelContext = modelContext
                viewModel.fetchVehicles()
            }
        }
    }
}
