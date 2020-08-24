//
//  CursorlessTextField.swift
//  EcoSoapBank
//
//  Created by Jon Bash on 2020-08-24.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit


class CursorlessTextField: UITextField {
    override func caretRect(for position: UITextPosition) -> CGRect { .zero }
}
