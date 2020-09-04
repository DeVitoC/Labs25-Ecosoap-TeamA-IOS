//
//  InverseMask.swift
//  EcoSoapBank
//
//  Created by Jon Bash on 2020-09-03.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import SwiftUI


extension View {
    func inverseMask<Mask>(_ mask: Mask) -> some View where Mask: View {
        self.mask(mask
            .foregroundColor(.black)
            .background(Color.white)
            .compositingGroup()
            .luminanceToAlpha()
        )
    }
}
