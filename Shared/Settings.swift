//
//  Settings.swift
//  Dropbox Meeting Room
//
//  Created by Zac West on 1/20/19.
//  Copyright © 2019 Zac West. All rights reserved.
//

import Foundation
import UIKit
import EventKit

class Settings {
    private var appGroup: String {
        return "group.us.zac.dmr"
    }
    
    lazy private(set) var eventStore = EKEventStore()
    
    var tintColor: UIColor {
        return .blue
    }
    
    struct StoreableCalendar: Codable {
        var calendarIdentifier: String?
        var title: String?
        var sourceIdentifier: String?
        
        init(calendar: EKCalendar) {
            calendarIdentifier = calendar.calendarIdentifier
            title = calendar.title
            sourceIdentifier = calendar.source.sourceIdentifier
        }
        
        func matches(_ calendar: EKCalendar) -> Bool {
            if calendar.calendarIdentifier == calendarIdentifier {
                return true
            }
            
            if calendar.title == title && calendar.source?.sourceIdentifier == sourceIdentifier {
                return true
            }
            
            return false
        }
    }
    
    private struct Keys: RawRepresentable {
        var rawValue: String
        
        static let storedCalendars = Keys(rawValue: "Stored Calendars")
    }
    
    private var storedCalendars: [StoreableCalendar] {
        get {
            guard let data = UserDefaults(suiteName: appGroup)?.data(forKey: Keys.storedCalendars.rawValue) else {
                return []
            }
            
            do {
                let decoder = JSONDecoder()
                return try decoder.decode([StoreableCalendar].self, from: data)
            } catch let error {
                print("got error: \(error)")
                return []
            }
        }
        set {
            
        }
    }
    
    var calendars: [EKCalendar] {
        get {
            let storedCalendars = self.storedCalendars
            return eventStore.calendars(for: .event).filter { calendar in
                return storedCalendars.contains(where: { storedCalendar in
                    return storedCalendar.matches(calendar)
                })
            }
        }
        
        set {
            do {
                let storeableCalendars = newValue.map { StoreableCalendar(calendar: $0) }
                
                let jsonEncoder = JSONEncoder()
                let data = try jsonEncoder.encode(storeableCalendars)
                UserDefaults(suiteName: appGroup)?.set(data, forKey: Keys.storedCalendars.rawValue)
            } catch let error {
                print("got error: \(error)")
            }
        }
    }
}
