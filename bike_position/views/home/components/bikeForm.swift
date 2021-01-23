//
//  bikeForm.swift
//  bike_position
//
//  Created by 李其炜 on 1/22/21.
//

import SwiftUI
import MapKit

struct BikeForm: View {
    @Binding var show: ActiveSheet?
    @State var name: String = ""
    @EnvironmentObject var bikeModel: BikeModel
    @EnvironmentObject var locationModel: LocationManager
    @State var tracking: MapUserTrackingMode = .follow
    @State private var showingAlert = false
    @State var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
    let dateFormatterGet = DateFormatter()

    init(show: Binding<ActiveSheet?>) {
        self._show = show
        dateFormatterGet.dateFormat = "yyyy-MM-dd"
    }

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Value")) {
                        TextField("Name", text: $name)
                    }

                    if(locationModel.lastLocation != nil) {
                        Section(header: Text("Data")) {
                            Map(coordinateRegion: $region, interactionModes: .all, showsUserLocation: true, userTrackingMode: $tracking)
                                .frame(height: 400)
                            HStack {
                                Text("Time")
                                Spacer()
                                Text("\(dateFormatterGet.string(from: Date()))")
                            }
                        }
                    } else {
                        Text("Position not avaliable")
                    }


                }
                if(locationModel.lastLocation != nil) {
                    Button(action: {
                        if(name.isEmpty) {
                            showingAlert = true
                        }
                       
                        if let location = locationModel.lastLocation {

                            bikeModel.addBike(bike: BikeHistory(name: name, location: location, time: Date(), isActived: true))
                            show = nil
                        }

                    }) {
                        HStack {
                            Text("Submit")
                                .fontWeight(.semibold)
                        }
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .padding()
                            .foregroundColor(.white)
                            .background(Color(UIColor.systemBlue))
                            .cornerRadius(10)
                    }

                }

            }
                .navigationBarTitle("Add Bike", displayMode: .inline)
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        Button("Cancel") {
                            show = nil
                        }
                    }

            }
        }

            .onAppear {
                if let cord = locationModel.lastLocation?.coordinate {
                    region = MKCoordinateRegion(center: cord, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
                }
        }

    }

}

struct PreviewWrapper: View {
    @State var show: ActiveSheet?

    var body: some View {
        BikeForm(show: $show)
    }
}

struct bikeForm_Previews: PreviewProvider {

    static var previews: some View {

        PreviewWrapper()
            .environmentObject(BikeModel())
            .environmentObject(LocationManager())
    }
}
