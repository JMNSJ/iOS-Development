import Combine
import Foundation
import CoreLocation


final class LocationService: NSObject, ObservableObject {
    
    
    private let manager = CLLocationManager()
    
    
    @Published var currentLocation: CLLocation?
    
    
    override init() {
        
        super.init()
        
        manager.delegate = self
        
        manager.desiredAccuracy =
        kCLLocationAccuracyBest
        
        requestPermission()
    }
    
    
    
    // MARK: Request Permission
    
    func requestPermission() {
        
        manager.requestWhenInUseAuthorization()
        
        manager.startUpdatingLocation()
    }
    
    
    
    // MARK: Get Coordinates
    
    
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





extension LocationService: CLLocationManagerDelegate {
    
    
    func locationManager(
        _ manager: CLLocationManager,
        didChangeAuthorization status: CLAuthorizationStatus
    ) {
        
        switch status {
            
        case .authorizedWhenInUse,
             .authorizedAlways:
            
            manager.startUpdatingLocation()
            
            
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
        
        
        // We only need one location
        manager.stopUpdatingLocation()
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
