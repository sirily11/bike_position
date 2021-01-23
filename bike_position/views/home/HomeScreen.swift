//
//  HomeScreen.swift
//  bike_position
//
//  Created by 李其炜 on 1/22/21.
//

import SwiftUI


enum ActiveSheet: Identifiable {
    case first, second

    var id: Int {
        hashValue
    }
}

struct HomeScreen: View {
    @EnvironmentObject var bikeModel: BikeModel
    @EnvironmentObject var locationModel: LocationManager


    @State var activeSheet: ActiveSheet?

    var body: some View {
        NavigationView {
            VStack {
                Picker(selection: $bikeModel.selectedIndex, label: Text("Select"), content: {
                    Text("Acvtived").tag(0)
                    Text("Not Actived").tag(1)
                })
                    .pickerStyle(SegmentedPickerStyle())

                BikeList(bikes: bikeModel.bikes)
            }
                .navigationBarTitle("Home", displayMode: .inline)
                .toolbar {
                    Button("Add") {
                        activeSheet = .first
                    }
                }
                .sheet(item: $activeSheet) {
                    item in
                    BikeForm(show: $activeSheet)
                        .environmentObject(bikeModel)
                        .environmentObject(locationModel)
            }
        }
            .onAppear {
                bikeModel.fetchBikes()
        }
    }

}


struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
            .environmentObject(BikeModel())
            .environmentObject(LocationManager())
    }
}
