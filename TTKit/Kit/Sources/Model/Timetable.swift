//
//  Timetable.swift
//  TTKit
//
//  Created by Vasyl Myronchuk on 08/02/2019.
//  Copyright © 2019 Vasyl Myronchuk. All rights reserved.
//

import Foundation

public struct TimeEntry {
    public let hour: String
    public let minutes: [String]
}

public struct Timetable {
    public let entries: [TimeEntry]
}

// MARK: -

public extension Timetable {
    static func createFromResponse(_ timetableResponse: TimetableResponse) -> Timetable {
        var hourToMinutes = [String: [String]]()

        for items in timetableResponse.result {
            for item in items.values {
                guard item.key == "czas" else { continue }

                let timeElements = item.value.split(separator: ":")
                guard timeElements.count > 1 else {
                    print("Broken entry: {\(item.key) : \(item.value)}")
                    continue
                }

                let hour = String(timeElements[0])
                let minutes = String(timeElements[1])

                var allMinutes = hourToMinutes[hour] ?? [String]()
                allMinutes.append(minutes)
                hourToMinutes[hour] = allMinutes
            }
        }

        var entries = [TimeEntry]()
        for hour in hourToMinutes.keys.sorted() {
            let entry = TimeEntry(hour: hour, minutes: hourToMinutes[hour]!)
            entries.append(entry)
        }

        return Timetable(entries: entries)
    }
}
