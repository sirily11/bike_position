//
//  bike.swift
//  bike_position
//
//  Created by 李其炜 on 1/22/21.
//

import Foundation
import RealmSwift
import CoreLocation


class BikeHistoryDB: Object {
    @objc dynamic var id = ""
    @objc dynamic var name: String = "My Bike"
    @objc dynamic var lat: Double = 0.0
    @objc dynamic var lon: Double = 0.0
    @objc dynamic var isActived: Bool = false
    @objc dynamic var time: Date = Date()

    override static func primaryKey() -> String? {
        "id"
    }

}

struct BikeHistory: Identifiable {
    var id = UUID().uuidString
    var name: String
    var location: CLLocation
    var time: Date
    var isActived: Bool



    func toDB() -> BikeHistoryDB {
        let bike = BikeHistoryDB(value: ["id": id, "name": name, "lat": location.coordinate.latitude, "lon": location.coordinate.longitude,
                                         "time": time, "isActived": isActived])

        return bike
    }
}

extension BikeHistory {
    init(bike: BikeHistoryDB) {
        id = bike.id
        name = bike.name
        time = bike.time
        isActived = bike.isActived
        location = CLLocation(latitude: bike.lat, longitude: bike.lon)
    }
}

struct UserPosition {
    var lat: Float
    var lon: Float


    func getDistance(lat: Float, lon: Float) -> Float {
        return 0
    }
}


let bikesData = [BikeHistory(name: "My bike", location: CLLocation(latitude: 22.396427, longitude: 114.109497), time: Date(), isActived: true), BikeHistory(name: "My bike", location: CLLocation(latitude: 22.396427, longitude: 114.109497), time: Date(), isActived: true), BikeHistory(name: "My bike", location: CLLocation(latitude: 22.396427, longitude: 114.109497), time: Date(), isActived: true)]
let userPosition = CLLocation(latitude: 22.2833, longitude: 114.1500)
