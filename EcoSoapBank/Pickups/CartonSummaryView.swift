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
    @ObservedObject private var viewModel: CartonViewModel

    init(viewModel: CartonViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        HStack {
            Text(viewModel.product.rawValue.capitalized)
            Text("\(viewModel.quantity)g")
        }.onTapGesture {
            self.viewModel.editing = true
        }.sheet(isPresented: $viewModel.editing) {
            EditCartonView(viewModel: self.viewModel)
        }
    }
}


struct EditCartonView: View {
    @ObservedObject private var viewModel: CartonViewModel

    init(viewModel: CartonViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        Form {
            TextField(
                "Quantity",
                value: $viewModel.quantity,
                formatter: NumberFormatter.forMeasurements)

            Picker(selection: $viewModel.product, label: Text(viewModel.product.rawValue.capitalized)) {
                ForEach(HospitalityService.allCases) {
                    Text("\($0.rawValue.capitalized)")
                }
            }
            .pickerStyle(WheelPickerStyle())
            .id(viewModel.id)
        }
    }
}


// MARK: - Previews

struct CartonSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        CartonSummaryView(viewModel: CartonViewModel(
            product: .bottles,
            quantity: 30))
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
