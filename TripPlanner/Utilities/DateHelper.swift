//
//  DateHelper.swift
//  TripPlanner
//
//  Created by Balogun Kayode on 13/12/2025.
//

import Foundation

struct DateHelper {
    /// Calculates the number of days between two dates (inclusive - includes both start and end date)
    static func daysBetween(_ startDate: Date, _ endDate: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: startDate, to: endDate)
        // Add 1 to make it inclusive (e.g., if start and end are same day, it's 1 day)
        return abs((components.day ?? 0) + 1)
    }
    
    /// Formats a Date to the string format used in Trip model (e.g., "19th April 2024")
    static func formatDateForTrip(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM yyyy"
        let dateString = formatter.string(from: date)
        
        // Add ordinal suffix (st, nd, rd, th)
        let day = Calendar.current.component(.day, from: date)
        let suffix: String
        switch day {
        case 1, 21, 31: suffix = "st"
        case 2, 22: suffix = "nd"
        case 3, 23: suffix = "rd"
        default: suffix = "th"
        }
        
        return dateString.replacingOccurrences(of: "\(day) ", with: "\(day)\(suffix) ")
    }
}

