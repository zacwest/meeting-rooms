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
    internal let city: String?
    internal let building: String?
    internal let roomNumber: String?
    internal let count: String?
    internal let name: String?
    public let zoomURL: URL?
    
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
        self.init(event: event, city: nil, building: nil, roomNumber: nil, count: nil, name: nil, zoomURL: nil)
    }
    
    internal init(event: EKEvent, city: String?, building: String?, roomNumber: String?, count: String?, name: String?, zoomURL: URL?) {
        self.event = event
        self.city = city
        self.building = building
        self.roomNumber = roomNumber
        self.count = count
        self.name = name
        self.zoomURL = zoomURL
    }
    
    public var isPastEvent: Bool {
        return event.endDate < Date()
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
        if let roomNumber = roomNumber, let name = name {
            return [
                roomNumber,
                name,
            ].joined(separator: " ")
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
