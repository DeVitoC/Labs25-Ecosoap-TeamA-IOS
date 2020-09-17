//
//  PropertySelectionViewController.swift
//  EcoSoapBank
//
//  Created by Shawn Gee on 9/17/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit

class PropertySelectionViewController: UIViewController {
    
    // MARK: - Public Properties
    
    var properties = ["Blep Bed and Breakfast", "Tranquil Tavern", "Serene Stays"]
    var selectedProperty: String?
    let expansionDuration: TimeInterval = 0.3
    
    // MARK: - Private Properties
    
    private let cellHeight: CGFloat = 32
    
    private var tableView = UITableView()
    
    private var isExpanded = false {
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
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .codGrey
        
        addShadows()
        setUpTableView()
        
        selectedProperty = properties.first
        isExpanded = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.isExpanded = false
        }
    }
    
    
    // MARK: - Private Methods
    
    private func setUpTableView() {
         tableView.register(PropertySelectionCell.self, forCellReuseIdentifier: NSStringFromClass(PropertySelectionCell.self))
         
         tableView.dataSource = self
         tableView.delegate = self
         tableView.backgroundColor = .clear
         tableView.isScrollEnabled = false
         
         view.addSubviewsUsingAutolayout(tableView)
         tableView.fillSuperview()
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

// MARK: - Table View Data Source

extension PropertySelectionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        properties.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: NSStringFromClass(PropertySelectionCell.self),
            for: indexPath) as? PropertySelectionCell else {
                fatalError("Unable to cast cell as \(PropertySelectionCell.self)")
        }
        
        cell.label.text = properties[indexPath.row]

        return cell
    }
}

extension PropertySelectionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if !isExpanded {
            isExpanded = true
        } else {
            let property = properties.remove(at: indexPath.row)
            properties.insert(property, at: 0)
            tableView.moveRow(at: indexPath, to: IndexPath(row: 0, section: 0))
            
            selectedProperty = property
    
            isExpanded = false
        }
    }
}
