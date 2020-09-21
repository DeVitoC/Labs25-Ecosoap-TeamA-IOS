//
//  PropertySelectionSwiftUIContainer.swift
//  EcoSoapBank
//
//  Created by Shawn Gee on 9/21/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import SwiftUI
import UIKit

/// Embeds the given SwiftUI View (in a UIHostingController) along with a
/// PropertySelectionViewController as child views, with the property selector
/// constrained above the SwiftUI View.
class PropertySelectionHostingController<V: View>: UIViewController {
    
    // MARK: - Public Properties
    
    let hostingController: UIHostingController<V>
    let propertySelector: PropertySelectionViewController
    
    // MARK: - Private Properties
    
    private var propertySelectorHeight: NSLayoutConstraint?
    
    // MARK: - Init
    
    @available(*, unavailable, message: "Use init(user:)")
    required init?(coder: NSCoder) {
        fatalError("`init(coder:)` not implemented. Use `init(user:)`.")
    }
    
    init(rootView: V, user: User) {
        self.hostingController = UIHostingController(rootView: rootView)
        self.propertySelector = PropertySelectionViewController(user: user)
        super.init(nibName: nil, bundle: nil)
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChild(hostingController)
        addChild(propertySelector)
        view.addSubviewsUsingAutolayout(hostingController.view, propertySelector.view)
        hostingController.didMove(toParent: self)
        propertySelector.didMove(toParent: self)
        
        propertySelectorHeight =
        propertySelector.view.heightAnchor
            .constraint(equalToConstant: propertySelector.preferredContentSize.height)
        
        NSLayoutConstraint.activate([
            propertySelector.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            propertySelector.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            propertySelector.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            propertySelectorHeight!,
            hostingController.view.topAnchor.constraint(equalTo: propertySelector.view.bottomAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
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
