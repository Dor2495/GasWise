import SwiftUI
import SwiftData
import Charts

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    
    @Query var allRefuelings: [Refueling]
    @Query var allVehicles: [Vehicle]
    
    
    var viewModel = ViewModel()
    
    @State private var showAddNewRefueling: Bool = false
    @State var showAddNewCar: Bool = false
    @State var showRefuelingStatistics: Bool = true
    @State var showVehicleStatistics: Bool = true
    
    @State private var selectedView: ViewToDisplay = .Vehicles

    var body: some View {
        NavigationStack {
            VStack {
                if allRefuelings.isEmpty && allVehicles.isEmpty {
                    EmptyDataView(showAddNewCar: $showAddNewCar)
                } else {
                    VStack {
                        // **Segmented Picker**
                        Picker("Select View", selection: $selectedView) {
                            ForEach(ViewToDisplay.allCases) { view in
                                Text(view.rawValue).tag(view)
                            }
                        }
                        .pickerStyle(.segmented) // **Use Segmented Style**
                        .padding(.horizontal)
                        
                        // **Show Vehicles or Refuelings Based on Selection**
                        List {
                            if selectedView == .Vehicles {
                                VehicleListSection(showVehicleStatistics: $showVehicleStatistics)
                            } else {
                                RefuelingListSection(showRefuelingStatistics: $showRefuelingStatistics)
                            }
                        }
                    }
                }
            }
            .navigationTitle("My Garage")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    HStack(alignment: .firstTextBaseline) {
                        // vehicles add button
                        if selectedView == .Vehicles {
                            Button {
                                showAddNewCar = true
                            } label: {
                                Image(systemName: "car.2.fill")
                                    .imageScale(.large)
                                    .foregroundStyle(.green)
                            }
                        } else {
                            Button {
                                showAddNewRefueling = true
                            } label: {
                                Image(systemName: "list.bullet.clipboard.fill")
                                    .imageScale(.large)
                            }
                        }
                    }
                }
            }
            .sheet(isPresented: $showAddNewRefueling) {
                AddNewRefuelingView()
            }
            .sheet(isPresented: $showAddNewCar) {
                AddVehicleView()
            }
        }
    }
    
    enum ViewToDisplay: String, CaseIterable, Identifiable {
        case Vehicles = "Vehicles"
        case Refuelings = "Refuelings"
        var id: Self { self }
    }
}
