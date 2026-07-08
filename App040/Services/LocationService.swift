import Combine
import Foundation
import CoreLocation

final class LocationService: NSObject, ObservableObject, CLLocationManagerDelegate {

    private let manager = CLLocationManager()

    @Published var currentLocation: CLLocation?
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var savedLocations: [SavedLocation] = []

    override init() {
        super.init()

        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest

        authorizationStatus = manager.authorizationStatus

        loadLocations()
        requestPermission()

        // Don't rely solely on the delegate's "change" callback firing —
        // if we're already authorized from a previous session, start now.
        startUpdatingIfAuthorized()
    }

    deinit {
        manager.stopUpdatingLocation()
    }

    // MARK: Permission

    func requestPermission() {
        manager.requestWhenInUseAuthorization()
    }

    func startUpdating() {
        manager.startUpdatingLocation()
    }

    func stopUpdating() {
        manager.stopUpdatingLocation()
    }

    private func startUpdatingIfAuthorized() {
        if authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways {
            startUpdating()
        }
    }

    // MARK: Record location for a game round

    func recordWhenAvailable(gameName: String) {
        if currentLocation != nil {
            saveGameLocation(gameName: gameName)
            return
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            if self.currentLocation != nil {
                self.saveGameLocation(gameName: gameName)
            } else {
                print("Location not available")
            }
        }
    }

    func saveGameLocation(gameName: String) {
        guard let location = currentLocation else { return }

        let saved = SavedLocation(
            id: UUID(),
            gameName: gameName,
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude,
            date: Date()
        )

        savedLocations.append(saved)
        saveLocations()
    }

    private func saveLocations() {
        if let data = try? JSONEncoder().encode(savedLocations) {
            UserDefaults.standard.set(data, forKey: "saved_locations")
        }
    }

    private func loadLocations() {
        guard let data = UserDefaults.standard.data(forKey: "saved_locations") else { return }
        if let locations = try? JSONDecoder().decode([SavedLocation].self, from: data) {
            savedLocations = locations
        }
    }

    // MARK: Convenience for UI

    var latitude: Double? { currentLocation?.coordinate.latitude }
    var longitude: Double? { currentLocation?.coordinate.longitude }

    /// A ready-to-display string for showing location during gameplay.
    var displayString: String {
        guard let location = currentLocation else {
            switch authorizationStatus {
            case .denied, .restricted:
                return "Location access denied"
            case .notDetermined:
                return "Requesting location…"
            default:
                return "Locating…"
            }
        }
        return String(format: "%.5f, %.5f", location.coordinate.latitude, location.coordinate.longitude)
    }

    // MARK: - CLLocationManagerDelegate

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latest = locations.last else { return }
        DispatchQueue.main.async { [weak self] in
            self?.currentLocation = latest
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error.localizedDescription)")
        manager.stopUpdatingLocation()
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        DispatchQueue.main.async { [weak self] in
            self?.authorizationStatus = status
            if status == .authorizedWhenInUse || status == .authorizedAlways {
                manager.startUpdatingLocation()
            } else {
                manager.stopUpdatingLocation()
                self?.currentLocation = nil
            }
        }
    }
}

// MARK: - Saved Location Model

struct SavedLocation: Identifiable, Codable {
    let id: UUID
    let gameName: String
    let latitude: Double
    let longitude: Double
    let date: Date
}
