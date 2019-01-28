//
//  RoomParser.swift
//  Shared
//
//  Created by Zac West on 1/20/19.
//  Copyright © 2019 Zac West. All rights reserved.
//

import Foundation
import EventKit

public class RoomParser {
    let settings: Settings
    
    public struct Options: OptionSet {
        public let rawValue: Int
        public init(rawValue: Int) { self.rawValue = rawValue }
        
        public static let includeTomorrowEvents = Options(rawValue: 0b1)
        public static let includePastEvents = Options(rawValue: 0b10)
        public static let excludeAllDayEvents = Options(rawValue: 0b100)
    }
    
    public init(settings: Settings) {
        self.settings = settings
    }
    
    public func findRooms(options: Options = [], completion: @escaping ([Room]) -> Void) {
        let settings = self.settings
        
        guard EKEventStore.authorizationStatus(for: .event) == .authorized else {
            completion([])
            return
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            let nsCalendar = Calendar.current
            
            let startDate: Date
            
            if options.contains(.includePastEvents) {
                startDate = nsCalendar.startOfDay(for: Date())
            } else {
                startDate = Date()
            }
            
            let endDate = nsCalendar.date(byAdding: with(DateComponents()) {
                if options.contains(.includeTomorrowEvents) {
                    $0.day = 2
                } else {
                    $0.day = 1
                }
                $0.second = -1
            }, to: nsCalendar.startOfDay(for: startDate))!
            
            //
            
            let officeName = settings.officeName?.rawValue ?? "SFO"
            let officeNames = Settings.OfficeName.allCases.map { NSRegularExpression.escapedPattern(for: $0.rawValue) }.joined(separator: "|")
            
            guard let regularExpression = try? NSRegularExpression(
                pattern: "(?<city>(?:\(officeName)))[-\\s]+(?<building>[^-]+)[-\\s]+[^\\d]*(?<room>\\d+)\\s+\\((?<count>\\d+)\\)\\s+(?<name>(?:(?!\(officeNames)|\\(VC\\)|\\(AV\\)).)+)",
                options: [.useUnicodeWordBoundaries]
            ) else {
                DispatchQueue.main.async {
                    completion([])
                }
                return
            }
            
            let rooms =
                settings.eventStore.events(matching: settings.eventStore.predicateForEvents(
                    withStart: startDate,
                    end: endDate,
                    calendars: settings.calendars
                )).compactMap { (event: EKEvent) -> Room? in
                    if options.contains(.excludeAllDayEvents), event.isAllDay {
                        return nil
                    }
                    
                    if let attendee = event.attendees?.first(where: { $0.isCurrentUser }), attendee.participantStatus == .declined {
                        return nil
                    }
                    
                    return RoomParser.room(for: event, regularExpression: regularExpression)
                }.sorted()
            
            DispatchQueue.main.async {
                completion(rooms)
            }
        }
    }
    
    class func room(for event: EKEvent, regularExpression: NSRegularExpression) -> Room {
        guard let locations = event.location else {
            return Room(event: event)
        }

        let room = regularExpression.firstMatch(
            in: locations,
            options: [],
            range: NSRange(location: 0, length: locations.utf16.count)
        ).flatMap { (result: NSTextCheckingResult) -> Room? in
            func string(from name: String) -> String? {
                let range = result.range(withName: name)
                
                if range.location == NSNotFound {
                    return nil
                }

                return (locations as NSString).substring(with: range)
            }
            
            guard
                let city = string(from: "city"),
                let building = string(from: "building"),
                let roomNumber = string(from: "room"),
                let count = string(from: "count"),
                let name = string(from: "name")
            else {
                return nil
            }

            var zoomURL: URL?
            
            if let dataDetector = try? NSDataDetector(types: NSTextCheckingTypes(NSTextCheckingResult.CheckingType.link.rawValue)) {
                let possibleURLs = (event.location ?? "") + (event.notes ?? "")
                dataDetector.enumerateMatches(in: possibleURLs, options: [], range: NSRange(location: 0, length: possibleURLs.utf16.count), using: { result, _, stop in
                    guard let url = result?.url else {
                        return
                    }
                    
                    if url.host?.contains("zoom.us") == true {
                        stop[0] = true
                        zoomURL = url
                    }
                })
            }
            
            return Room(event: event, city: city, building: building, roomNumber: roomNumber, count: count, name: name, zoomURL: zoomURL)
        }
        
        return room ?? Room(event: event)
    }
}
