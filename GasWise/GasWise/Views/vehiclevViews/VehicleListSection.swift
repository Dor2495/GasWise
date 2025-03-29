import SwiftUI
import SwiftData

struct VehicleListSection: View {
    @Environment(\.modelContext) var modelContext
    @Query var allVehicles: [Vehicle]
    
    var viewModel = ViewModel()

    @Binding var showVehicleStatistics: Bool

    var body: some View {
        if allVehicles.count > 0 {
            VehicleChartView(vehicles: allVehicles)
        }
        Section(header: Label("My Cars", systemImage: "list.bullet")) {
            ForEach(allVehicles) { vehicle in
                NavigationLink(destination: VehicleDetailsView(vehicle: vehicle)) {
                    VehicleRowView(vehicle: vehicle)
                }
            }
//            .onDelete(perform: viewModel.deleteVehicle)
            .onAppear {
                print("VehicleListSection.appear")
            }
        }
    }
}
