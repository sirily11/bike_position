//
//  BikeRow.swift
//  bike_position
//
//  Created by 李其炜 on 1/22/21.
//

import SwiftUI
import CoreLocation

struct BikeRow: View {
    let dateFormatterGet = DateFormatter()
    let bike: BikeHistory
    let userPosition: CLLocation?

    init(bike: BikeHistory, userPosition: CLLocation?) {
        dateFormatterGet.dateFormat = "yyyy-MM-dd"
        self.bike = bike
        self.userPosition = userPosition
    }


    var body: some View {
        NavigationLink(
            destination: DetailPage(bike: bike))
        {
            HStack {
                Image(systemName: "location.circle.fill")
                    .font(.system(size: 56.0, weight: .bold))
                    .foregroundColor(Color(bike.isActived ? UIColor.systemBlue : UIColor.systemGray))
                VStack(alignment: .leading) {
                    Text("\(bike.name)")
                        .bold()
                    Text("\(dateFormatterGet.string(from: bike.time))")
                }
                Spacer()
                if(userPosition != nil) {
                    Text("\(Int(userPosition!.distance(from: bike.location)))m")
                } else {
                    Text("Unknown")
                }


            }
                .padding()
        }

    }
}

struct BikeRow_Previews: PreviewProvider {
    static var previews: some View {
        BikeRow(bike: bikesData[0], userPosition: userPosition)
    }
}
