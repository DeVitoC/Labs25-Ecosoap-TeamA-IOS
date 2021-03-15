//
//  PropertySelectionController.swift
//  EcoSoapBank
//
//  Created by Shawn Gee on 9/21/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import SwiftUI
import UIKit

/// Embeds the given view controller along with a PropertySelector as child views,
/// with the property selector constrained above the given view controller.
class PropertySelectionController: UIViewController {
    
    // MARK: - Public Properties
    
    let mainViewController: UIViewController
    let propertySelector: PropertySelector
    
    // MARK: - Private Properties
    
    private var propertySelectorHeight: NSLayoutConstraint?
    private let tabWidth: CGFloat = 50
    private let chevron = UIImageView("chevron.down")
    private let separatorColor = UIColor.black.withAlphaComponent(0.6)
    private let separatorWidth: CGFloat = 1.0
    
    private lazy var tabCutout = configure(UIButton()) {
        $0.accessibilityLabel = "Open Property Selector"
        $0.backgroundColor = .codGrey
        $0.layer.cornerRadius = tabWidth / 2
        $0.layer.borderColor = separatorColor.cgColor
        $0.layer.borderWidth = separatorWidth
        
        chevron.tintColor = .downyBlue
        $0.addSubviewsUsingAutolayout(chevron)
        chevron.centerHorizontallyInSuperview()
        chevron.centerVerticallyInSuperview(multiplier: 1.5)
        
        $0.addTarget(self, action: #selector(openPropertySelector), for: .touchUpInside)
    }

    private lazy var separatorLine = configure(UIView()) {
        $0.backgroundColor = separatorColor
    }
    
    private var selectorIsDisabled = false
    
    // MARK: - Init

    @available(*, unavailable, message: "Use init(user:)")
    required init?(coder: NSCoder) {
        fatalError("`init(coder:)` not implemented. Use `init(user:)`.")
    }
    
    /// Initializes and configures the PropertySelectionController for the given View Controller
    /// - Parameters:
    ///   - mainViewController: The main view controller to embed.
    ///   - user: The User whose properties should be displayed in the property selector.
    ///   - shouldPeak: Determines whether the property selector should display initially
    ///   expanded before animating closed.
    init(mainViewController: UIViewController, user: User, shouldPeak: Bool = false) {
        self.mainViewController = mainViewController
        self.propertySelector = PropertySelector(user: user, shouldPeak: shouldPeak)
        if let propertyCount = user.properties?.count, propertyCount < 2 {
            selectorIsDisabled = true
        }
        
        super.init(nibName: nil, bundle: nil)
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if selectorIsDisabled {
            view.addSubviewsUsingAutolayout(mainViewController.view)
            mainViewController.view.fillSuperview(respectingSafeArea: true)
            UIRefreshControl.topPadding = 0 // Remove padding if property selector is disabled
            return
        } else {
            // Make sure padding is set to default otherwise
            UIRefreshControl.topPadding = UIRefreshControl.topPaddingDefault
        }
        
        setUpMainViews()
        setUpCutout()
    }
    
    override func preferredContentSizeDidChange(forChildContentContainer container: UIContentContainer) {
        super.preferredContentSizeDidChange(forChildContentContainer: container)
        
        if container === propertySelector {
            propertySelectorHeight?.constant = container.preferredContentSize.height
            UIView.animate(withDuration: propertySelector.expansionDuration) {
                self.chevron.layer.opacity = self.propertySelector.isExpanded ? 0 : 1.0
                self.tabCutout.isAccessibilityElement = !self.propertySelector.isExpanded
                self.view.layoutIfNeeded()
            }
        }
    }
    
    // MARK: - Private Methods

    /// Method that sets the propertySelector's isExpanded property to true when clicked
    @objc func openPropertySelector() {
        propertySelector.isExpanded = true
    }

    /// Sets up and configures the main View Controller and propertySelector constraints
    private func setUpMainViews() {
        addChild(mainViewController)
        addChild(propertySelector)
        
        view.addSubviewsUsingAutolayout(mainViewController.view, propertySelector.view)
        
        mainViewController.didMove(toParent: self)
        propertySelector.didMove(toParent: self)
        
        propertySelectorHeight =
        propertySelector.view.heightAnchor
            .constraint(equalToConstant: propertySelector.preferredContentSize.height)
        
        NSLayoutConstraint.activate([
            propertySelector.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            propertySelector.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            propertySelector.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            propertySelectorHeight!,
            mainViewController.view.topAnchor.constraint(equalTo: propertySelector.view.bottomAnchor),
            mainViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    /// Sets up and configures the separatorLine and tabCutout constraints
    private func setUpCutout() {
        mainViewController.view.addSubviewsUsingAutolayout(separatorLine, tabCutout)
        
        tabCutout.centerHorizontallyInSuperview()
        tabCutout.constrainToSize(CGSize(width: tabWidth, height: tabWidth))
        tabCutout.centerYAnchor.constraint(equalTo: mainViewController.view.topAnchor, constant: -5).isActive = true
        
        NSLayoutConstraint.activate([
            separatorLine.topAnchor.constraint(equalTo: mainViewController.view.topAnchor),
            separatorLine.leadingAnchor.constraint(equalTo: mainViewController.view.leadingAnchor),
            separatorLine.trailingAnchor.constraint(equalTo: mainViewController.view.trailingAnchor),
            separatorLine.heightAnchor.constraint(equalToConstant: separatorWidth)
        ])
    }
}

// Extra padding for refresh control due to tab cutout
extension UIRefreshControl {
    static var topPadding: CGFloat = 20
    fileprivate static let topPaddingDefault: CGFloat = 20
}
