//
//  BikeList.swift
//  bike_position
//
//  Created by 李其炜 on 1/22/21.
//

import SwiftUI

struct BikeList: View {
    @EnvironmentObject var bikeModel: BikeModel
    @EnvironmentObject var locationManager: LocationManager
    let bikes: [BikeHistory]

    var body: some View {
        List {
            Section(header: Text("History")) {
                ForEach(bikes) { bike in
                    BikeRow(bike: bike, userPosition: locationManager.lastLocation)

                }
                .onDelete(perform: { indexSet in
                    if let index = indexSet.first{
                        bikeModel.deleteBike(index: index)
                    }
                })
            }
        }
            .listStyle(GroupedListStyle())
    }
}

struct BikeList_Previews: PreviewProvider {
    static var previews: some View {
        BikeList(bikes: bikesData)
    }
}
