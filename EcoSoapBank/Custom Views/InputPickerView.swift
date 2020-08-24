//
//  InputPickerView.swift
//  EcoSoapBank
//
//  Created by Jon Bash on 2020-08-24.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit


class InputPickerView<DataItem: CustomStringConvertible>:
UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {
    private var data: [DataItem]

    var editingTextField: UITextField?

    var selectedValue: DataItem {
        data[selectedRow(inComponent: 0)]
    }

    init(data: [DataItem]) {
        self.data = data
        super.init(frame: .zero)

        delegate = self
        dataSource = self
        reloadAllComponents()
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backgroundColor = .white
    }

    @available(*, unavailable, message: "Use `init(data:)`")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }

    func pickerView(
        _ pickerView: UIPickerView,
        numberOfRowsInComponent component: Int
    ) -> Int {
        data.count
    }

    func pickerView(
        _ pickerView: UIPickerView,
        titleForRow row: Int,
        forComponent component: Int
    ) -> String? {
        "\(data[row])"
    }
}
