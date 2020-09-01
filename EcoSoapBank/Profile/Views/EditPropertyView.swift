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
        EmptyView()
    }
}

struct EditPropertyView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EditPropertyView(viewModel: EditPropertyViewModel(.random()))
        }
    }
}
