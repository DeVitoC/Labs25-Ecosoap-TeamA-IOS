//
//  ImpactCell.swift
//  EcoSoapBank
//
//  Created by Shawn Gee on 8/11/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit

/// Class that sets up the Impact Cell layout
class ImpactCell: UICollectionViewCell {
    
    enum Alignment {
        case leading, trailing
    }
    
    static let reuseIdentifier = "ImpactCell"
    
    // MARK: - Public Properties
    
    var viewModel: ImpactCellViewModel? { didSet { updateViews() } }
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
        let font = UIFont.montserrat(ofSize: UIFont.TextStyle.title3.defaultPointSize,
                                     typeface: .semiBold)
        $0.font = UIFontMetrics(forTextStyle: .title3)
            .scaledFont(for: font, maximumPointSize: 50)
        $0.adjustsFontForContentSizeCategory = true
        $0.textColor = .label
        $0.text = "34.9 lbs"
    }
    
    private let subtitleLabel = configure(UILabel()) {
        let font = UIFont.montserrat(ofSize: UIFont.TextStyle.subheadline.defaultPointSize)
        $0.font = UIFontMetrics(forTextStyle: .subheadline)
            .scaledFont(for: font, maximumPointSize: 30)
        $0.adjustsFontForContentSizeCategory = true
        $0.adjustsFontSizeToFitWidth = true
        $0.textColor = UIColor.codGrey.orInverse()
        $0.numberOfLines = 2
        $0.text = "bottle amenities\nrecycled"
    }
    
    private let circleView = configure(ESBCircularImageView()) {
        $0.borderColor = UIColor.codGrey.or(.white)
    }
    
    private let lineView = configure(UIView()) {
        $0.backgroundColor = UIColor.codGrey.or(.white)
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
    
    // MARK: - Private Methods

    /// Primary UI Layout method for the ImpactCell. Adds UI Elements to the contentView and then calls the relevant methods to complete the rest of the UI setup
    private func setUp() {
        contentView.addSubviewsUsingAutolayout(titleLabel, subtitleLabel, circleView, lineView)
        
        addCommonConstraints()
        setUpLeadingConstraints()
        setUpTrailingConstraints()
        
        NSLayoutConstraint.activate(leadingConstraints)
    }

    /// Adds constraints to the main UI elements that are common to leading and trailing alligned cells
    private func addCommonConstraints() {
        NSLayoutConstraint.activate([
            circleView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            circleView.heightAnchor.constraint(equalTo: contentView.heightAnchor,
                                               multiplier: circleHeightMultiplier),
            
            lineView.centerYAnchor.constraint(equalTo: circleView.centerYAnchor),
            lineView.heightAnchor.constraint(equalToConstant: strokeWidth),
            
            titleLabel.bottomAnchor.constraint(equalTo: lineView.topAnchor,
                                               constant: -verticalLabelPadding),
            subtitleLabel.topAnchor.constraint(equalTo: lineView.bottomAnchor,
                                               constant: verticalLabelPadding)
        ])
    }

    /// Adds constraints to UI elements that will be used for the leading alligned cells
    private func setUpLeadingConstraints() {
        leadingConstraints = [
            circleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                constant: circlePadding),
            
            lineView.leadingAnchor.constraint(equalTo: circleView.trailingAnchor),
            lineView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: circleView.trailingAnchor,
                                                constant: horizontalLabelPadding),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -imagePadding),
        ]
    }

    /// Adds constraints to UI elements that will be used for the trailing alligned cells
    private func setUpTrailingConstraints() {
        trailingConstraints = [
            circleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                 constant: -circlePadding),
            
            lineView.trailingAnchor.constraint(equalTo: circleView.leadingAnchor),
            lineView.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            titleLabel.trailingAnchor.constraint(equalTo: circleView.leadingAnchor,
                                                 constant: -horizontalLabelPadding),
            subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            subtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: imagePadding),
        ]
    }

    /// Controls which constraints will be active based on leading or trailing allignment of the cell
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

    /// Method that updates the text and image of the UI elements when ImpactCellViewModel is set
    private func updateViews() {
        guard let viewModel = viewModel else { return }
        titleLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
        circleView.image = viewModel.image
    }
}
