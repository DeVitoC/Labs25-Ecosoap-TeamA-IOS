//
//  PropertyList.swift
//  EcoSoapBank
//
//  Created by Jon Bash on 2020-08-31.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import SwiftUI

/// Currently unused; may be removed entirely.
struct PropertyList: View {
    @ObservedObject var viewModel: PropertyListViewModel

    var body: some View {
        Form {
            Section(header: Text("Edit Property")) {
                ForEach(viewModel.properties) { propertyVM in
                    NavigationLink(
                        destination: EditPropertyView(viewModel: propertyVM)
                    ) {
                        Text(propertyVM.property.name)
                    }
                }
            }
        }.navigationBarTitle(Text("Properties"), displayMode: .inline)
    }
}

struct PropertyList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PropertyList(viewModel: PropertyListViewModel(user: .placeholder()))
        }
    }
}
