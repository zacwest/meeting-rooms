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

class RoomListViewController: UICollectionViewController {
    weak var delegate: RootDisplayableDelegate?
    
    private let settings: Settings
    private let roomParser: RoomParser
    
    private var rooms: [Room] = []
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        let settings = Settings()
        self.settings = settings
        self.roomParser = RoomParser(settings: settings)
        
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
        
        title = NSLocalizedString("Meeting Rooms", comment: "")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(
                title: NSLocalizedString("Settings", comment: ""),
                style: .plain,
                target: self,
                action: #selector(settings(_:))
            )
        ]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        roomParser.findRooms { [weak self] rooms in
            self?.rooms = rooms
        }
    }
    
    @objc private func settings(_ sender: UIButton) {
        delegate?.showSettings(sender: sender)
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
