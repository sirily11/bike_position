//
//  DetailPage.swift
//  bike_position
//
//  Created by 李其炜 on 1/23/21.
//

import MapKit
import CoreLocation
import SwiftUI

struct Pin: Identifiable {
    var id = UUID()
    var location: CLLocationCoordinate2D
}


struct DetailPage: View {
    let bike: BikeHistory
    @EnvironmentObject var bikeModel: BikeModel
    @State var tracking: MapUserTrackingMode = .follow
    @State var name: String
    @State var isActived: Bool {
        didSet {
            bikeModel.updateBike(bikeId: bike.id, name: nil, isActived: isActived)
        }
    }
    @State var region: MKCoordinateRegion? = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001))

    var pins: [Pin]

    init(bike: BikeHistory) {
        self.bike = bike
        self._name = State(initialValue: bike.name)
        self._isActived = State(initialValue: bike.isActived)
        pins = [Pin(location: bike.location.coordinate)]

    }

    func openMapApp() {
        let placeMark = MKPlacemark(coordinate: bike.location.coordinate)
        let mapItem = MKMapItem(placemark: placeMark)
        if let region = region {
            let options = [
                MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: region.center),
                MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: region.span)
            ]
            mapItem.name = "\(bike.name)"
            mapItem.openInMaps(launchOptions: options)
        }
    }


    var body: some View {
        let bind = Binding<Bool>(
            get: { self.isActived },
            set: { self.isActived = $0 }
        )

        VStack {
            if region != nil {
                Map(coordinateRegion: Binding($region)!, interactionModes: .all, showsUserLocation: true, userTrackingMode: $tracking, annotationItems: pins) { place in

                    MapMarker(coordinate: place.location)

                }
                    .ignoresSafeArea()
            } else {
                Text("No position")
            }

            VStack {
                TextField("Name", text: $name, onEditingChanged: { _ in }, onCommit: { bikeModel.updateBike(bikeId: bike.id, name: name, isActived: nil) })
                    .padding(.bottom, 10.0)

                Divider()
                Toggle(isOn: bind) {
                    Text("Is Actived")
                }



            }

                .padding()
        }

            .onAppear {
                region = MKCoordinateRegion(center: bike.location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001))


            }
            .toolbar {
                Button(action: {
                    openMapApp()
                }) {
                    Image(systemName: "map.fill")
                }
            }
            .navigationTitle("\(bike.name)")


    }

}


struct Preview_wrapper {

    var body: some View {
        DetailPage(bike: bikesData[0])
    }
}

struct DetailPage_Previews: PreviewProvider {
    static var previews: some View {
        PreviewWrapper()
    }
}
