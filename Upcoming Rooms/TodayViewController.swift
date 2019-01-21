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
        
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData

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
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        updateView()
    }
    
    private func updateView() {
        guard let extensionContext = extensionContext else {
            return
        }
        
        if rooms.count == 0 {
            todayView.configure(with: rooms)
            return
        }
        
        if rooms.count > 1 {
            extensionContext.widgetLargestAvailableDisplayMode = .expanded
        } else {
            extensionContext.widgetLargestAvailableDisplayMode = .compact
        }
        
        switch extensionContext.widgetActiveDisplayMode {
        case .expanded:
            todayView.configure(with: rooms)
        case .compact:
            todayView.configure(with: [rooms[0]])
        }
    }
}
