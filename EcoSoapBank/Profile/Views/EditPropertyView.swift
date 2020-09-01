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

    var body: some View {
        ESBForm(
            title: "Edit Property",
            navItem: Button(
                action: viewModel.commitChanges,
                label: { Text("Save") }),
            sections: [
                .init(title: "test", fields: [
                    .init(title: "testtesttest", text: Binding.constant("bleh"))
                ])
        ])
    }
}

struct EditPropertyView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EditPropertyView(viewModel: EditPropertyViewModel(.random()))
        }
    }
}
