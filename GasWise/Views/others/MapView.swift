//import SwiftUI
//import MapKit
//
//struct MapView: View {
//    @Environment(\.dismiss) private var dismiss
//    @StateObject var locationManager = LocationManager()
//    @Binding var selectedGasStation: GasStation?
//    
//    @State private var cameraPosition: MapCameraPosition = .userLocation(fallback: .region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.3349, longitude: -122.0090), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))))
//
//    var body: some View {
//        MapReader { reader in
//            Map(position: $cameraPosition) {
//                if let station = selectedGasStation {
//                    Marker(station.name, coordinate: station.coordinate)
//                        .tint(.blue)
//                }
//                UserAnnotation()
//            }
//            .mapControls {
//                MapUserLocationButton()
//                MapCompass()
//            }
//            .onTapGesture { location in
//                let coordinate = reader.convert(location, from: .local)
//                selectedGasStation = GasStation(
//                    name: "",
//                    latitude: coordinate?.latitude ?? 32,
//                    longitude: coordinate?.longitude ?? 35
//                )
//            }
//            .toolbar {
//                ToolbarItem(placement: .topBarTrailing) {
//                    Button {
//                        dismiss()
//                    } label: {
//                        Image(systemName: "checkmark.square")
//                    }
//                }
//            }
//        }
//    }
//    
//    func navigateToStation() {
//        guard let station = selectedGasStation else { return }
//        let placemark = MKPlacemark(coordinate: station.coordinate)
//        let mapItem = MKMapItem(placemark: placemark)
//        mapItem.name = station.name
//        mapItem.openInMaps(launchOptions: [
//            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
//        ])
//    }
//}
//
//#Preview {
//    @State var gasStation: GasStation? = nil
//    MapView(selectedGasStation: $gasStation)
//}
