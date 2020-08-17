//
//  Constraints.swift
//  EcoSoapBank
//
//  Created by Jon Bash on 2020-08-17.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit


extension UIView {
    /// Set view's `translatesAutoResizingMaskIntoConstraints` to false
    /// and activates the provided constraints.
    func constrain(with constraints: [NSLayoutConstraint]) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(constraints)
    }

    /// Adds provided subview and activates constraints.
    ///
    /// Also sets `translatesAutoResizingMaskIntoConstraints` to false.
    func constrainNewSubview(
        _ subView: UIView,
        with constraints: [NSLayoutConstraint]
    ) {
        addSubview(subView)
        subView.constrain(with: constraints)
    }

    /// Adds provided subview, and activates constraints equal to the anchors of each of the provided sides.
    ///
    /// Also sets `translatesAutoResizingMaskIntoConstraints` to false.
    func constrainNewSubview(_ subView: UIView, to sides: Set<LayoutSide>) {
        addSubview(subView)
        subView.constrain(with: constraints(for: subView, to: sides))
    }

    /// Adds provided subview and activates constraints to all sides of view.
    ///
    /// Also sets `translatesAutoResizingMaskIntoConstraints` to false.
    func constrainNewSubviewToSides(_ subView: UIView) {
        constrainNewSubview(subView, with: constraints(for: subView, to: .all))
    }

    /// Adds provided subview and constrains to anchors equal to provided sides (all by default).
    ///
    /// Also sets `translatesAutoResizingMaskIntoConstraints` to false.
    func constrainNewSubviewToSafeArea(
        _ subView: UIView,
        sides: Set<LayoutSide> = .all
    ) {
        let constraints = subView
            .constraints(for: self.safeAreaLayoutGuide, to: sides)
        constrainNewSubview(subView, with: constraints)
    }
}


extension UIEdgeInsets {
    var width: CGFloat { left + right }
    var height: CGFloat { top + bottom }
}


protocol AutoLayoutConstrainable {
    var bottomAnchor: NSLayoutYAxisAnchor { get }
    var centerXAnchor: NSLayoutXAxisAnchor { get }
    var centerYAnchor: NSLayoutYAxisAnchor { get }
    var heightAnchor: NSLayoutDimension { get }
    var leadingAnchor: NSLayoutXAxisAnchor { get }
    var leftAnchor: NSLayoutXAxisAnchor { get }
    var rightAnchor: NSLayoutXAxisAnchor { get }
    var topAnchor: NSLayoutYAxisAnchor { get }
    var trailingAnchor: NSLayoutXAxisAnchor { get }
    var widthAnchor: NSLayoutDimension { get }
}

extension AutoLayoutConstrainable {
    func constraints(
        for constrainable: AutoLayoutConstrainable,
        to sides: Set<LayoutSide> = .all
    ) -> [NSLayoutConstraint] {
        sides.map { $0.constraint(from: self, to: constrainable) }
    }
}

extension UIView: AutoLayoutConstrainable {}
extension UILayoutGuide: AutoLayoutConstrainable {}


enum LayoutSide: CaseIterable {
    case top
    case leading
    case trailing
    case bottom

    /// Returns an "equal to" constraint for this side between each of the provided views.
    func constraint(
        from constrainable: AutoLayoutConstrainable,
        to other: AutoLayoutConstrainable
    ) -> NSLayoutConstraint {
        switch self {
        case .top:
            return constrainable.topAnchor.constraint(equalTo: other.topAnchor)
        case .leading:
            return constrainable.leadingAnchor.constraint(equalTo: other.leadingAnchor)
        case .trailing:
            return constrainable.trailingAnchor.constraint(equalTo: other.trailingAnchor)
        case .bottom:
            return constrainable.bottomAnchor.constraint(equalTo: other.bottomAnchor)
        }
    }
}

extension ExpressibleByArrayLiteral where ArrayLiteralElement == LayoutSide {
    static var all: Self { [.top, .leading, .trailing, .bottom] }
}
