//
//  BikeViewModel.swift
//  bike_position
//
//  Created by 李其炜 on 1/22/21.
//

import Foundation
import RealmSwift
import CoreLocation
import WidgetKit
import SwiftUI

extension Results {
    func toArray() -> [Element] {
        return compactMap {
            $0
        }
    }
}



class BikeModel: ObservableObject {
    let realm: Realm?
    var token: NotificationToken?
    private var bikesDB: [BikeHistoryDB] = []

    @Published var bikes: [BikeHistory] = []
    @Published var selectedIndex: Int = 0 {
        didSet {
            fetchBikes()
        }
    }

    init(shouldLoad: Bool = true) {
        let fileURL = FileManager.default
            .containerURL(forSecurityApplicationGroupIdentifier: "group.sirilee.bike-position")!
            .appendingPathComponent("default.realm")
        let config = Realm.Configuration(fileURL: fileURL)
        self.realm = try! Realm(configuration: config)
        if shouldLoad {
            self.fetchBikes()
            if let realm = self.realm {
                token = realm.objects(BikeHistoryDB.self).observe {
                    (changeset: RealmCollectionChange) in
                    switch changeset {
                    case .update(let bks, let deletetions, let insertions, let mofidications):
                        //                    print("\(bks), \(deletetions), \(insertions), \(mofidications)")
                        self.fetchBikes()
                        WidgetCenter.shared.reloadTimelines(ofKind: "bike_widget")
                    case .initial(_):
                        print("Init")
                    case .error(_):
                        print("Error")
                    }

                }
            }
        }
    }

    func getLatestBike() -> BikeHistory? {
        let result = realm?.objects(BikeHistoryDB.self).filter("isActived = true").first
        if let result = result {
            return BikeHistory(bike: result)
        }
        return nil
    }

    func fetchBikes() {
        withAnimation {
            if(selectedIndex == 0) {
                fetchAllActiveBikes()
            } else {
                fetchFrozenBikes()
            }
        }

    }


    private func fetchAllActiveBikes() {
        print("fetch 1")
        let results = realm?.objects(BikeHistoryDB.self).filter("isActived = true").sorted(byKeyPath: "time")

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
        let results = realm?.objects(BikeHistoryDB.self).filter("isActived = false").sorted(byKeyPath: "time")
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
//            bikesDB.remove(at: index)

        }

    }

    func updateBike(bikeId: String, name: String?, isActived: Bool?) {

        try! realm?.write {
            let bikeDB = realm?.objects(BikeHistoryDB.self).filter("id = '\(bikeId)'").first

            if let bikeDB = bikeDB {

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




