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
    @State var hasInit = false
    @State var tracking: MapUserTrackingMode = .follow
    @State var name = ""
    @State var isActived: Bool = false
    @State var region: MKCoordinateRegion? = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001))

    var pins: [Pin]

    init(bike: BikeHistory) {
        self.bike = bike

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

                Toggle(isOn: $isActived) {
                    Text("Is Actived")
                }
                    .onReceive([isActived].publisher.first(), perform: { value in
                        if hasInit {
                            bikeModel.updateBike(bikeId: bike.id, name: nil, isActived: value)
                        }
                    })


            }
                .padding()
        }
            .onAppear {
                region = MKCoordinateRegion(center: bike.location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001))
                isActived = bike.isActived
                name = bike.name
                hasInit = true

            }
            .onDisappear {
                bikeModel.fetchBikes()
            }
            .toolbar {
                Button(action: {
                    openMapApp()
                }) {
                    Image(systemName: "map.fill")
                }
        }


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
