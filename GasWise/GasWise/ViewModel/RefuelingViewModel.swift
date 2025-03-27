import swiftData
import foundation

@Obsarvable
class RefuelingViewModel {

  var modelContext: ModelContext? = nil

  var allRefuelings: [Refueling] = []


  func fetchRefuelings() {
    let request = FetchDescriptor<Refueling>(sortBy: [SortDescriptor(\.date)])
        do {
            allRefuelings = try modelContext?.fetch(request) ?? []
        } catch {
            print("Failed to fetch refuelings: \(error)")
        }
    
  }

}
