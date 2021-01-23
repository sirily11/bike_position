//
//  BikeViewModel.swift
//  bike_position
//
//  Created by 李其炜 on 1/22/21.
//

import Foundation
import RealmSwift
import CoreLocation

extension Results {
    func toArray() -> [Element] {
        return compactMap {
            $0
        }
    }
}



class BikeModel: ObservableObject {
    let realm: Realm?

    private var bikesDB: [BikeHistoryDB] = []

    @Published var bikes: [BikeHistory] = []
    @Published var selectedIndex: Int = 0 {
        didSet {
            fetchBikes()
        }
    }

    init() {
        self.realm = try! Realm()
    }

    func fetchBikes() {
        if(selectedIndex == 0) {
            fetchAllActiveBikes()
        } else {
            fetchFrozenBikes()
        }
    }


    private func fetchAllActiveBikes() {
        print("fetch 1")
        let results = realm?.objects(BikeHistoryDB.self).filter("isActived = true")

        if let results = results {
            bikesDB = results.toArray()
            bikes = results.map {
                result in
                BikeHistory(bike: result)
            }
        }
    }

    private func fetchFrozenBikes() {
        print("fetch 2")
        let results = realm?.objects(BikeHistoryDB.self).filter("isActived = false")
        if let results = results {
            bikesDB = results.toArray()
            bikes = results.map {
                result in
                BikeHistory(bike: result)
            }
        }

    }

    func addBike(bike: BikeHistory) {
        try! realm?.write {
            let bkdb = bike.toDB()
            realm?.add(bkdb)
            bikes.append(bike)
            bikesDB.append(bkdb)
        }
    }

    func deleteBike(index: Int) {
        try! realm?.write {
            realm?.delete(bikesDB[index])
            bikes.remove(at: index)

            bikesDB.remove(at: index)

        }

    }

    func updateBike(bikeId: String, name: String?, isActived: Bool?) {
        try! realm?.write {
            let index = bikes.firstIndex(where: { bike in bike.id == bikeId })

            if let index = index {
                let bikeDB = bikesDB[index]

                if let name = name {
                    bikeDB.name = name

                }

                if let isActived = isActived {
                    bikeDB.isActived = isActived

                }
            }

        }
    }
}




