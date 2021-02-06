//
//  Extensions+Date.swift
//  TinderDemo
//
//  Created by Andrei Volkau on 22.07.2020.
//  Copyright © 2020 Andrei Volkau. All rights reserved.
//

import Foundation

extension Date {
    func timeAgoDisplay() -> String {
        
        if #available(iOS 13, *) {
            let formatter = RelativeDateTimeFormatter()
            formatter.unitsStyle = .full
            return formatter.localizedString(for: self, relativeTo: Date())
        }
        else {
            let secondsAgo = Int(Date().timeIntervalSince(self))
            
            let minute = 60
            let hour = minute * 60
            let day = 24 * hour
            let week = 7 * day
            let month = 4 * week
            
            let quotient: Int
            let unit: String
            
            if secondsAgo < minute {
                quotient = secondsAgo
                unit = "second"
            } else if secondsAgo < hour {
                quotient = secondsAgo / minute
                unit = "minute"
            } else if secondsAgo < day {
                quotient = secondsAgo / hour
                unit = "hour"
            } else if secondsAgo < week {
                quotient = secondsAgo / day
                unit = "day"
            } else if secondsAgo < month {
                quotient = secondsAgo / week
                unit = "week"
            } else {
                quotient = secondsAgo / month
                unit = "month"
            }
            
            return "\(quotient) \(unit)\(quotient == 1 ? "" : "s") ago"
        }
    }
}




