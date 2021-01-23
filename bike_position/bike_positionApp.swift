//
//  bike_positionApp.swift
//  bike_position
//
//  Created by 李其炜 on 1/23/21.
//

import SwiftUI

@main
struct bike_positionApp: App {

    @StateObject var bikeModel: BikeModel = BikeModel()
    @StateObject var locationModel: LocationManager = LocationManager()

    var body: some Scene {
        WindowGroup {
            HomeScreen()
                .environmentObject(bikeModel)
                .environmentObject(locationModel)
        }
    }
}
