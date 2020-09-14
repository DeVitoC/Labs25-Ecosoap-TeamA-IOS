//
//  LoadingViewController.swift
//  EcoSoapBank
//
//  Created by Jon Bash on 2020-08-27.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//
// swiftlint:disable force_cast

import UIKit


/// Shows a loading indicator and optional text. Presented full screen over another view.
///
/// If subclasses or adding subviews, you must use `contentView` rather than view, as the root `view`
/// is a `UIVisualEffectView`; adding subviews to this will cause a crash.
public class LoadingViewController: UIViewController {
    public var loadingText: String? {
        get { loadingLabel.text }
        set { loadingLabel.text = newValue }
    }

    public var loadingColor: UIColor {
        get { loadingIndicator.color }
        set { loadingIndicator.color = newValue }
    }

    public var contentView: UIView! {
        (view as! UIVisualEffectView).contentView
    }

    public let loadingIndicator = UIActivityIndicatorView(style: .large)
    public let loadingLabel = configure(UILabel()) {
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.font = .montserratScaled(ofSize: 36, style: .title2, typeface: .bold)
    }

    private var blurEffect: UIBlurEffect = UIBlurEffect(style: .systemUltraThinMaterial)

    // MARK: - Init

    public convenience init(loadingText: String? = nil) {
        self.init(nibName: nil, bundle: nil)
        self.loadingText = loadingText
    }

    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        commonInit()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
        loadingIndicator.color = .esbGreen
    }

    // MARK: - View Lifecycle

    override public func loadView() {
        view = UIVisualEffectView(effect: blurEffect)
        view.backgroundColor = .clear
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        contentView.constrainNewSubviewToCenter(loadingIndicator)
        contentView.constrainNewSubview(loadingLabel, to: [.leading, .trailing])
        NSLayoutConstraint.activate([
            loadingIndicator.topAnchor.constraint(equalTo: loadingLabel.bottomAnchor, constant: 20),
            loadingLabel.topAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor, constant: 20)
        ])
    }

    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        loadingIndicator.startAnimating()
    }

    override public func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        loadingIndicator.stopAnimating()
    }
}
