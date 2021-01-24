//
//  bike_widget.swift
//  bike_widget
//
//  Created by 李其炜 on 1/24/21.
//

import WidgetKit
import SwiftUI
import MapKit
import CoreLocation

struct Provider: TimelineProvider {
    let location = CLLocation(latitude: 37.33555162843349, longitude: -122.0146692306286)


    private func makeMapSnapshotter(location: CLLocation, size: CGSize) -> MKMapSnapshotter {
        let options = MKMapSnapshotter.Options()
        options.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude), span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
        options.size = size


        return MKMapSnapshotter(options: options)

    }

    private func makeMapImage(bike: BikeHistory, snapshot: MKMapSnapshotter.Snapshot, size: CGSize) -> UIImage {
        let image = UIGraphicsImageRenderer(size: size).image {
            _ in
            snapshot.image.draw(at: .zero)


            let pinView = MKPinAnnotationView(annotation: nil, reuseIdentifier: nil)
            let pinImage = pinView.image
            var point = snapshot.point(for: bike.location.coordinate)

            point.x -= pinView.bounds.width / 2
            point.y -= pinView.bounds.height / 2
            point.x += pinView.centerOffset.x
            point.y += pinView.centerOffset.y
            pinImage?.draw(at: point)


        }
        return image
    }

    func placeholder(in context: Context) -> BikeEntry {

        BikeEntry(date: Date(), bike: nil, mapImage: nil)
    }

    func getSnapshot(in context: Context, completion: @escaping (BikeEntry) -> Void) {
        let bike = BikeHistory(name: "My Bike", location: location, time: Date(), isActived: true)

        let mapSnapshotter = makeMapSnapshotter(location: bike.location, size: context.displaySize)
        mapSnapshotter.start {
            (snapshot, err) in
            if let snapshot = snapshot {
                let image = makeMapImage(bike: bike, snapshot: snapshot, size: context.displaySize)
                let entry = BikeEntry(date: Date(), bike: bike, mapImage: image)
                completion(entry)
            }
        }


    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<BikeEntry>) -> Void) {
        let bikeModel = BikeModel(shouldLoad: false)
        let bike = bikeModel.getLatestBike()
        if let bike = bike {
            let mapSnapshotter = makeMapSnapshotter(location: bike.location, size: context.displaySize)
            mapSnapshotter.start {
                (snapshot, err) in
                if let snapshot = snapshot {
                    let image = makeMapImage(bike: bike, snapshot: snapshot, size: context.displaySize)
                    let entry = BikeEntry(date: Date(), bike: bike, mapImage: image)
                    let timeline = Timeline(entries: [entry], policy: .atEnd)
                    completion(timeline)

                }
            }

        } else {
            let entry = BikeEntry(date: Date(), bike: nil, mapImage: nil)
            let timeline = Timeline(entries: [entry], policy: .atEnd)
            completion(timeline)
        }

    }

    typealias Entry = BikeEntry





}

struct BikeEntry: TimelineEntry {
    let date: Date
    let bike: BikeHistory?
    let mapImage: UIImage?
}



struct WidgetEntryView: View {
    let entry: Provider.Entry

    var body: some View {
        if entry.bike != nil && entry.mapImage != nil {
            Image(uiImage: entry.mapImage!)
//            Text("OK")
        } else {
            Text("No Bike Data")
        }

    }


}


struct WidgetEntryPlaceholderView: View {
    let entry: Provider.Entry

    var body: some View {
        Text("Loading...")
    }
}


@main
struct BikeWidget: Widget {
    private let kind = "bike_widget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) {
            entry in
            WidgetEntryView(entry: entry)
        }
            .configurationDisplayName("Bike Position Widget")
            .description("A widget shows your bike position")
    }
}

//struct bike_widget_Previews: PreviewProvider {
//    static var previews: some View {
//        bike_widgetEntryView(entry: BikeEntry(date: Date(), configuration: ConfigurationIntent()))
//            .previewContext(WidgetPreviewContext(family: .systemSmall))
//    }
//}
