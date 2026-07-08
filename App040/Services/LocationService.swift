import Combine
import Foundation
import CoreLocation


final class LocationService: NSObject, ObservableObject {
    
    
    private let manager = CLLocationManager()
    
    
    @Published var currentLocation: CLLocation?
    
    @Published var authorizationStatus:
    CLAuthorizationStatus = .notDetermined
    
    
    
    override init() {
        
        super.init()
        
        manager.delegate = self
        
        manager.desiredAccuracy =
        kCLLocationAccuracyBest
        
        authorizationStatus =
        manager.authorizationStatus
        
        requestPermission()
    }
    
    
    
    // MARK: Permission
    
    
    func requestPermission() {
        
        manager.requestWhenInUseAuthorization()
    }
    
    
    
    // MARK: Start Updating
    
    
    func startUpdating() {
        
        manager.startUpdatingLocation()
    }
    
    
    
    // MARK: Coordinates
    
    
    var latitude: Double? {
        
        currentLocation?
            .coordinate
            .latitude
    }
    
    
    
    var longitude: Double? {
        
        currentLocation?
            .coordinate
            .longitude
    }
}



extension LocationService:
    CLLocationManagerDelegate {
    
    
    func locationManager(
        _ manager: CLLocationManager,
        didChangeAuthorization status: CLAuthorizationStatus
    ) {
        
        DispatchQueue.main.async {
            
            self.authorizationStatus = status
        }
        
        
        switch status {
            
        case .authorizedWhenInUse,
             .authorizedAlways:
            
            startUpdating()
            
            
        case .denied,
             .restricted:
            
            print(
                "Location permission denied"
            )
            
            
        case .notDetermined:
            break
            
            
        @unknown default:
            break
        }
    }
    
    
    
    
    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        
        guard let location =
                locations.last
        else {
            return
        }
        
        
        DispatchQueue.main.async {
            
            self.currentLocation = location
        }
    }
    
    
    
    
    func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: Error
    ) {
        
        print(
            "Location error:",
            error.localizedDescription
        )
    }
}
