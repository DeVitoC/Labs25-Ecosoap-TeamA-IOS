//
//  PickupListItem.swift
//  EcoSoapBank
//
//  Created by Jon Bash on 2020-08-07.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import SwiftUI
import UIKit

// MARK: - Cell

struct PickupHistoryCell: View {
    let pickup: Pickup

    @State var titleColumnWidth: CGFloat?

    init(pickup: Pickup) {
        self.pickup = pickup
    }

    var body: some View {
        NavigationLink(
            destination: PickupDetailViewController.Representable(pickup: pickup)
        ) {
            VStack(alignment: .leading, spacing: 22) {
                HStack(alignment: .center) {

                    // Confirmation Code
                    Text(pickup.confirmationCode)
                        .font(UIFont.muli(style: .title2, typeface: .bold))
                        .foregroundColor(Color(.montanaGrey))
                    Spacer()

                    HStack {
                        // Date
                        VStack(alignment: .trailing) {
                            Text("READY DATE")
                                .font(UIFont.muli(style: UIFont.TextStyle.caption2, typeface: .regular))
                                .foregroundColor(Color(.systemGray))
                            Text(pickup.readyDate.string())
                                .font(UIFont.muli(style: .body, typeface: .regular))
                        }

                        // Disclosure
//                        Image(systemName: "chevron.right")
//                            .font(.systemFont(ofSize: 20, weight: .semibold))
//                            .foregroundColor(Color(.silver))
//                            .padding(.leading, 10)
                    }
                }

                HStack {
                    // Pickup Status
                    HStack {
                        StatusIcon(status: pickup.status)
                            .modifier(Icon())
                        Text(pickup.status.display)
                            .font(UIFont.muli(style: UIFont.TextStyle.body, typeface: .semiBold))
                    }.frame(width: 140, alignment: .leading)

                    // Cartons
                    Image(systemName: "square.stack.3d.up.fill")
                        .modifier(Icon())
                        .foregroundColor(Color(.downyBlue))
                    Text("\(pickup.cartons.count) Cartons")
                        .font(UIFont.muli(style: UIFont.TextStyle.body, typeface: .semiBold))

                    Spacer()
                }
            }
        }
        .font(Font(UIFont.muli(style: .body)))
        .foregroundColor(Color(.shuttleGrey))
        .listRowBackground(Color(UIColor.systemGroupedBackground.withAlphaComponent(0.5)))
    }
}

extension PickupHistoryCell {
    private struct Icon: ViewModifier {
        func body(content: Content) -> some View {
            content
                .font(.systemFont(ofSize: 26, weight: .medium))
                .frame(width: 30, alignment: .leading)
        }
    }
    
    private struct StatusIcon: View {
        private let imageName: String
        private let color: Color
        
        init(status: Pickup.Status) {
            switch status {
            case .cancelled:
                imageName = "clear.fill"
                color = Color(.systemRed)
            case .complete:
                imageName = "checkmark.circle.fill"
                color = Color(.esbGreen)
            case .outForPickup:
                imageName = "tray.and.arrow.up.fill"
                color = Color(.systemOrange)
            case .submitted:
                imageName = "paperplane.fill"
                color = Color(.systemBlue)
            }
        }
        
        var body: some View {
            Image(systemName: imageName)
                .foregroundColor(color)
        }
    }
}

// MARK: - Previews

struct PickupListItem_Previews: PreviewProvider {
    static var previews: some View {
        PickupHistoryCell(pickup: .random())
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
