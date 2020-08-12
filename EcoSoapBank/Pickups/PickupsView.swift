//
//  PickupsView.swift
//  EcoSoapBank
//
//  Created by Jon Bash on 2020-08-10.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import SwiftUI


struct PickupsView: View {
    @ObservedObject private var pickupController: PickupController

    @State private var makingNewPickup = false

    init(pickupController: PickupController) {
        self.pickupController = pickupController
    }

    var body: some View {
        NavigationView {
            PickupHistoryView(pickupController: pickupController)
                .navigationBarItems(trailing: newPickupButton())
        }
    }

    private func newPickupButton() -> some View {
        NavigationLink(
            destination: NewPickupView(pickupController: pickupController),
            label: {
                HStack(spacing: 4) {
                    Image.plus()
                    Image.cubeBox()
                }
                .padding(4)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke())
                .accessibility(label: Text("Schedule New Pickup"))
        }).isDetailLink(false)
    }
}

struct PickupsView_Previews: PreviewProvider {
    static var previews: some View {
        PickupsView(pickupController: PickupController(
            dataProvider: MockPickupProvider()))
    }
}
