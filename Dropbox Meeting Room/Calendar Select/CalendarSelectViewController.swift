//
//  CalendarSelectViewController.swift
//  Dropbox Meeting Room
//
//  Created by Zac West on 1/20/19.
//  Copyright © 2019 Zac West. All rights reserved.
//

import Foundation
import UIKit
import EventKitUI
import Shared

class CalendarSelectViewController: UIViewController {
    private var calendarSelectView: CalendarSelectView { return view as! CalendarSelectView }
    weak var delegate: RootDisplayableDelegate?
    
    private let settings = Settings()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        
        title = NSLocalizedString("Calendar Selection", comment: "")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func loadView() {
        view = CalendarSelectView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendarSelectView.ctaView.ctaButton.addTarget(self, action: #selector(choose(_:)), for: .touchUpInside)
    }
    
    @objc private func choose(_ sender: UIButton) {
        let chooser = EKCalendarChooser(selectionStyle: .multiple, displayStyle: .allCalendars, entityType: .event, eventStore: settings.eventStore)
        chooser.delegate = self
        chooser.showsDoneButton = true
        
        // must be set, even if we aren't passing any in (but we might be)
        chooser.selectedCalendars = Set(settings.calendars)
        
        let navigationController = UINavigationController(rootViewController: chooser)
        present(navigationController, animated: true, completion: nil)
    }
}

extension CalendarSelectViewController: RootDisplayable {
    static var shouldDisplay: Bool {
        return Settings().calendars.isEmpty
    }
}

extension CalendarSelectViewController: EKCalendarChooserDelegate {
    func calendarChooserSelectionDidChange(_ calendarChooser: EKCalendarChooser) {
        
    }
    
    func calendarChooserDidFinish(_ calendarChooser: EKCalendarChooser) {
        Settings().calendars = Array(calendarChooser.selectedCalendars)
        
        dismiss(animated: true) { [weak self] in
            self?.delegate?.advance()
        }
    }
}
