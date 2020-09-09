//
//  LightStatusBarHostingController.swift
//  EcoSoapBank
//
//  Created by Shawn Gee on 9/8/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import SwiftUI

class DarkStatusBarHostingController<Content>: UIHostingController<Content> where Content: View {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
}
