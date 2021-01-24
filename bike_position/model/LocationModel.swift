import Foundation
import CoreLocation
import Combine
import MapKit
import Foundation
import Combine

class LocationManager: NSObject, ObservableObject {
    private let locationManager = CLLocationManager()
    let objectWillChange = PassthroughSubject<Void, Never>()

    @Published var status: CLAuthorizationStatus? {
        willSet { objectWillChange.send() }
    }

    @Published var lastLocation: CLLocation? {
        willSet { objectWillChange.send() }
    }

    @Published var lastRegion: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)) {
        willSet { objectWillChange.send() }
    }

    override init() {
        super.init()

        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }


}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.status = status
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let conveter = LocationConverter()
        let newLocation = conveter.transformFromWGSToGCJ(wgsLoc: CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude))

        self.lastLocation = CLLocation(latitude: newLocation.latitude, longitude: newLocation.longitude)
        self.lastRegion = MKCoordinateRegion(center: newLocation, span: self.lastRegion.span)
    }
}



