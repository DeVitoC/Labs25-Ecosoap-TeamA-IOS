//
//  CartonSummaryView.swift
//  EcoSoapBank
//
//  Created by Jon Bash on 2020-08-11.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import SwiftUI


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
