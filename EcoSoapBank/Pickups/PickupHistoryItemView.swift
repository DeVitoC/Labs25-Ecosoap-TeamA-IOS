//
//  PickupListItem.swift
//  EcoSoapBank
//
//  Created by Jon Bash on 2020-08-07.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import SwiftUI


struct PickupHistoryListItem: View {
    let pickup: Pickup

    init(pickup: Pickup) {
        self.pickup = pickup
    }

    var body: some View {
        NavigationLink(destination: PickupDetailView(pickup: pickup)) {
            VStack(alignment: .leading) {
                HStack {
                    Text("Ready:").bold()
                    Text(pickup.readyDate.string(from: Self.dateFormatter))
                }

                HStack {
                    Text("Status: ").bold()
                    Text("\(pickup.status.display)")
                        .foregroundColor(pickup.status.color)
                    if pickup.pickupDate != nil {
                        Text(pickup.pickupDate!.string(from: Self.dateFormatter))
                    }
                }
            }
        }
    }
}

extension PickupHistoryListItem {
    static let dateFormatter = configure(DateFormatter()) {
        $0.dateStyle = .short
        $0.timeStyle = .short
    }
}


struct PickupDetailView: View {
    let pickup: Pickup

    var body: some View {
        VStack {
            Text("Pickup")
            pickup.cartons
                .compactMap { $0.display }
                .uiText(separatedBy: ", ")
        }
    }
}


// MARK: - Previews

private let _previewPickup = Pickup.random()

struct PickupListItem_Previews: PreviewProvider {
    static var previews: some View {
        PickupHistoryListItem(pickup: _previewPickup)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}

struct PickupDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PickupDetailView(pickup: _previewPickup)
    }
}
