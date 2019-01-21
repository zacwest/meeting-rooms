//
//  TodayViewController.swift
//  Upcoming Rooms
//
//  Created by Zac West on 1/20/19.
//  Copyright © 2019 Zac West. All rights reserved.
//

import UIKit
import NotificationCenter
import Shared
import EventKit

class TodayViewController: UIViewController, NCWidgetProviding {
    private var todayView: TodayView { return view as! TodayView }
    
    let settings: Settings
    let roomParser: RoomParser
    
    private(set) var rooms: [Room] = [] {
        didSet {
            updateView()
        }
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        let settings = Settings()
        self.settings = settings
        self.roomParser = RoomParser(settings: settings)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func loadView() {
        view = TodayView()
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(eventStoreDidChange(_:)), name: .EKEventStoreChanged, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: .EKEventStoreChanged, object: nil)
    }
    
    @objc private func eventStoreDidChange(_ notification: Notification) {
        updateRooms()
    }
        
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        updateRooms(completionHandler: completionHandler)
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        updateView()
    }
    
    private func updateRooms(completionHandler: @escaping (NCUpdateResult) -> Void = {_ in}) {
        roomParser.findRooms { [weak self] rooms in
            guard let this = self else {
                completionHandler(.failed)
                return
            }
            
            if rooms == this.rooms {
                completionHandler(.noData)
            } else {
                this.rooms = rooms
                completionHandler(.newData)
            }
        }
    }
    
    private func updateView() {
        guard let extensionContext = extensionContext else {
            return
        }
        
        guard settings.isOnboarded else {
            extensionContext.widgetLargestAvailableDisplayMode = .compact
            todayView.configureForRequiresOnboarding()
            return
        }
        
        let displayMode: NCWidgetDisplayMode
        
        if rooms.count > 1 {
            extensionContext.widgetLargestAvailableDisplayMode = .expanded
            displayMode = extensionContext.widgetActiveDisplayMode
        } else {
            extensionContext.widgetLargestAvailableDisplayMode = .compact
            displayMode = .compact
        }
        
        switch displayMode {
        case .expanded:
            todayView.configure(with: rooms, hiding: 0..<0)
        case .compact where rooms.count > 1:
            todayView.configure(with: rooms, hiding: 1..<rooms.count)
        default:
            todayView.configure(with: rooms, hiding: 0..<0)
        }
    }
}
