//
//  SteppedSlider.swift
//  EcoSoapBank
//
//  Created by Jon Bash on 2020-08-21.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit


class SteppedSlider: UISlider {
    var stepSize: Float = 1

    var onValueChange: ((Float) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }

    private func setUp() {
        addTarget(self,
                  action: #selector(sliderValueDidChange(sender:)),
                  for: .valueChanged)
    }

    @objc private func sliderValueDidChange(sender: UISlider) {
        let roundedValue = (sender.value / stepSize).rounded() * stepSize
        setValue(roundedValue, animated: false)
        onValueChange?(roundedValue)
    }
}
