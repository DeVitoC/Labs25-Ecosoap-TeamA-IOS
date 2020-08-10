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
        }
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
