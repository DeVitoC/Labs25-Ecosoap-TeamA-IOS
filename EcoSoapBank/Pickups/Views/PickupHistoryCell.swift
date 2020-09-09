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

    @Binding var statusWidth: CGFloat?

    init(pickup: Pickup, statusWidth: Binding<CGFloat?>) {
        self.pickup = pickup
        self._statusWidth = statusWidth
    }

    var body: some View {
        NavigationLink(
            destination: PickupDetailViewController.Representable(pickup: pickup)
        ) {
            VStack(alignment: .leading, spacing: 16) {
                // Date
                VStack(alignment: .leading) {
                    Text("READY DATE")
                        .font(UIFont.muli(style: .caption2, typeface: .regular))
                        .foregroundColor(Color(.secondaryLabel))
                    Text(pickup.readyDate.string())
                        .font(UIFont.muli(style: .body, typeface: .bold))
                }

                HStack(spacing: 12) {
                    // Pickup Status
                    HStack(spacing: 4) {
                        StatusIcon(status: pickup.status)
                        Text(pickup.status.display)
                            .font(UIFont.muli(style: .callout, typeface: .regular))
                            .foregroundColor(Color(UIColor.codGrey.orInverse()))
                        Spacer()
                    }.readingGeometry(
                        key: StatusWidthKey.self,
                        valuePath: \.size.width,
                        onChange: {
                            if let old = self.statusWidth, let new = $0 {
                                self.statusWidth = max(old, new)
                            } else {
                                self.statusWidth = $0
                            }
                    }).frame(width: statusWidth)

                    // Cartons
                    HStack(spacing: 4) {
                        Image(systemName: "square.stack.3d.up.fill")
                            .modifier(Icon())
                            .foregroundColor(Color(.downyBlue))
                        Text("\(pickup.cartons.count) Cartons")
                            .font(UIFont.muli(style: .callout, typeface: .regular))
                            .foregroundColor(Color(UIColor.codGrey.orInverse()))
                    }.padding(.trailing, 16)
                }
            }.padding(.top, 6)
                .padding(.bottom, 10)
        }
        .font(Font(UIFont.muli(style: .body)))
    }
}

extension PickupHistoryCell {
    private struct Icon: ViewModifier {
        func body(content: Content) -> some View {
            content
                .font(UIFont.systemFont(ofSize: 24, weight: .medium).scaled())
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
                .modifier(Icon())
        }
    }

    struct StatusWidthKey: PreferenceKey {
        static func reduce(value: inout CGFloat?, nextValue: () -> CGFloat?) {
            if let old = value, let new = nextValue() {
                value = max(old, new)
            } else {
                value = nextValue()
            }
        }
    }
}

// MARK: - Previews

struct PickupListItem_Previews: PreviewProvider {
    static var previews: some View {
        PickupHistoryCell(pickup: .random(), statusWidth: .constant(nil))
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
