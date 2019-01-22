//
//  RoomTableViewController.swift
//  Meeting Rooms
//
//  Created by Zac West on 1/20/19.
//  Copyright © 2019 Zac West. All rights reserved.
//

import Foundation
import UIKit
import Shared

protocol RoomTableViewControllerDelegate: class {
    func roomTableViewController(_ controller: RoomTableViewController, didSelect room: Room)
    func roomTableViewController(_ controller: RoomTableViewController, didSelectZoomFor room: Room)
    func roomTableViewController(_ controller: RoomTableViewController, previewControllerFor room: Room) -> UIViewController?
    func roomTableViewController(_ controller: RoomTableViewController, commitPreview previewController: UIViewController)
}

class RoomTableViewController: UITableViewController {
    weak var delegate: RoomTableViewControllerDelegate?
    
    var sectionTitles: [Int: String] = [:] {
        didSet {
            if isViewLoaded {
                tableView.reloadData()
            }
        }
    }
    
    var rooms: [[Room]] = [] {
        didSet {
            if isViewLoaded {
                tableView.reloadData()
            }
        }
    }
    
    override init(style: UITableView.Style) {
        super.init(style: .plain)
        
    }
    
    convenience init() {
        self.init(style: .plain)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        with(tableView!) {
            $0.backgroundColor = .white
            $0.alwaysBounceVertical = true
            $0.estimatedRowHeight = 100
            $0.register(RoomCell.self, forCellReuseIdentifier: RoomCell.reuseIdentifier)
        }
        
        registerForPreviewing(with: self, sourceView: tableView)
    }
    
    private func room(for indexPath: IndexPath) -> Room {
        return rooms[indexPath.section][indexPath.row]
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return rooms.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rooms[section].count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if rooms[section].count > 0 {
            return sectionTitles[section]
        } else {
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RoomCell.reuseIdentifier, for: indexPath)
        
        if let cell = cell as? RoomCell {
            cell.configure(room: room(for: indexPath))
            cell.delegate = self
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.roomTableViewController(self, didSelect: room(for: indexPath))
    }
}

extension RoomTableViewController: RoomCellDelegate {
    func roomCellDidSelectJoinZoom(_ cell: RoomCell) {
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        
        delegate?.roomTableViewController(self, didSelectZoomFor: room(for: indexPath))
    }
}

extension RoomTableViewController: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        delegate?.roomTableViewController(self, commitPreview: viewControllerToCommit)
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = tableView.indexPathForRow(at: location) else {
            return nil
        }
        
        return delegate?.roomTableViewController(self, previewControllerFor: room(for: indexPath))
    }
}
