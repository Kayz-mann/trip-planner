//
//  DateHelperTests.swift
//  TripPlannerTests
//
//  Created by Balogun Kayode on 14/12/2025.
//

import Testing
import Foundation
@testable import TripPlanner

struct DateHelperTests {
    
    // MARK: - daysBetween Edge Cases
    
    @Test("Same day should return 1 day (inclusive)")
    func testDaysBetweenSameDay() {
        let calendar = Calendar.current
        let date = Date()
        let result = DateHelper.daysBetween(date, date)
        #expect(result == 1)
    }
    
    @Test("Consecutive days should return 2 days")
    func testDaysBetweenConsecutiveDays() {
        let calendar = Calendar.current
        let start = calendar.date(from: DateComponents(year: 2024, month: 4, day: 19))!
        let end = calendar.date(from: DateComponents(year: 2024, month: 4, day: 20))!
        let result = DateHelper.daysBetween(start, end)
        #expect(result == 2)
    }
    
    @Test("Start date after end date should still return positive value")
    func testDaysBetweenReversedDates() {
        let calendar = Calendar.current
        let start = calendar.date(from: DateComponents(year: 2024, month: 4, day: 24))!
        let end = calendar.date(from: DateComponents(year: 2024, month: 4, day: 19))!
        let result = DateHelper.daysBetween(start, end)
        #expect(result == 6) // 19, 20, 21, 22, 23, 24 = 6 days
    }
    
    @Test("Cross month boundary should calculate correctly")
    func testDaysBetweenCrossMonth() {
        let calendar = Calendar.current
        let start = calendar.date(from: DateComponents(year: 2024, month: 4, day: 28))!
        let end = calendar.date(from: DateComponents(year: 2024, month: 5, day: 3))!
        let result = DateHelper.daysBetween(start, end)
        #expect(result == 6) // 28, 29, 30 Apr, 1, 2, 3 May = 6 days
    }
    
    @Test("Cross year boundary should calculate correctly")
    func testDaysBetweenCrossYear() {
        let calendar = Calendar.current
        let start = calendar.date(from: DateComponents(year: 2024, month: 12, day: 30))!
        let end = calendar.date(from: DateComponents(year: 2025, month: 1, day: 2))!
        let result = DateHelper.daysBetween(start, end)
        #expect(result == 4) // 30, 31 Dec, 1, 2 Jan = 4 days
    }
    
    @Test("Leap year February should handle correctly")
    func testDaysBetweenLeapYear() {
        let calendar = Calendar.current
        let start = calendar.date(from: DateComponents(year: 2024, month: 2, day: 28))!
        let end = calendar.date(from: DateComponents(year: 2024, month: 3, day: 1))!
        let result = DateHelper.daysBetween(start, end)
        #expect(result == 3) // 28, 29 Feb (leap), 1 Mar = 3 days
    }
    
    @Test("Long duration trip (30 days) should calculate correctly")
    func testDaysBetweenLongDuration() {
        let calendar = Calendar.current
        let start = calendar.date(from: DateComponents(year: 2024, month: 4, day: 1))!
        let end = calendar.date(from: DateComponents(year: 2024, month: 4, day: 30))!
        let result = DateHelper.daysBetween(start, end)
        #expect(result == 30)
    }
    
    // MARK: - formatDateForTrip Edge Cases
    
    @Test("1st day should have 'st' suffix")
    func testFormatDateFirstDay() {
        let calendar = Calendar.current
        let date = calendar.date(from: DateComponents(year: 2024, month: 4, day: 1))!
        let result = DateHelper.formatDateForTrip(date)
        #expect(result.contains("1st"))
    }
    
    @Test("2nd day should have 'nd' suffix")
    func testFormatDateSecondDay() {
        let calendar = Calendar.current
        let date = calendar.date(from: DateComponents(year: 2024, month: 4, day: 2))!
        let result = DateHelper.formatDateForTrip(date)
        #expect(result.contains("2nd"))
    }
    
    @Test("3rd day should have 'rd' suffix")
    func testFormatDateThirdDay() {
        let calendar = Calendar.current
        let date = calendar.date(from: DateComponents(year: 2024, month: 4, day: 3))!
        let result = DateHelper.formatDateForTrip(date)
        #expect(result.contains("3rd"))
    }
    
    @Test("4th day should have 'th' suffix")
    func testFormatDateFourthDay() {
        let calendar = Calendar.current
        let date = calendar.date(from: DateComponents(year: 2024, month: 4, day: 4))!
        let result = DateHelper.formatDateForTrip(date)
        #expect(result.contains("4th"))
    }
    
    @Test("21st day should have 'st' suffix")
    func testFormatDateTwentyFirst() {
        let calendar = Calendar.current
        let date = calendar.date(from: DateComponents(year: 2024, month: 4, day: 21))!
        let result = DateHelper.formatDateForTrip(date)
        #expect(result.contains("21st"))
    }
    
    @Test("22nd day should have 'nd' suffix")
    func testFormatDateTwentySecond() {
        let calendar = Calendar.current
        let date = calendar.date(from: DateComponents(year: 2024, month: 4, day: 22))!
        let result = DateHelper.formatDateForTrip(date)
        #expect(result.contains("22nd"))
    }
    
    @Test("23rd day should have 'rd' suffix")
    func testFormatDateTwentyThird() {
        let calendar = Calendar.current
        let date = calendar.date(from: DateComponents(year: 2024, month: 4, day: 23))!
        let result = DateHelper.formatDateForTrip(date)
        #expect(result.contains("23rd"))
    }
    
    @Test("31st day should have 'st' suffix")
    func testFormatDateThirtyFirst() {
        let calendar = Calendar.current
        let date = calendar.date(from: DateComponents(year: 2024, month: 4, day: 31))!
        let result = DateHelper.formatDateForTrip(date)
        #expect(result.contains("31st"))
    }
    
    @Test("Format should include full month name")
    func testFormatDateIncludesMonth() {
        let calendar = Calendar.current
        let date = calendar.date(from: DateComponents(year: 2024, month: 4, day: 19))!
        let result = DateHelper.formatDateForTrip(date)
        #expect(result.contains("April"))
    }
    
    @Test("Format should include year")
    func testFormatDateIncludesYear() {
        let calendar = Calendar.current
        let date = calendar.date(from: DateComponents(year: 2024, month: 4, day: 19))!
        let result = DateHelper.formatDateForTrip(date)
        #expect(result.contains("2024"))
    }
    
    @Test("Format should match expected pattern")
    func testFormatDatePattern() {
        let calendar = Calendar.current
        let date = calendar.date(from: DateComponents(year: 2024, month: 4, day: 19))!
        let result = DateHelper.formatDateForTrip(date)
        // Should match pattern like "19th April 2024"
        let pattern = #"^\d{1,2}(st|nd|rd|th) [A-Za-z]+ \d{4}$"#
        let regex = try? NSRegularExpression(pattern: pattern)
        let range = NSRange(location: 0, length: result.utf16.count)
        let matches = regex?.firstMatch(in: result, range: range)
        #expect(matches != nil)
    }
}

