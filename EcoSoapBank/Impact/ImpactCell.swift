//
//  ImpactCell.swift
//  EcoSoapBank
//
//  Created by Shawn Gee on 8/11/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit

class ImpactCell: UICollectionViewCell {
    
    enum Alignment {
        case leading, trailing
    }
    
    static let reuseIdentifier = "ImpactCell"
    
    // MARK: - Public Properties
    
    var alignment: Alignment = .leading {
        didSet {
            if oldValue != alignment {
                swapHorizontalConstraints()
            }
        }
    }
    
    // MARK: - Private Properties
    
    // Views
    private let titleLabel = configure(UILabel()) {
        $0.font = .montserrat(ofSize: 24, style: .semiBold)
        $0.textColor = .white
        $0.text = "34.9 lbs"
    }
    
    private let subtitleLabel = configure(UILabel()) {
        $0.font = .montserrat(ofSize: 18)
        $0.textColor = .codGrey
        $0.numberOfLines = 0
        $0.text = "bottle amenities\nrecycled"
    }
    
    private let imageView = configure(UIImageView()) {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.image = UIImage(named: "Bottles")
    }
    
    private lazy var circleView = configure(GradientView()) {
        $0.colors = [.esbGreen, .downyBlue]
        $0.startPoint = CGPoint(x: 0, y: 1)
        $0.endPoint = CGPoint(x: 1, y: 0)
        $0.layer.borderColor = UIColor.white.cgColor
        $0.layer.borderWidth = self.strokeWidth
    }
    
    private let lineView = configure(UIView()) {
        $0.backgroundColor = .white
    }
    
    // Constraints
    private var leadingConstraints: [NSLayoutConstraint] = []
    private var trailingConstraints: [NSLayoutConstraint] = []
    
    // Layout Constants
    private let circlePadding: CGFloat = 22.0
    private let circleHeightMultiplier: CGFloat = 1.0
    private let imagePadding: CGFloat = 16.0
    private let strokeWidth: CGFloat = 2.0
    private let verticalLabelPadding: CGFloat = 5.0
    private let horizontalLabelPadding: CGFloat = 15.0
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }
    
    // MARK: - Public Methods
    
    func setUpCell(with title: String, subtitle: String, image: UIImage) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
        imageView.image = image
    }
    
    // MARK: - Overrides
    
    override func layoutSubviews() {
        super.layoutSubviews()
        circleView.layer.cornerRadius = circleView.frame.width / 2
        imageView.layer.cornerRadius = imageView.frame.width / 2
    }
    
    // MARK: - Private Methods

    private func setUp() {
        addSubviews(titleLabel, subtitleLabel, circleView, imageView, lineView)
        
        addCommonConstraints()
        setUpLeadingConstraints()
        setUpTrailingConstraints()
        
        NSLayoutConstraint.activate(leadingConstraints)
    }
    
    private func addCommonConstraints() {
        NSLayoutConstraint.activate([
            circleView.centerYAnchor.constraint(equalTo: centerYAnchor),
            circleView.heightAnchor.constraint(equalTo: heightAnchor,
                                               multiplier: circleHeightMultiplier),
            circleView.widthAnchor.constraint(equalTo: circleView.heightAnchor),
            
            imageView.centerXAnchor.constraint(equalTo: circleView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: circleView.centerYAnchor),
            imageView.heightAnchor.constraint(equalTo: circleView.heightAnchor,
                                              constant: -imagePadding),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
            
            lineView.centerYAnchor.constraint(equalTo: circleView.centerYAnchor),
            lineView.heightAnchor.constraint(equalToConstant: strokeWidth),
            
            titleLabel.bottomAnchor.constraint(equalTo: lineView.topAnchor,
                                               constant: -verticalLabelPadding),
            subtitleLabel.topAnchor.constraint(equalTo: lineView.bottomAnchor,
                                               constant: verticalLabelPadding)
        ])
    }
    
    private func setUpLeadingConstraints() {
        leadingConstraints = [
            circleView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                constant: circlePadding),
            
            lineView.leadingAnchor.constraint(equalTo: circleView.trailingAnchor),
            lineView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: circleView.trailingAnchor,
                                                constant: horizontalLabelPadding),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor)
        ]
    }
    
    private func setUpTrailingConstraints() {
        trailingConstraints = [
            circleView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                 constant: -circlePadding),
            
            lineView.trailingAnchor.constraint(equalTo: circleView.leadingAnchor),
            lineView.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            titleLabel.trailingAnchor.constraint(equalTo: circleView.leadingAnchor,
                                                 constant: -horizontalLabelPadding),
            subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor)
        ]
    }
    
    private func swapHorizontalConstraints() {
        if alignment == .leading {
            NSLayoutConstraint.deactivate(trailingConstraints)
            NSLayoutConstraint.activate(leadingConstraints)
            subtitleLabel.textAlignment = .left
        } else {
            NSLayoutConstraint.deactivate(leadingConstraints)
            NSLayoutConstraint.activate(trailingConstraints)
            subtitleLabel.textAlignment = .right
        }
    }
}