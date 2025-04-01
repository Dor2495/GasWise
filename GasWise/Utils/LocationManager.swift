//
//  LocationManager.swift
//  GasWise
//
//  Created by Dor Mizrachi on 20/03/2025.
//

//import Foundation
//import CoreLocation
//
//class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
//    
//    private var locationManager = CLLocationManager()
//    
//    @Published var location: CLLocation?
//    @Published var authorizationStatus: CLAuthorizationStatus?
//    
//    override init() {
//        super.init()
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.requestWhenInUseAuthorization() // Or requestAlwaysAuthorization() if needed.
//        locationManager.startUpdatingLocation()
//    }
//    
//    func requestLocation() {
//        locationManager.requestLocation()
//    }
//    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let location = locations.last else { return }
//        DispatchQueue.main.async {
//            self.location = location
//        }
//    }
//    
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print("Location manager failed with error: \(error.localizedDescription)")
//    }
//    
//    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
//        DispatchQueue.main.async {
//            self.authorizationStatus = manager.authorizationStatus
//            
//            switch manager.authorizationStatus {
//            case .authorizedAlways, .authorizedWhenInUse:
//                self.locationManager.startUpdatingLocation()
//                break;
//            case .denied, .restricted:
//                self.locationManager.stopUpdatingLocation()
//                self.location = nil;
//            case .notDetermined:
//                self.locationManager.requestWhenInUseAuthorization()
//            default:
//                break;
//            }
//        }
//    }
//}
