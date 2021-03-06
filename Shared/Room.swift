//
//  Room.swift
//  Shared
//
//  Created by Zac West on 1/20/19.
//  Copyright © 2019 Zac West. All rights reserved.
//

import Foundation
import EventKit

public struct Room: Equatable, Comparable {
    public let event: EKEvent
    internal var city: String?
    internal var building: String?
    internal var roomNumber: String?
    internal var count: String?
    internal var name: String?
    internal(set) public var zoomURL: URL?
    
    public static func == (lhs: Room, rhs: Room) -> Bool {
        return lhs.roomNumber == rhs.roomNumber && lhs.event.eventIdentifier == rhs.event.eventIdentifier
    }
    
    public static func < (lhs: Room, rhs: Room) -> Bool {
        if lhs.isAllDayEvent && !rhs.isAllDayEvent {
            return false
        }
        
        if !lhs.isAllDayEvent && rhs.isAllDayEvent {
            return true
        }
        
        return lhs.event.startDate < rhs.event.startDate
    }
    
    static internal var formatter = with(DateIntervalFormatter()) {
        $0.dateStyle = .none
        $0.timeStyle = .short
    }
    
    internal init(event: EKEvent) {
        self.event = event
    }
    
    public var isPastEvent: Bool {
        return event.endDate < Date()
    }
    
    public var isTomorrow: Bool {
        let calendar = NSCalendar.current
        return calendar.startOfDay(for: event.startDate) > calendar.startOfDay(for: Date())
    }
    
    public var isAllDayEvent: Bool {
        return event.isAllDay
    }
    
    public var timeTitle: String {
        if event.isAllDay {
            return NSLocalizedString("All Day", comment: "")
        }
        
        return Room.formatter.string(from: event.startDate, to: event.endDate)
    }
    
    public var roomTitle: String? {
        var components: [String] = []
        
        if let roomNumber = roomNumber {
            components.append(roomNumber)
        }
        
        if let name = name {
            components.append(name)
        }
        
        if !components.isEmpty {
            return components.joined(separator: " ")
        } else if let location = event.location, location.isEmpty == false {
            return location
        } else {
            return nil
        }
    }
    
    public var eventTitle: String? {
        if let title = event.title, title.isEmpty == false {
            return title
        } else {
            return nil
        }
    }
}
