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
    @Environment(\.sizeCategory) var sizeCategory
    
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
                        .font(.smallCaption)
                        .foregroundColor(Color(.secondaryLabel))
                    Text(pickup.readyDate.string())
                        .font(.preferredMuli(forTextStyle: .headline))
                }

                HStack {
                    // Pickup Status
                    HStack(spacing: 4) {
                        StatusIcon(status: pickup.status)
                        Text(pickup.status.display)
                            .lineLimit(2)
                            .fixedSize(horizontal: false, vertical: true)
                            .font(UIFont.preferredMuli(forTextStyle: .callout))
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
                            .lineLimit(2)
                            .fixedSize(horizontal: false, vertical: true)
                            .font(UIFont.preferredMuli(forTextStyle: .callout))
                            .foregroundColor(Color(UIColor.codGrey.orInverse()))
                        Spacer()
                    }
                }
            }
            .padding(EdgeInsets(top: 6, leading: 0, bottom: 10, trailing: 0))
        }
        .font(Font(UIFont.preferredMuli(forTextStyle: .body)))
        .listRowBackground(Color(.historyCellBackground))
    }
}

extension PickupHistoryCell {
    private struct Icon: ViewModifier {
        func body(content: Content) -> some View {
            content
                .aspectRatio(contentMode: .fit)
                .font(UIFont.systemFont(ofSize: 24, weight: .medium))
                .frame(width: 28, alignment: .leading)
        }
    }
    
    private struct StatusIcon: View {
        private let image: Image
        private let color: Color
        
        init(status: Pickup.Status) {
            switch status {
            case .cancelled:
                image = Image(systemName: "clear.fill")
                color = Color(.systemRed)
            case .complete:
                image = Image(systemName: "checkmark.circle.fill")
                color = Color(.esbGreen)
            case .outForPickup:
                image = Image(uiImage: UIImage(named: "truck")!.withTintColor(.systemOrange, renderingMode: .alwaysTemplate)).resizable()
                color = Color(.systemOrange)
            case .submitted:
                image = Image(systemName: "paperplane.fill")
                color = Color(.systemBlue)
            }
        }
        
        var body: some View {
            image
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
