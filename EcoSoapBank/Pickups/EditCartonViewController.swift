//
//  EditCartonViewController.swift
//  EcoSoapBank
//
//  Created by Jon Bash on 2020-08-21.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit


class EditCartonViewController: UIViewController {
    private lazy var productPickerView = configure(UIPickerView()) {
        $0.dataSource = self
        $0.delegate = self
    }

    private var viewModel: NewCartonViewModel

    // MARK: - Init / Lifecycle

    init(viewModel: NewCartonViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable, message: "Use init(viewModel:delegate:)")
    required init?(coder: NSCoder) {
        fatalError("`init(coder:)` not implemented. Use `init(viewModel:delegate:)`.")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        view.constrainNewSubviewToSides(productPickerView)
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: productPickerView.intrinsicContentSize.width),
            view.heightAnchor.constraint(equalToConstant: productPickerView.intrinsicContentSize.height)
        ])
        productPickerView.selectRow(
            HospitalityService.allCases.firstIndex(of: viewModel.carton.product)!,
            inComponent: 0,
            animated: false)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
}

// MARK: - Delegate / Data Source

extension EditCartonViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        viewModel.carton.product = HospitalityService.allCases[row]
    }

    func pickerView(
        _ pickerView: UIPickerView,
        titleForRow row: Int,
        forComponent component: Int
    ) -> String? {
        HospitalityService.allCases[row].rawValue.capitalized
    }
}

extension EditCartonViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }

    func pickerView(
        _ pickerView: UIPickerView,
        numberOfRowsInComponent component: Int
    ) -> Int {
        HospitalityService.allCases.count
    }
}
