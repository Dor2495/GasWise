//
//  LocationManager.swift
//  GasWise
//
//  Created by Dor Mizrachi on 20/03/2025.
//

//import Foundation
//import CoreLocation
//
/// A manager class for handling location services in the GasWise application.
///
/// `LocationManager` provides location-related functionality including:
/// - Requesting and tracking user location permissions
/// - Providing current device location updates
/// - Handling location error states
///
/// This class uses Core Location to support map-based features and
/// automatic location detection when adding refueling records or gas stations.
/// It implements the Observable pattern to provide reactive updates to views.
//class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
//    
//    /// Core Location manager instance that handles the actual location services.
//    private var locationManager = CLLocationManager()
//    
//    /// Published property that provides the current device location.
//    /// Views can subscribe to changes in this property to update accordingly.
//    @Published var location: CLLocation?
//    
//    /// Published property that tracks the current authorization status for location services.
//    /// Used to determine if the app has permission to access location data.
//    @Published var authorizationStatus: CLAuthorizationStatus?
//    
//    /// Initializes the location manager and configures initial settings.
//    ///
//    /// This constructor:
//    /// - Sets up the delegate relationship
//    /// - Configures accuracy settings
//    /// - Requests appropriate authorization
//    /// - Begins location updates if possible
//    override init() {
//        super.init()
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.requestWhenInUseAuthorization() // Or requestAlwaysAuthorization() if needed.
//        locationManager.startUpdatingLocation()
//    }
//    
//    /// Requests a one-time location update.
//    ///
//    /// This is useful when the app needs a current location but doesn't
//    /// need to receive continuous updates.
//    func requestLocation() {
//        locationManager.requestLocation()
//    }
//    
//    /// Delegate method called when new location data is available.
//    ///
//    /// - Parameters:
//    ///   - manager: The location manager providing the update
//    ///   - locations: An array of location objects, typically with the most recent location last
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let location = locations.last else { return }
//        DispatchQueue.main.async {
//            self.location = location
//        }
//    }
//    
//    /// Delegate method called when a location error occurs.
//    ///
//    /// - Parameters:
//    ///   - manager: The location manager reporting the error
//    ///   - error: The error that occurred
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print("Location manager failed with error: \(error.localizedDescription)")
//    }
//    
//    /// Delegate method called when the authorization status changes.
//    ///
//    /// This method handles changes in location permissions, starting or stopping
//    /// location updates as appropriate based on the new authorization status.
//    ///
//    /// - Parameter manager: The location manager reporting the change
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
