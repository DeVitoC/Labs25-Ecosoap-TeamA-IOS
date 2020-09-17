//
//  CartonView.swift
//  EcoSoapBank
//
//  Created by Shawn Gee on 9/10/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import SwiftUI
import UIKit

class CartonView: UIView, ESBBordered {
    
    // MARK: - Public Properties
    
    var percentFull: Int? {
        didSet {
            setNeedsLayout()
        }
    }
    
    // ESB Bordered Settings
    let borderWidth: CGFloat = 1.0
    let lightModeBorderColor = UIColor.codGrey
    let darkModeBorderColor = UIColor.white

    private let fillRect = UIView(frame: .zero)
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    // MARK: - Overrides
    
    override func layoutSubviews() {
        if let percentFull = percentFull {
            print(percentFull)
            fillRect.frame = bounds.offsetBy(
                dx: 0,
                dy: (CGFloat(100 - percentFull) / 100 * frame.height)
            )
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.userInterfaceStyle != previousTraitCollection?.userInterfaceStyle {
            updateBorderColor()
        }
    }
    
    // MARK: - Private Methods
    
    private func setUp() {
        backgroundColor = .systemBackground
        configureBorder()
        
        fillRect.backgroundColor = UIColor.downyBlue
        addSubview(fillRect)
    }
}

// MARK: - SwiftUI Previews

struct CartonViewWrapper: UIViewRepresentable {
    func makeUIView(context: UIViewRepresentableContext<CartonViewWrapper>) -> UIView {
        configure(CartonView(frame: .zero)) {
            $0.percentFull = 50
        }
    }
    
    func updateUIView(_ uiView: CartonViewWrapper.UIViewType, context: UIViewRepresentableContext<CartonViewWrapper>) {
    }
}

struct CartonViewWrapper_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            CartonViewWrapper().frame(width: 36, height: 36, alignment: .center)
        }
    }
}
