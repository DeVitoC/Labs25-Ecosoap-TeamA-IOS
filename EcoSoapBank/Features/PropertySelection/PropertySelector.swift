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

/// The Property Selector View Controller that controls how the proprety selector at the top
/// of each page. Can be either open or closed and have as many cells as there are properties
/// for the current user
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
    
    /// When true, the property selector sets it's preferred content size to a size that will
    /// display all of the cells for selection, and when false the selector will set it's size
    /// so that only the selected property (which is on top) will be visible.
    var isExpanded = false {
        didSet {
            updateTableView()
            
            if isExpanded {
                setExpandedContentSize()
            } else {
                setCollapsedContentSize()
            }
        }
    }
    
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
    
    /// The selected property is set via user defaults so that it can be updated app wide
    /// and persist between launches. A UserDefaultsObservation can be used to observe changes
    /// as is done in this class, or you can use Combine to observe by subscribing to the
    /// `selectedPropertyPublisher`
    private var selectedProperty: Property? {
        get { UserDefaults.standard.selectedProperty(forUser: user) }
        set { UserDefaults.standard.setSelectedProperty(newValue, forUser: user) }
    }
    
    private let cellHeight: CGFloat = 32
    private let expandedCellHeight: CGFloat = 44 // Expand the cell to make tapping easier
    private var tableView = UITableView()
    private var dataSource: UITableViewDiffableDataSource<Int, String>?
    private var selectedPropertyObserver: UserDefaultsObservation?
    private var shouldAnimateDifferences = false

    // MARK: - Init
    
    @available(*, unavailable, message: "Use init(user:)")
    required init?(coder: NSCoder) {
        fatalError("`init(coder:)` not implemented. Use `init(user:)`.")
    }

    /// Initailizes the **PropertySelector**
    /// - Parameters:
    ///   - user: The currently logged in **User** whose properties will be displayed
    ///   - shouldPeak: **Bool** value which indicates whether the **PropertySelector** should be expanded briefly at the start
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
        addShadow()
        setUpTableView()

        // If shouldPeak is true, briefly expands the PropertySelector and then
        // animates it back to the collapsed size. 
        if shouldPeak {
            isExpanded = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.isExpanded = false
            }
        } else {
            setCollapsedContentSize()
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
        tableView.register(
            PropertySelectorCell.self,
            forCellReuseIdentifier: NSStringFromClass(PropertySelectorCell.self)
        )
        
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
    
    private func addShadow() {
        let topShadow = GradientView()
        topShadow.colors = [UIColor.codGrey.adjustingBrightness(by: -0.07), .codGrey]
        topShadow.startPoint = CGPoint(x: 0, y: 0)
        topShadow.endPoint = CGPoint(x: 0, y: 1)
        
        view.addSubviewsUsingAutolayout(topShadow)
        
        NSLayoutConstraint.activate([
            topShadow.topAnchor.constraint(equalTo: view.topAnchor),
            topShadow.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topShadow.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topShadow.heightAnchor.constraint(equalToConstant: 8),
        ])
    }
    
    private func setCollapsedContentSize() {
        preferredContentSize.height = cellHeight - 1 // hide bottom separator line
    }
    
    private func setExpandedContentSize() {
        preferredContentSize.height =
            expandedCellHeight * CGFloat(tableView.numberOfRows(inSection: 0)) - 1
    }
    
    private func updateTableView() {
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}

extension PropertySelector: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        isExpanded ? expandedCellHeight : cellHeight
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
            
            tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            tableView.isScrollEnabled = false
            isExpanded = false
        }
    }
}
