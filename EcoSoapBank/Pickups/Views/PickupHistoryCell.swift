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
        NavigationLink(destination:
            PickupDetailViewController.Representable(pickup: pickup)
                .navigationBarTitle("Pickup Details")
        ) {
            ZStack(alignment: .bottomTrailing) {
                HStack(alignment: .bottom) {
                    VStack(alignment: .leading) {
                        TitledView("Ready") {
                            Text(pickup.readyDate.string())
                        }

                        TitledView("Status") {
                            Text("\(pickup.status.display)")
                                .foregroundColor(Color(pickup.status.color))
                            if pickup.pickupDate != nil {
                                Text("(\(pickup.pickupDate!.string()))")
                            }
                        }

                        TitledView("Cartons") {
                            Text("\(pickup.cartons.count)")
                        }
                    }

                    Spacer()
                }
                if !pickup.notes.isEmpty {
                    Image.notes()
                        .foregroundColor(Color(.secondaryLabel))
                }
            }
        }
        .font(Font(UIFont.muli(style: .body)))
    }
}

extension PickupHistoryCell {
    private struct TitledView<Content: View>: View {
        let title: String
        let content: Content

        init(_ title: String, @ViewBuilder _ content: () -> Content) {
            self.title = title
            self.content = content()
        }

        var body: some View {
            HStack {
                Text(title + ":")
                    .bold()
                    .frame(alignment: .trailing)
                content
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
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
