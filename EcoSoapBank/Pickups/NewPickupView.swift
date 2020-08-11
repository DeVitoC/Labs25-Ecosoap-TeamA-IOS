//
//  NewPickupView.swift
//  EcoSoapBank
//
//  Created by Jon Bash on 2020-08-10.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import SwiftUI

struct NewPickupView: View {
    @State private var cartons: [Pickup.CartonContents] = []
    @State private var readyDate: Date = Date()
    @State private var notes: String = ""

    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        Form {
            Section(header: Text("Cartons".uppercased())
                        .font(.caption)
                        .foregroundColor(.black)
            ) {
                ForEach(cartons, content: CartonSummaryView.init)
                    .onDelete(perform: removeCartons(in:))
                Button(action: addAdditionalCarton, label: {
                    HStack {
                        Image.plus()
                        Image.cubeBox()
                        Text("Add carton")
                    }
                })
            }

            Section {
                DatePicker(
                    selection: $readyDate,
                    in: PartialRangeFrom(Date()),
                    displayedComponents: .date,
                    label: {
                        Text("Ready Date".uppercased())
                            .font(.caption)
                    }
                )

                VStack(alignment: .leading) {
                    Text("Notes".uppercased())
                        .font(.caption)
                    TextView(text: $notes, textStyle: .body)
                        .frame(maxWidth: .infinity, idealHeight: 120)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(5)
                }
            }

            Section {
                Button("Submit For Pickup", action: submitPickup)
                    .frame(alignment: .center)
            }
        }.keyboardAvoiding()
    }

    private func addAdditionalCarton() {
        cartons.append(.init(product: .bottles, weight: 0))
    }

    private func submitPickup() {
        presentationMode.wrappedValue.dismiss()
    }

    private func removeCartons(in indexSet: IndexSet) {
        indexSet.forEach { cartons.remove(at: $0) }
    }
}


// MARK: - Single Carton

struct CartonSummaryView: View { // "Cell" for each configured carton
    private var carton: Pickup.CartonContents

    init(_ carton: Pickup.CartonContents) {
        self.carton = carton
    }

    var body: some View {
        HStack {
            Text(carton.product.rawValue.capitalized)
            Text("\(carton.weight)g")
        }
    }
}


// MARK: - Previews

struct CartonSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        CartonSummaryView(.init(product: .bottles, weight: 30))
            .previewLayout(.sizeThatFits)
            .padding()
    }


}

struct NewPickupView_Previews: PreviewProvider {
    static var previews: some View {
        NewPickupView()
    }
}
