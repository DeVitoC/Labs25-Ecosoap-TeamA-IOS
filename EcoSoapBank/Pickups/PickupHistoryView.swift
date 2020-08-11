//
//  PickupHistoryView.swift
//  EcoSoapBank
//
//  Created by Jon Bash on 2020-08-07.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import SwiftUI

struct PickupHistoryView: View {
    @ObservedObject var pickupController: PickupController

    var body: some View {
        List {
            ForEach(pickupController.pickups) {
                PickupListItem(pickup: $0)
            }
        }.navigationBarTitle("Pickup History", displayMode: .inline)
    }
}


// MARK: - Previews

struct PickupHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        PickupHistoryView(
            pickupController: .init(dataProvider: MockPickupProvider()))
    }
}
