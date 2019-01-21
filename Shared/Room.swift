//
//  Room.swift
//  Shared
//
//  Created by Zac West on 1/20/19.
//  Copyright © 2019 Zac West. All rights reserved.
//

import Foundation
import EventKit

public struct Room: Equatable {
    internal let event: EKEvent
    internal let city: String
    internal let building: String
    internal let roomNumber: String
    internal let count: String
    internal let name: String
    
    public static func == (lhs: Room, rhs: Room) -> Bool {
        return lhs.roomNumber == rhs.roomNumber && lhs.event.eventIdentifier == rhs.event.eventIdentifier
    }
    
    static internal var formatter = with(DateIntervalFormatter()) {
        $0.dateStyle = .none
        $0.timeStyle = .medium
    }
    
    public var timeTitle: String {
        if event.isAllDay {
            return NSLocalizedString("All Day", comment: "")
        }
        
        let nowDate = Date()
        
        if event.startDate < nowDate && event.endDate > nowDate {
            return NSLocalizedString("Now", comment: "")
        }
        
        return Room.formatter.string(from: event.startDate, to: event.endDate)
    }
    
    public var roomTitle: String {
        return [
            roomNumber,
            name,
        ].joined(separator: " ")
    }
    
    public var eventTitle: String {
        return event.title
    }
}
