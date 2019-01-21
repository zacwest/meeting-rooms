//
//  PermissionViewController.swift
//  Meeting Rooms
//
//  Created by Zac West on 1/20/19.
//  Copyright © 2019 Zac West. All rights reserved.
//

import Foundation
import EventKit
import UIKit

class PermissionViewController: UIViewController {
    private var permissionView: PermissionView { return view as! PermissionView }
    weak var delegate: RootDisplayableDelegate?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        
        title = NSLocalizedString("Permissions", comment: "")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func loadView() {
        view = PermissionView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        permissionView.ctaView.ctaButton.addTarget(self, action: #selector(grant(_:)), for: .touchUpInside)
    }
    
    @objc private func grant(_ sender: UIButton) {
        if EKEventStore.authorizationStatus(for: .event) != .notDetermined {
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
        } else {
            EKEventStore().requestAccess(to: .event) { [weak self] success, error in
                if success {
                    DispatchQueue.main.async {
                        self?.delegate?.advance()
                    }
                }
            }
        }
    }
}

extension PermissionViewController: RootDisplayable {
    class var shouldDisplay: Bool {
        switch EKEventStore.authorizationStatus(for: .event) {
        case .authorized:
            return false
        case .denied, .notDetermined, .restricted:
            return true
        }
    }
    
    static var canBeRedisplayed: Bool {
        return false
    }
    
    static var redisplayTitle: String? {
        return nil
    }
}
