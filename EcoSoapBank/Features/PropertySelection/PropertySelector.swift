//
//  PropertySelector.swift
//  EcoSoapBank
//
//  Created by Shawn Gee on 9/17/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit

/// Used to allow displaying/selecting a single `Property` or `AllProperties`
private protocol PropertyDisplayable { var name: String { get } }
private struct AllProperties: PropertyDisplayable { let name = "All Properties" }

extension Property: PropertyDisplayable {}

class PropertySelector: UIViewController {
    
    // MARK: - Public Properties
    
    /// The user whose properties should be selected from.
    var user: User
    
    /// Used by containing view controllers to determine duration of expansion/contraction
    /// animation of the height constraint for the property selector (child vc). This animation
    /// should take place in `preferredContentSizeDidChange`.
    let expansionDuration: TimeInterval = 0.3
    
    /// Determines whether the property selector should display initially expanded before animating closed.
    let shouldPeak: Bool
    
    // MARK: - Private Properties
    
    /// Calculates the properties to display, moving the selected property to the top (if there is one)
    /// and adding AllProperties to allow for selecting all properties (which sets the selectedProperty
    /// user default to nil).
    private var properties: [PropertyDisplayable] {
        var properties = user.properties ?? []
        
        if let selectedProperty = selectedProperty,
            let index = properties.firstIndex(of: selectedProperty) {
            properties.move(fromOffsets: [index], toOffset: 0)
            
            return properties + [AllProperties()]
        } else {
            return [AllProperties()] + properties
        }
    }
    
    private var selectedProperty: Property? {
        get { UserDefaults.standard.selectedProperty(forUser: user) }
        set { UserDefaults.standard.setSelectedProperty(newValue, forUser: user) }
    }
    
    private let cellHeight: CGFloat = 32
    private var tableView = UITableView()
    private var dataSource: UITableViewDiffableDataSource<Int, String>?
    private var selectedPropertyObserver: UserDefaultsObservation?
    private var shouldAnimateDifferences = false
    private var isExpanded = true {
        didSet {
            if isExpanded {
                tableView.setNeedsLayout()
                tableView.layoutIfNeeded()
                preferredContentSize.height = tableView.contentSize.height - 1
            } else {
                preferredContentSize.height = cellHeight - 1 // hide bottom separator line
            }
        }
    }
    
    // MARK: - Init
    
    @available(*, unavailable, message: "Use init(user:)")
    required init?(coder: NSCoder) {
        fatalError("`init(coder:)` not implemented. Use `init(user:)`.")
    }
    
    init(user: User, shouldPeak: Bool = false) {
        self.user = user
        self.shouldPeak = shouldPeak
        super.init(nibName: nil, bundle: nil)
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectedPropertyObserver = UserDefaults.$selectedPropertyIDsByUser.observe { [weak self] _, _ in
            self?.reloadData()
        }
        
        view.backgroundColor = .codGrey
        addShadows()
        setUpTableView()
        
        if shouldPeak {
            isExpanded = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.isExpanded = false
            }
        } else {
            isExpanded = false
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        shouldAnimateDifferences = true // only animate if already visible
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        isExpanded = false // collapse if when leaving screen
    }
    
    // MARK: - Private Methods
    
    private func setUpTableView() {
        tableView.register(PropertySelectorCell.self, forCellReuseIdentifier: NSStringFromClass(PropertySelectorCell.self))
        
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.isScrollEnabled = false
        
        view.addSubviewsUsingAutolayout(tableView)
        tableView.fillSuperview()
        
        setUpDataSource()
    }
    
    // swiftlint:disable closure_parameter_position
    
    /// Sets up the diffable data source for the table view which essentially takes the place of a
    /// traditional table view data source and the corresponding `cellForRowAtIndexPath`. Also calls
    /// `reloadData()` in order to apply an initial snapshot.
    private func setUpDataSource() {
        dataSource = UITableViewDiffableDataSource<Int, String>(tableView: tableView) {
            (tableView: UITableView, indexPath: IndexPath, itemIdentifier: String) -> UITableViewCell? in
            
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: NSStringFromClass(PropertySelectorCell.self),
                for: indexPath) as? PropertySelectorCell else {
                    fatalError("Unable to cast cell as \(PropertySelectorCell.self)")
            }
            
            cell.label.text = itemIdentifier
            
            return cell
        }
        
        tableView.dataSource = dataSource
        reloadData()
    }
    // swiftlint:enable closure_parameter_position
    
    /// Creates a new snapshot using the `properties` computed var and applies it to the data source
    private func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, String>()

        snapshot.appendSections([0])
        snapshot.appendItems(properties.map { $0.name }) // use the property name as the identifier
        
        dataSource?.apply(snapshot, animatingDifferences: shouldAnimateDifferences) // only animate if already visible
    }
    
    private func addShadows() {
        let topShadow = GradientView()
        topShadow.colors = [UIColor.codGrey.adjustingBrightness(by: -0.07), .codGrey]
        topShadow.startPoint = CGPoint(x: 0, y: 0)
        topShadow.endPoint = CGPoint(x: 0, y: 1)
        
        let bottomShadow = GradientView()
        bottomShadow.colors = [UIColor.codGrey.adjustingBrightness(by: -0.05), .codGrey]
        bottomShadow.startPoint = CGPoint(x: 0, y: 1)
        bottomShadow.endPoint = CGPoint(x: 0, y: 0)
        
        let line = UIView()
        line.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
        view.addSubviewsUsingAutolayout(topShadow, bottomShadow, line)
        
        NSLayoutConstraint.activate([
            topShadow.topAnchor.constraint(equalTo: view.topAnchor),
            topShadow.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topShadow.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topShadow.heightAnchor.constraint(equalToConstant: 8),
            bottomShadow.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomShadow.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomShadow.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomShadow.heightAnchor.constraint(equalToConstant: 6),
            line.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            line.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            line.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            line.heightAnchor.constraint(equalToConstant: 1.0)
        ])
    }
}

extension PropertySelector: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if !isExpanded {
            // Selection controller is collapsed, so expand it to allow selection
            isExpanded = true
            tableView.isScrollEnabled = true
        } else {
            if let property = properties[indexPath.row] as? Property {
                selectedProperty = property
            } else {
                selectedProperty = nil // All Properties selected
            }
            
            reloadData()
            tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            tableView.isScrollEnabled = false
            isExpanded = false
        }
    }
}
