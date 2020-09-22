//
//  InverseMask.swift
//  EcoSoapBank
//
//  Created by Jon Bash on 2020-09-03.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import SwiftUI


extension View {
    /// Masks this view using the alpha channel of the given view. Inverse of regular mask.
    func inverseMask<Mask: View>(_ mask: Mask) -> some View {
        self.mask(mask
            .foregroundColor(.black)
            .background(Color.white)
            .compositingGroup()
            .luminanceToAlpha()
        )
    }
}
