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
    
    public var timeTitle: String {
        if event.isAllDay {
            return NSLocalizedString("All Day", comment: "")
        }
        
        return Room.formatter.string(from: event.startDate, to: event.endDate)
    }
    
    public var roomTitle: String {
        if let roomNumber = roomNumber, let name = name {
            return [
                roomNumber,
                name,
            ]
                .joined(separator: " ")
                .replacingOccurrences(of: " (VC)", with: "")
        } else if let location = event.location {
            return String(format: NSLocalizedString("IDK: %@", comment: ""), location)
        } else {
            return NSLocalizedString("No Room", comment: "")
        }
    }
    
    public var eventTitle: String {
        return event.title
    }
}
