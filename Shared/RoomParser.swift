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
    
    public init(settings: Settings) {
        self.settings = settings
    }
    
    public func findRooms(completion: @escaping ([Room]) -> Void) {
        let settings = self.settings
        
        DispatchQueue.global(qos: .userInitiated).async {
            let nsCalendar = Calendar.current
            let startDate = Date()
            let endDate = nsCalendar.date(
                byAdding: with(DateComponents()) {
                    $0.day = 1
                    $0.second = -1
                },
                to: nsCalendar.startOfDay(for: startDate)
            )!
            
            //
            guard let regularExpression = try? NSRegularExpression(
                pattern: "(\\(.+?\\)\\s)*(?<city>\\w+) (?<building>[^-]+) - [^\\d]*(?<room>\\d+) \\((?<count>\\d+)\\) (?<name>.*)?( \\(VC\\))?",
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
                )).compactMap { RoomParser.room(for: $0, regularExpression: regularExpression, settings: settings) }
            
            DispatchQueue.main.async {
                completion(rooms)
            }
        }
    }
    
    class func room(for event: EKEvent, regularExpression: NSRegularExpression, settings: Settings) -> Room? {
        guard let locations = event.location?.split(separator: ",") else { return nil }
        
        return locations.lazy.compactMap { (locationSubstring: Substring) -> Room? in
            let location = String(locationSubstring)
            
            var correctRoom: Room?
            
            guard let result = regularExpression.firstMatch(in: location, options: [], range: NSRange(location: 0, length: location.utf16.count)) else {
                return nil
            }

            func string(from name: String) -> String? {
                let range = result.range(withName: name)
                
                if range.location == NSNotFound {
                    return nil
                }
                
                return (location as NSString).substring(with: range)
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
            
            guard city.lowercased() == settings.officeName.rawValue.lowercased() else {
                return nil
            }
            
            return Room(event: event, city: city, building: building, roomNumber: roomNumber, count: count, name: name)
        }.first
    }
}
