import SwiftUI

struct VehicleListSection: View { 
    @Environment(\.modelContext) var modelContext
    @State var viewModel = VehicleViewModel()

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
            .onAppear {
                viewModel.modelContext = modelContext
                viewModel.fetch()
            }
        }
    }
    
    
}
