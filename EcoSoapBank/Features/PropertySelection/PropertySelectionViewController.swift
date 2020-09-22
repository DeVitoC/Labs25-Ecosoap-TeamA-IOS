//
//  PropertySelectionViewController.swift
//  EcoSoapBank
//
//  Created by Shawn Gee on 9/21/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import SwiftUI
import UIKit

/// Embeds the given view controller along with a PropertySelector as child views,
/// with the property selector constrained above the given view controller.
class PropertySelectionViewController: UIViewController {
    
    // MARK: - Public Properties
    
    let mainViewController: UIViewController
    let propertySelector: PropertySelector
    
    // MARK: - Private Properties
    
    private var propertySelectorHeight: NSLayoutConstraint?
    
    // MARK: - Init
    
    @available(*, unavailable, message: "Use init(user:)")
    required init?(coder: NSCoder) {
        fatalError("`init(coder:)` not implemented. Use `init(user:)`.")
    }
    
    /// Sets up the
    /// - Parameters:
    ///   - mainViewController: The main view controller to embed.
    ///   - user: The User whose properties should be displayed in the property selector.
    ///   - shouldPeak: Determines whether the property selector should display initially
    ///   expanded before animating closed.
    init(mainViewController: UIViewController, user: User, shouldPeak: Bool = false) {
        self.mainViewController = mainViewController
        self.propertySelector = PropertySelector(user: user, shouldPeak: shouldPeak)
        super.init(nibName: nil, bundle: nil)
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    override func preferredContentSizeDidChange(forChildContentContainer container: UIContentContainer) {
        super.preferredContentSizeDidChange(forChildContentContainer: container)
        if container === propertySelector {
            propertySelectorHeight?.constant = container.preferredContentSize.height
            UIView.animate(withDuration: propertySelector.expansionDuration) {
                self.view.layoutIfNeeded()
            }
        }
    }
}
