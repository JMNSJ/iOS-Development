import SwiftUI
import MapKit

struct MapTab: View {

    @EnvironmentObject var sessionStore: SessionStore
    @EnvironmentObject var locationService: LocationService

    @State private var selectedSession: GameSession?
    @State private var hasSetInitialPosition = false
    @State private var showLocationUnavailableAlert = false

    @State private var position = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 7.8731, longitude: 80.7718),
            span: MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5)
        )
    )

    var body: some View {

        Map(position: $position) {

            // MARK: - Current User Location
            UserAnnotation()

            // MARK: - Completed Game Sessions
            ForEach(sessionStore.sessions) { session in
                if let latitude = session.latitude, let longitude = session.longitude {
                    Annotation(session.mode.rawValue, coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude)) {
                        Button {
                            selectedSession = session
                        } label: {
                            VStack(spacing: 4) {
                                Image(systemName: gameIcon(session.mode))
                                    .font(.title2)
                                    .foregroundColor(.blue)
                                Circle()
                                    .fill(.blue)
                                    .frame(width: 10, height: 10)
                            }
                        }
                    }
                }
            }

            // MARK: - Game Start Locations
            ForEach(locationService.savedLocations) { location in
                Annotation(location.gameName, coordinate: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)) {
                    VStack(spacing: 3) {
                        Image(systemName: "mappin.circle.fill")
                            .font(.title)
                            .foregroundColor(.red)
                        Text(location.gameName)
                            .font(.caption2)
                            .padding(4)
                            .background(Color.white)
                            .cornerRadius(5)
                    }
                }
            }
        }
        .navigationTitle("Game Map")

        // MARK: - Current Location Button
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    moveToCurrentLocation()
                } label: {
                    Image(systemName: "location.fill")
                }
            }
        }

        // MARK: - Permission + Initial Position
        .onAppear {
            switch locationService.authorizationStatus {
            case .notDetermined:
                locationService.requestPermission()
            case .authorizedAlways, .authorizedWhenInUse:
                locationService.startUpdating()
            case .denied, .restricted:
                print("Location permission denied")
            @unknown default:
                break
            }

            // Only set the initial camera position once, so returning to
            // this tab later doesn't reset a position the user panned to.
            if !hasSetInitialPosition {
                hasSetInitialPosition = true
                if locationService.savedLocations.isEmpty {
                    moveToCurrentLocation()
                } else {
                    moveToLastGameLocation()
                }
            }
        }

      
        .onChange(of: locationService.currentLocation) { _, newValue in
            guard let newValue, locationService.savedLocations.isEmpty, hasSetInitialPosition else { return }
            withAnimation {
                position = .region(
                    MKCoordinateRegion(
                        center: newValue.coordinate,
                        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                    )
                )
            }
        }

        .alert("Location unavailable", isPresented: $showLocationUnavailableAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(locationAlertMessage)
        }

        .sheet(item: $selectedSession) { session in
            SessionDetailView(session: session)
        }
    }

    // MARK: - Move To Current Location

    private func moveToCurrentLocation() {
        guard let location = locationService.currentLocation else {
            showLocationUnavailableAlert = true

            if locationService.authorizationStatus == .authorizedWhenInUse
                || locationService.authorizationStatus == .authorizedAlways {
                locationService.startUpdating()
            }
            return
        }

        withAnimation {
            position = .region(
                MKCoordinateRegion(
                    center: location.coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                )
            )
        }
    }

    // MARK: - Move To Latest Game Location

    private func moveToLastGameLocation() {
        guard let last = locationService.savedLocations.last else { return }

        position = .region(
            MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: last.latitude, longitude: last.longitude),
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            )
        )
    }

    private var locationAlertMessage: String {
        switch locationService.authorizationStatus {
        case .denied, .restricted:
            return "Location access is disabled. Enable it in Settings to see your current location on the map."
        default:
            return "Still trying to get your location. Try again in a moment."
        }
    }

    private func gameIcon(_ mode: GameMode) -> String {
        switch mode {
        case .tapFrenzy:
            return "hand.tap.fill"
        case .lightItUp:
            return "lightbulb.fill"
        case .quizRush:
            return "questionmark.circle.fill"
        }
    }
}

// MARK: - Session Detail View

struct SessionDetailView: View {

    let session: GameSession

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: gameIcon)
                .font(.system(size: 50))
                .foregroundColor(.blue)

            Text(session.mode.rawValue)
                .font(.largeTitle)
                .bold()

            Text("Score: \(session.score)")
                .font(.title2)

            Divider()

            VStack(spacing: 8) {
                Text("Completed")
                    .font(.headline)
                Text(session.timestamp, style: .date)
                Text(session.timestamp, style: .time)
            }

            if let latitude = session.latitude, let longitude = session.longitude {
                Divider()
                Text("Location")
                    .font(.headline)
                Text(String(format: "%.5f, %.5f", latitude, longitude))
                    .font(.caption)
            }

            Spacer()
        }
        .padding()
        .presentationDetents([.medium])
    }

    private var gameIcon: String {
        switch session.mode {
        case .tapFrenzy:
            return "hand.tap.fill"
        case .lightItUp:
            return "lightbulb.fill"
        case .quizRush:
            return "questionmark.circle.fill"
        }
    }
}
