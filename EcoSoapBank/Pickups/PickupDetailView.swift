//
//  PickupDetailView.swift
//  EcoSoapBank
//
//  Created by Jon Bash on 2020-08-17.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import SwiftUI


struct PickupDetailView: View {
    let pickup: Pickup

    var body: some View {
        ZStack {
            Color(.esbGreen)
                .edgesIgnoringSafeArea(.all)
            Color(.systemGroupedBackground)
                .edgesIgnoringSafeArea([.leading, .trailing])
            VStack {
                Text("Placeholder")
                pickup.cartons
                    .compactMap { $0.display }
                    .uiText(separatedBy: ", ")
            }
        }
        .navigationBarTitle("Pickup Details")
    }
}
