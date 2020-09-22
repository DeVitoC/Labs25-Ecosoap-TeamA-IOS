//
//  InputPickerView.swift
//  EcoSoapBank
//
//  Created by Jon Bash on 2020-08-24.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit


/// A simple picker view to be used as input for a text field. Acts as its own delegate/data source.
class InputPickerView<DataItem>:
UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {
    var data: [DataItem]
    var rowLabel: KeyPath<DataItem, String>

    var editingTextField: UITextField?

    var selectedValue: DataItem {
        data[selectedRow(inComponent: 0)]
    }
    var onSelect: (DataItem) -> Void

    /// Uses value at keyPath `rowLabel` on each `DataItem`  as the display text for each picker row.
    init(data: [DataItem], rowLabel: KeyPath<DataItem, String>, onSelect: @escaping (DataItem) -> Void) {
        self.data = data
        self.rowLabel = rowLabel
        self.onSelect = onSelect
        super.init(frame: .zero)

        delegate = self
        dataSource = self
        reloadAllComponents()
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
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
        data[row][keyPath: rowLabel]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        onSelect(data[row])
    }
}

extension InputPickerView where DataItem: CustomStringConvertible {
    /// Uses `description` as the text for each `DataItem`'s picker row.
    convenience init(data: [DataItem], onSelect: @escaping (DataItem) -> Void) {
        self.init(data: data, rowLabel: \DataItem.description, onSelect: onSelect)
    }
}
