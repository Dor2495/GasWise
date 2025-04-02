//
//  BiilsScreen.swift
//  GasWise
//
//  Created by Dor Mizrachi on 01/04/2025.
//

import SwiftUI
import SwiftData

/// A view that displays refueling records (bills) and related statistics.
///
/// `BillsScreen` is the primary interface for viewing and managing refueling history.
/// It provides:
/// - A list of all refueling records
/// - Access to refueling details and statistics
/// - Options to add and delete refueling records
///
/// This view handles various states including empty garage, empty bills list,
/// and populated data scenarios appropriately.
struct BillsScreen: View {
    /// Query to retrieve all refueling records from the database.
    @Query private var bills: [Refueling]
    
    /// Query to retrieve all vehicles from the database.
    @Query private var garage: [Vehicle]
    
    /// Callback function used when deleting a refueling record.
    var deleteRefueling: ((Refueling) -> Void)?
    
    /// Callback function to show the add refueling sheet.
    var showAddRefuelingSheet: (() -> Void)?
    
    /// Function that determines whether to show a prompt to add vehicles.
    var showPopView: (() -> Bool)?
    
    /// Callback function when user interacts with the pop view.
    var pop: ((Bool) -> Void)?
    
    /// Initializes the bills screen with the required callbacks.
    ///
    /// - Parameters:
    ///   - deleteRefueling: Callback function executed when a refueling record is deleted
    ///   - showAddRefuelingSheet: Callback to show the add refueling sheet
    ///   - showPopView: Function determining if the "add vehicle" prompt should be shown
    ///   - pop: Callback function executed when user interacts with the pop view
    init(deleteRefueling: ((Refueling) -> Void)? = nil,
         showAddRefuelingSheet: (() -> Void)? = nil, showPopView: (() -> Bool)? = nil, pop: ((Bool) -> Void)? = nil) {
        self.deleteRefueling = deleteRefueling
        self.showAddRefuelingSheet = showAddRefuelingSheet
        self.showPopView = showPopView
        self.pop = pop
    }
    
    /// State variable controlling visibility of refueling statistics section.
    @State private var showRefuelingStatistics: Bool = false
    
    /// The body of the BillsScreen view defining its UI.
    var body: some View {
        NavigationStack {
            Group {
                if showPopView!() {
                    PopToAddVehicle { show in
                        pop!(show)
                    }
                } else {
                    if bills.isEmpty {
                        ContentUnavailableView("No bills yet", systemImage: "pencil.and.list.clipboard", description: Text("Add bills by tapping the plus button"))
                    } else {
                        List {
                            RefuelingStatisticsSection(showRefuelingStatistics: $showRefuelingStatistics, refuelings: bills)
                            
                            ForEach(bills) { bill in
                                NavigationLink(value: bill) {
                                    RefuelingRowView(refueling: bill)
                                }
                            }
                            .onDelete(perform: deleteRefueling)
                        }
                    }
                }
            }
            .navigationTitle("Bills")
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button {
                        showAddRefuelingSheet?()
                    } label: {
                        Image(systemName: "plus.circle")
                    }
                    .disabled(garage.isEmpty)
                }
            }
            .navigationDestination(for: Refueling.self) { bill in
                RefuelingDetailsView(refueling: bill)
            }
        }
    }
    
    /// Handles the deletion of refueling records from the IndexSet provided by SwiftUI's List.
    ///
    /// This method translates between SwiftUI's `IndexSet` deletion mechanism
    /// and the callback approach used by the parent view.
    ///
    /// - Parameter offsets: The IndexSet containing indices of refueling records to delete
    private func deleteRefueling(at offsets: IndexSet) {
        for index in offsets {
            deleteRefueling?(bills[index])
        }
    }
}

#Preview {
    BillsScreen(deleteRefueling: {_ in})
}
