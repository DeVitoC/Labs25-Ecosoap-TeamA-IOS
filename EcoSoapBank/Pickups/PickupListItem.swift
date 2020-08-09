//
//  PickupListItem.swift
//  EcoSoapBank
//
//  Created by Jon Bash on 2020-08-07.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import SwiftUI


struct PickupListItem: View {

    static let dateFormatter = configure(DateFormatter()) {
        $0.dateStyle = .short
        $0.timeStyle = .short
    }

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


// MARK: - Model Extensions

extension Pickup.Status {
    var color: Color {
        switch self {
        case .submitted:
            return .blue
        case .outForPickup:
            return .purple
        case .complete:
            return .green
        case .cancelled:
            return .gray
        }
    }
}


extension Pickup.Carton {
    var display: String? {
        guard
            let product = self.product,
            let weight = self.weight
            else { return nil }
        return "\(product.rawValue.capitalized): \(weight)g"
    }
}


// MARK: - Previews

struct PickupListItem_Previews: PreviewProvider {
    static var previews: some View {
        PickupListItem(pickup: Pickup(
            id: 0,
            confirmationCode: "",
            collectionType: .generatedLabel,
            status: .outForPickup,
            readyDate: Date(timeIntervalSinceNow: .days(-5)),
            pickupDate: Date(),
            cartons: [
                .init(id: 0, product: .bottles, weight: 30),
                .init(id: 1, product: .soap, weight: 349)],
            notes: ""))
    }
}
