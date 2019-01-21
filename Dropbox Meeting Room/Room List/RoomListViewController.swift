//
//  RoomListViewController.swift
//  Dropbox Meeting Room
//
//  Created by Zac West on 1/20/19.
//  Copyright © 2019 Zac West. All rights reserved.
//

import Foundation
import UIKit
import Shared
import EventKitUI

class RoomListViewController: UIViewController {
    weak var delegate: RootDisplayableDelegate?
    
    private let settings: Settings
    private let roomParser: RoomParser
    
    private let tableViewController: RoomTableViewController
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        let settings = Settings()
        self.settings = settings
        self.roomParser = RoomParser(settings: settings)
        
        tableViewController = RoomTableViewController()
        
        super.init(nibName: nil, bundle: nil)
        
        title = NSLocalizedString("Meeting Rooms", comment: "")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(
                title: NSLocalizedString("Settings", comment: ""),
                style: .plain,
                target: self,
                action: #selector(settings(_:))
            )
        ]
        
        tableViewController.delegate = self
        
        addChild(tableViewController)
        view.addSubview(tableViewController.view)
        with(tableViewController.view!) {
            $0.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: view.topAnchor),
                $0.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                $0.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                $0.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            ])
        }
        tableViewController.didMove(toParent: self)
            
        NotificationCenter.default.addObserver(self, selector: #selector(eventStoreDidChange(_:)), name: .EKEventStoreChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(settingDidChange(_:)), name: .DataInfluencingSettingDidChange, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if tableViewController.rooms.isEmpty {
            updateRooms()
        }
    }
    
    @objc private func settings(_ sender: UIButton) {
        delegate?.showSettings(sender: sender)
    }
    
    @objc private func eventStoreDidChange(_ notification: Notification) {
        updateRooms()
    }
    
    @objc private func settingDidChange(_ notification: Notification) {
        updateRooms()
    }
    
    private func updateRooms() {
        roomParser.findRooms { [weak self] rooms in
            self?.tableViewController.rooms = rooms
        }
    }
}

extension RoomListViewController: RootDisplayable {
    static var shouldDisplay: Bool {
        return true
    }
    
    static var canBeRedisplayed: Bool {
        return false
    }
    
    static var redisplayTitle: String? {
        return nil
    }
}

extension RoomListViewController: RoomTableViewControllerDelegate {
    func roomTableViewController(_ controller: RoomTableViewController, didSelect room: Room) {
        let eventViewController = with(EKEventViewController()) {
            $0.event = room.event
            $0.delegate = self
        }
        let navigationController = UINavigationController(rootViewController: eventViewController)
        navigationController.navigationBar.isTranslucent = false
        present(navigationController, animated: true, completion: nil)

    }
}

extension RoomListViewController: EKEventViewDelegate {
    func eventViewController(_ controller: EKEventViewController, didCompleteWith action: EKEventViewAction) {
        dismiss(animated: true, completion: nil)
    }
}
