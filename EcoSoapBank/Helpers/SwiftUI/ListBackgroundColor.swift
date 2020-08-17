//
//  ListBackgroundColor.swift
//  EcoSoapBank
//
//  Created by Jon Bash on 2020-08-14.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import SwiftUI


struct ListBackgroundColor: ViewModifier {

    let color: UIColor
    let withTransparentCells: Bool

    init(color: UIColor, withTransparentCells: Bool = false) {
        self.color = color
        self.withTransparentCells = withTransparentCells
    }

    func body(content: Content) -> some View {
        content
            .onAppear {
                UITableView.appearance().backgroundColor = self.color
                if self.withTransparentCells {
                    UITableViewCell.appearance().backgroundColor = self.color
                }
        }
    }
}

extension View {
    func listBackgroundColor(color: UIColor) -> some View {
        ModifiedContent(content: self, modifier: ListBackgroundColor(color: color))
    }

}
