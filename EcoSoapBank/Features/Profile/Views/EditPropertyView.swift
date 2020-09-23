//
//  EditPropertyView.swift
//  EcoSoapBank
//
//  Created by Jon Bash on 2020-08-31.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import SwiftUI


struct EditPropertyState {
    var propertyInfo: EditablePropertyInfo

}


struct EditPropertyView: View {
    @EnvironmentObject var viewModel: ProfileViewModel

    @State var propertyInfo: EditablePropertyInfo

    @Environment(\.presentationMode) var presentationMode
    @State var labelWidth: CGFloat?

    init(_ property: Property) {
        self._propertyInfo = State(initialValue: EditablePropertyInfo(property))
    }

    var body: some View {
        Form {
            Section {
                TextField("Name", text: $propertyInfo.name)
                Picker("Property Type", selection: $propertyInfo.propertyType) {
                    ForEach(Property.PropertyType.allCases) {
                        Text($0.display)
                            .tag($0)
                    }
                }
                TextField("Phone", text: $propertyInfo.phone)
            }

            Section(header: Text("Shipping Address".uppercased())) {
                addressSectionContent($propertyInfo.shippingAddress)
            }

            Toggle(isOn: $viewModel.useShippingAddressForBilling) {
                Text("Use shipping address for billing")
            }

            if !viewModel.useShippingAddressForBilling {
                Section(header: Text("Billing Address".uppercased())) {
                    addressSectionContent($propertyInfo.billingAddress)
                }
            }
        }
        .keyboardAvoiding()
        .navigationBarTitle("Update Property", displayMode: .automatic)
        .navigationBarItems(trailing:
            Button(action: saveChanges, label: { Text("Save") })
                .foregroundColor(.barButtonTintColor)
        )
    }

    func saveChanges() {
        self.viewModel.savePropertyChanges(self.propertyInfo) {
            self.presentationMode.wrappedValue.dismiss()
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
    static let user = User.placeholder()
    static let property = user.properties!.first!

    static var previews: some View {
        NavigationView {
            EditPropertyView(property).environmentObject(ProfileViewModel(
                user: user,
                userController: UserController(dataLoader: MockUserDataProvider()),
                delegate: nil))
        }
    }
}
