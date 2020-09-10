//
//  CartonView.swift
//  EcoSoapBank
//
//  Created by Shawn Gee on 9/10/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit

class CartonView: UIView, ESBBordered {
    let borderWidth: CGFloat = 1.0
    let lightModeBorderColor = UIColor.codGrey
    let darkModeBorderColor = UIColor.codGrey.inverseBrightness

    var percentFull: Int? {
        didSet {
            setNeedsDisplay()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    private let fillRect = UIView(frame: .zero)
    
    private func setUp() {
        configureBorder()
        fillRect.backgroundColor = .downyBlue
        addSubview(fillRect)
    }
    
    override func layoutSubviews() {
        if let percentFull = percentFull {
            fillRect.frame = frame.offsetBy(
                dx: 0,
                dy: (CGFloat(100 - percentFull) / 100 * frame.height)
            )
        }
    }
    
}

import SwiftUI

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
