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

    var body: some View {
        NavigationView {
            PickupHistoryView(pickupController: pickupController)
        }
    }
}
