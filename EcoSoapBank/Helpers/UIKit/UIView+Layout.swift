//
//  UIView+Layout.swift
//  EcoSoapBank
//
//  Created by Shawn Gee on 8/17/20.
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
    func constrainNewSubview(
        _ subView: UIView,
        to sides: Set<LayoutSide>,
        constant: CGFloat = 0
    ) {
        addSubview(subView)
        subView.constrain(with: constraints(from: subView, toSides: sides, constant: constant))
    }

    /// Adds provided subview and activates constraints to all sides of view.
    ///
    /// Also sets `translatesAutoResizingMaskIntoConstraints` to false.
    func constrainNewSubviewToSides(_ subView: UIView, constant: CGFloat = 0) {
        constrainNewSubview(
            subView,
            with: constraints(from: subView, toSides: .all, constant: constant))
    }

    /// Adds provided subview and constrains to anchors equal to provided sides (all by default).
    ///
    /// Also sets `translatesAutoResizingMaskIntoConstraints` to false.
    func constrainNewSubviewToSafeArea(
        _ subView: UIView,
        sides: Set<LayoutSide> = .all,
        constant: CGFloat = 0
    ) {
        let constraints = subView.constraints(
            from: self.safeAreaLayoutGuide,
            toSides: sides,
            constant: constant)
        constrainNewSubview(subView, with: constraints)
    }
    
    /// Fills the view's superview completely.
    ///
    /// Also sets `translatesAutoResizingMaskIntoConstraints` to false.
    /// - Precondition: View must be embedded in a superview.
    func fillSuperview() {
        guard let superview = superview else {
            assertionFailure("\(Self.self) has no superview to fill")
            return
        }
        
        self.constrain(with: constraints(from: superview, toSides: .all, constant: 0))
    }
    
    /// Centers a view horizontally in it's superview with specified multiplier
    /// providing a relative offset.
    ///
    /// Also sets `translatesAutoResizingMaskIntoConstraints` to false.
    /// - Precondition: View must be embedded in a superview.
    func centerHorizontallyInSuperview(multiplier: CGFloat = 1.0) {
        guard let superview = superview else {
            assertionFailure("\(Self.self) has no superview to fill")
            return
        }
        
        self.constrain(with: [
            NSLayoutConstraint(
                item: self,
                attribute: .centerY,
                relatedBy: .equal,
                toItem: superview,
                attribute: .centerY,
                multiplier: multiplier,
                constant: 0)
        ])
    }
    
    /// Centers a view vertically in it's superview with specified multiplier
    /// providing a relative offset.
    ///
    /// Also sets `translatesAutoResizingMaskIntoConstraints` to false.
    /// - Precondition: View must be embedded in a superview.
    func centerVerticallyInSuperview(multiplier: CGFloat = 1.0) {
        guard let superview = superview else {
            assertionFailure("\(Self.self) has no superview to fill")
            return
        }
        
        self.constrain(with: [
            NSLayoutConstraint(
                item: self,
                attribute: .centerY,
                relatedBy: .equal,
                toItem: superview,
                attribute: .centerY,
                multiplier: multiplier,
                constant: 0)
        ])
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
        from constrainable: AutoLayoutConstrainable,
        toSides sides: Set<LayoutSide> = .all,
        constant: CGFloat = 0
    ) -> [NSLayoutConstraint] {
        sides.map {
            $0.constraint(from: self, to: constrainable, constant: constant)
        }
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
        to other: AutoLayoutConstrainable,
        constant: CGFloat = 0
    ) -> NSLayoutConstraint {
        switch self {
        case .top:
            return constrainable.topAnchor
                .constraint(equalTo: other.topAnchor, constant: constant)
        case .leading:
            return constrainable.leadingAnchor
                .constraint(equalTo: other.leadingAnchor, constant: constant)
        case .trailing:
            return constrainable.trailingAnchor
                .constraint(equalTo: other.trailingAnchor, constant: -constant)
        case .bottom:
            return constrainable.bottomAnchor
                .constraint(equalTo: other.bottomAnchor, constant: -constant)
        }
    }
}

extension ExpressibleByArrayLiteral where ArrayLiteralElement == LayoutSide {
    static var all: Self { [.top, .leading, .trailing, .bottom] }
}
