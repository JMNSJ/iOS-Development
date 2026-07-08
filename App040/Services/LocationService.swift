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
        manager.distanceFilter = kCLDistanceFilterNone

        authorizationStatus = manager.authorizationStatus

        loadLocations()

        requestPermission()
    }


    deinit {
        manager.stopUpdatingLocation()
    }



    // MARK: - Permission


    func requestPermission() {

        switch manager.authorizationStatus {

        case .notDetermined:
            manager.requestWhenInUseAuthorization()

        case .authorizedWhenInUse,
             .authorizedAlways:

            startUpdating()

        case .denied,
             .restricted:

            print("Location permission denied")

        @unknown default:
            break
        }
    }


    func startUpdating() {

        print("Starting location updates")

        manager.startUpdatingLocation()
    }


    func stopUpdating() {

        manager.stopUpdatingLocation()
    }



    // MARK: - Save game location


    func recordWhenAvailable(gameName: String) {

        if currentLocation != nil {

            saveGameLocation(gameName: gameName)
            return
        }


        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {

            if self.currentLocation != nil {

                self.saveGameLocation(gameName: gameName)

            } else {

                print("Location still unavailable")
            }
        }
    }



    func saveGameLocation(gameName: String) {

        guard let location = currentLocation else {

            print("No location available")
            return
        }


        let saved = SavedLocation(
            id: UUID(),
            gameName: gameName,
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude,
            date: Date()
        )


        savedLocations.append(saved)

        saveLocations()


        print(
            "Saved location:",
            saved.latitude,
            saved.longitude
        )
    }



    // MARK: - Persistence


    private func saveLocations() {

        do {

            let data = try JSONEncoder().encode(savedLocations)

            UserDefaults.standard.set(
                data,
                forKey: "saved_locations"
            )

        } catch {

            print("Saving locations failed:", error)
        }
    }



    private func loadLocations() {

        guard let data = UserDefaults.standard.data(
            forKey: "saved_locations"
        )
        else {
            return
        }


        do {

            savedLocations =
            try JSONDecoder()
                .decode(
                    [SavedLocation].self,
                    from: data
                )

        } catch {

            print("Loading locations failed:", error)
        }
    }




    // MARK: - Convenience


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



    var displayString: String {

        guard let location = currentLocation else {


            switch authorizationStatus {


            case .denied,
                 .restricted:

                return "Location access denied"



            case .notDetermined:

                return "Requesting location..."



            default:

                return "Still trying to get your location..."
            }
        }


        return String(
            format: "%.5f, %.5f",
            location.coordinate.latitude,
            location.coordinate.longitude
        )
    }




    // MARK: - CLLocationManagerDelegate



    func locationManagerDidChangeAuthorization(
        _ manager: CLLocationManager
    ) {


        let status = manager.authorizationStatus


        print(
            "Authorization status:",
            status.rawValue
        )


        DispatchQueue.main.async {

            self.authorizationStatus = status


            switch status {


            case .authorizedWhenInUse,
                 .authorizedAlways:


                print("Permission granted")

                self.startUpdating()



            case .denied,
                 .restricted:


                print("Permission denied")

                self.currentLocation = nil



            default:

                break
            }
        }
    }





    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {


        guard let latest = locations.last else {
            return
        }


        print(
            "NEW LOCATION:",
            latest.coordinate.latitude,
            latest.coordinate.longitude
        )


        DispatchQueue.main.async {

            self.currentLocation = latest
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



// MARK: - Saved Location Model


struct SavedLocation: Identifiable, Codable {


    let id: UUID

    let gameName: String

    let latitude: Double

    let longitude: Double

    let date: Date
}
