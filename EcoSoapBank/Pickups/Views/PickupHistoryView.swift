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

    @State private var makingNewPickup = false
    @State private var statusWidth: CGFloat?

    private var schedulePickup: () -> Void

    init(pickupController: PickupController, schedulePickup: @escaping () -> Void) {
        self.pickupController = pickupController
        self.schedulePickup = schedulePickup
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(pickupController.pickups) {
                    PickupHistoryCell(pickup: $0, statusWidth: self.$statusWidth)
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("Pickup History", displayMode: .automatic)
            .navigationBarItems(trailing: Button(
                action: schedulePickup,
                label: newPickupButton))
        }
    }

    private func newPickupButton() -> some View {
        Image(uiImage: .addBoxSymbol)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(height: 28)
            .accessibility(label: Text("Schedule New Pickup"))
    }

    private func gradientBackground() -> some View {
        LinearGradient(
            gradient: Gradient(colors: [Color(.esbGreen), Color(.downyBlue)]),
            startPoint: .top,
            endPoint: .bottom)
            .frame(
                width: UIScreen.main.bounds.width,
                height: UIScreen.main.bounds.height + 160)
    }
}

// MARK: - Previews

struct PickupHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        PickupHistoryView(
            pickupController: PickupController(
                user: .placeholder(),
                dataProvider: MockPickupProvider()),
            schedulePickup: {})
    }
}
