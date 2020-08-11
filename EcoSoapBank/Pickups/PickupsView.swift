//
//  PickupsView.swift
//  EcoSoapBank
//
//  Created by Jon Bash on 2020-08-10.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import SwiftUI


protocol PickupsViewDelegate: AnyObject {
    func logOut()
}


struct PickupsView: View {
    @ObservedObject private var pickupController: PickupController

    @State private var makingNewPickup = false

    private weak var delegate: PickupsViewDelegate?

    init(
        pickupController: PickupController,
        delegate: PickupsViewDelegate?
    ) {
        self.pickupController = pickupController
        self.delegate = delegate
    }

    var body: some View {
        NavigationView {
            PickupHistoryView(pickupController: pickupController)
                .navigationBarTitle("Pickup History", displayMode: .inline)
                .navigationBarItems(
                    leading: Button(
                        action: { self.delegate?.logOut() },
                        label: { Text("Log out") }),
                    trailing: Button(
                        action: { self.makingNewPickup = true },
                        label: newPickupButtonLabel
                    )
                )
        }
    }

    private func newPickupButtonLabel() -> some View {
        HStack(spacing: 4) {
            Image.plus()
            Image.cubeBox()
        }.padding(4).overlay(RoundedRectangle(cornerRadius: 10).stroke())
        .accessibility(label: Text("Schedule New Pickup"))
    }
}

struct PickupsView_Previews: PreviewProvider {
    static var previews: some View {
        PickupsView(
            pickupController: PickupController(
                dataProvider: MockPickupProvider()),
            delegate: nil)
    }
}
