//
//  EditPropertyView.swift
//  EcoSoapBank
//
//  Created by Jon Bash on 2020-08-31.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import SwiftUI


struct EditPropertyView: View {
    @ObservedObject var viewModel: EditPropertyViewModel

    @State var labelWidth: CGFloat?

    var body: some View {
        Form {
            Section {
                TextField("Name", text: $viewModel.propertyInfo.name)
                Picker("Property Type", selection: $viewModel.propertyInfo.propertyType) {
                    ForEach(viewModel.propertyTypes) {
                        Text($0.display)
                            .tag($0)
                    }
                }
                TextField("Phone", text: $viewModel.propertyInfo.phone)
            }

            Section(header: Text("Shipping Address".uppercased())) {
                addressSectionContent($viewModel.propertyInfo.shippingAddress)
            }

            Toggle(isOn: $viewModel.useShippingAddressForBilling) {
                Text("Use shipping address for billing")
            }

            if !viewModel.useShippingAddressForBilling {
                Section(header: Text("Billing Address".uppercased())) {
                    addressSectionContent($viewModel.propertyInfo.billingAddress)
                }
            }
        }
        .keyboardAvoiding()
        .navigationBarTitle("Update Property", displayMode: .automatic)
        .navigationBarItems(trailing: Button(
            action: viewModel.commitChanges,
            label: { Text("Save") })
            .foregroundColor(.barButtonTintColor)
        ).alert(isPresented: viewModel.didFail) {
            Alert(viewModel.error)
        }
    }

    // MARK: - Subviews

    private func textField(title: String, text: Binding<String>) -> some View {
        LabelAlignedTextField(title: title, labelWidth: $labelWidth, text: text)
    }

    @ViewBuilder
    private func addressSectionContent(_ address: Binding<EditableAddressInfo>) -> some View {
        TextField("Address (line 1)", text: address.address1)
        TextField("Address (line 2)", text: address.address2)
        TextField("Address (line 3)", text: address.address3)
        TextField("City", text: address.city)
        HStack {
            TextField("State", text: address.state)
            Divider().background(Color.secondary)
            TextField("Postal Code", text: address.postalCode)
        }
        TextField("Country", text: address.country)
    }
}

// MARK: - Preview

struct EditPropertyView_Previews: PreviewProvider {
    static let property = User.placeholder().properties!.first!

    static var previews: some View {
        NavigationView {
            EditPropertyView(viewModel: EditPropertyViewModel(
                property,
                isActive: .constant(true),
                userController: UserController(dataLoader: MockUserDataProvider())))
        }
    }
}
