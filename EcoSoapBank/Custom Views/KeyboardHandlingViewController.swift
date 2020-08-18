//
//  KeyboardHandlingViewController.swift
//  Catfish
//
//  Created by Shawn Gee on 4/4/20.
//  Copyright © 2020 James Pacheco. All rights reserved.
//

import UIKit
import Combine


/// A view controller that expands to fit content vertically
/// and responds to keyboard showing in order to not obscure text inputs.
///
/// Add all of your subviews to contentView. If your content should extend beyond the size of the scrollview,
/// be sure to fully define the contentView's height through use of constraints.
/// This view controller also adds an inputAccessoryView to each textField or textView in the content view.
/// This facilitates easy navigation between text inputs.

class KeyboardHandlingViewController: UIViewController {

    // MARK: - Public

    let contentView = UIView()
    let scrollView = UIScrollView()

    private var cancellables: Set<AnyCancellable> = []

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    // MARK: - Private

    private func configure() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),

            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),

            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])

        let weakHeightConstraint = contentView.heightAnchor.constraint(equalTo: scrollView.frameLayoutGuide.heightAnchor)
        weakHeightConstraint.priority = .defaultLow
        weakHeightConstraint.isActive = true

        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.keyboardDismissMode = .interactive

        setupKeyboardNotifications()
    }

    // MARK: - Keyboard Handling

    private func setupKeyboardNotifications() {
        NotificationCenter.default
            .publisher(for: UIResponder.keyboardWillShowNotification)
            .merge(with: NotificationCenter.default
                .publisher(for: UIResponder.keyboardWillHideNotification))
            .sink(receiveValue: moveForKeyboard(notification:))
            .store(in: &cancellables)
    }

    private func moveForKeyboard(notification: Notification) {
        let key = UIResponder.keyboardFrameEndUserInfoKey
        if let info = notification.userInfo,
            let keyboardFrame = info[key] as? CGRect {
            scrollView.contentInset = UIEdgeInsets(
                top: 0,
                left: 0,
                bottom: keyboardFrame.height,
                right: 0)
        }
    }
}

extension KeyboardHandlingViewController: UITextViewDelegate, UITextFieldDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        DispatchQueue.main.async { [weak scrollView] in
            scrollView?.scrollRectToVisible(textView.frame, animated: true)
        }
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        DispatchQueue.main.async { [weak scrollView] in
            scrollView?.scrollRectToVisible(textField.frame, animated: true)
        }
    }
}
