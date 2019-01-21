//
//  RoomTableViewController.swift
//  Dropbox Meeting Room
//
//  Created by Zac West on 1/20/19.
//  Copyright © 2019 Zac West. All rights reserved.
//

import Foundation
import UIKit
import Shared

protocol RoomTableViewControllerDelegate: class {
    func roomTableViewController(_ controller: RoomTableViewController, didSelect room: Room)
}

class RoomTableViewController: UITableViewController {
    weak var delegate: RoomTableViewControllerDelegate?
    
    var rooms: [Room] = [] {
        didSet {
            tableView.reloadData()
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
            $0.register(RoomCell.self, forCellReuseIdentifier: RoomCell.reuseIdentifier)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rooms.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RoomCell.reuseIdentifier, for: indexPath)
        
        if let cell = cell as? RoomCell {
            let room = rooms[indexPath.row]
            cell.configure(room: room)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let room = rooms[indexPath.row]
        delegate?.roomTableViewController(self, didSelect: room)
    }
}
