//
//  PickupListItem.swift
//  EcoSoapBank
//
//  Created by Jon Bash on 2020-08-07.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import SwiftUI


struct PickupHistoryItemView: View {
    let pickup: Pickup

    init(pickup: Pickup) {
        self.pickup = pickup
    }

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(pickup.readyDate.string(from: Self.dateFormatter))
            }

            HStack {
                Text("Status: ") + (Text("\(pickup.status.rawValue.capitalized)")
                    .foregroundColor(pickup.status.color))
                if pickup.pickupDate != nil {
                    Text(pickup.pickupDate!.string(from: Self.dateFormatter))
                }
            }

            pickup.cartons
                .compactMap { $0.display }
                .uiText(separatedBy: ", ")
        }
    }
}

extension PickupHistoryItemView {
    static let dateFormatter = configure(DateFormatter()) {
        $0.dateStyle = .short
        $0.timeStyle = .short
    }
}


// MARK: - Previews

struct PickupListItem_Previews: PreviewProvider {
    static var previews: some View {
        PickupHistoryItemView(pickup: .random())
    }
}
