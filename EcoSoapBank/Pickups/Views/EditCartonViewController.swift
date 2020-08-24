//
//  EditCartonViewController.swift
//  EcoSoapBank
//
//  Created by Jon Bash on 2020-08-21.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit


class EditCartonViewController: UIViewController {
    private var viewModel: NewCartonViewModel

    // MARK: - Subviews

    private lazy var productPickerView = configure(UIPickerView()) {
        $0.dataSource = self
        $0.delegate = self
        $0.selectRow(
            HospitalityService.displayOptions
                .firstIndex(of: viewModel.carton.product)!,
            inComponent: 0,
            animated: false)
    }
    private lazy var percentageSlider = configure(SteppedSlider()) {
        $0.minimumValue = 0
        $0.maximumValue = 100
        $0.minimumValueImage = .cubeBox
        $0.maximumValueImage = .cubeBoxFill
        $0.stepSize = 5
        $0.value = Float(viewModel.carton.percentFull)
        $0.onValueChange = { [unowned self] newValue in
            self.sliderValueDidChange(newValue)
        }
    }

    // MARK: - Init / Lifecycle

    init(viewModel: NewCartonViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable, message: "Use init(viewModel:)")
    required init?(coder: NSCoder) {
        fatalError("`init(coder:)` not implemented. Use `init(viewModel:)`.")
    }

    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // constrain views
        view.constrainNewSubviewToSafeArea(productPickerView,
                                           sides: [.top, .leading, .trailing])
        view.constrainNewSubviewToSafeArea(percentageSlider,
                                           sides: [.leading, .trailing, .bottom],
                                           constant: 20)
        NSLayoutConstraint.activate([
            percentageSlider.topAnchor.constraint(
                greaterThanOrEqualTo: productPickerView.bottomAnchor,
                constant: 8),
            percentageSlider.topAnchor.constraint(
                lessThanOrEqualTo: productPickerView.bottomAnchor,
                constant: 20),
        ])

    }
}

// MARK: - Private Helpers

extension EditCartonViewController {
    private func percentString(from number: Float) -> String {
        NumberFormatter.forPercentage
            .string(from: NSNumber(value: number * 0.01))!
    }

    private func sliderValueDidChange(_ newValue: Float) {
        viewModel.carton.percentFull = Int(newValue)
    }
}

// MARK: - Delegate / Data Source

extension EditCartonViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        viewModel.carton.product = HospitalityService.displayOptions[row]
    }
}

extension EditCartonViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }

    func pickerView(
        _ pickerView: UIPickerView,
        numberOfRowsInComponent component: Int
    ) -> Int {
        HospitalityService.displayOptions.count
    }

    func pickerView(
        _ pickerView: UIPickerView,
        titleForRow row: Int,
        forComponent component: Int
    ) -> String? {
        HospitalityService.displayOptions[row].rawValue.capitalized
    }
}
