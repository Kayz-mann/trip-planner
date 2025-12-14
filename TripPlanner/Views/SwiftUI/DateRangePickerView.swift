//
//  DateRangePickerView.swift
//  TripPlanner
//
//  Created by Balogun Kayode on 13/12/2025.
//

import SwiftUI

struct DateRangePickerView: View {
    @Binding var startDate: Date?
    @Binding var endDate: Date?
    @Binding var isPresented: Bool
    
    @State private var selectedStartDate: Date?
    @State private var selectedEndDate: Date?
    @State private var currentMonth: Date = Date()
    
    private let calendar = Calendar.current
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header with close button
                HStack {
                    Button(action: {
                        isPresented = false
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.primaryText)
                    }
                    
                    Spacer()
                    
                    Text("Date")
                        .font(.appFont(style: .b2SemiBold))
                        .foregroundColor(.primaryText)
                    
                    Spacer()
                    
                    // Balance the X button
                    Color.clear
                        .frame(width: 44)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                
                // Calendar views
                ScrollView {
                    VStack(spacing: 32) {
                        // Start Date Calendar
                        CalendarMonthView(
                            month: currentMonth,
                            selectedStartDate: $selectedStartDate,
                            selectedEndDate: $selectedEndDate
                        )
                        
                        // End Date Calendar (next month)
                        CalendarMonthView(
                            month: calendar.date(byAdding: .month, value: 1, to: currentMonth) ?? currentMonth,
                            selectedStartDate: $selectedStartDate,
                            selectedEndDate: $selectedEndDate
                        )
                    }
                    .padding(.vertical, 20)
                }
                
                // Date input fields
                VStack(spacing: 16) {
                    // Start Date field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Start Date")
                            .font(.appFont(style: .b3Medium))
                            .foregroundColor(.primaryText)
                        
                        HStack {
                            Text(formatDate(selectedStartDate))
                                .font(.appFont(style: .b3Medium))
                                .foregroundColor(selectedStartDate == nil ? .tertiaryText : .primaryText)
                            
                            Spacer()
                            
                            Image(systemName: "calendar")
                                .font(.system(size: 16))
                                .foregroundColor(.tertiaryText)
                        }
                        .padding(16)
                        .background(Color.appWhite)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                        )
                    }
                    
                    // End Date field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("End Date")
                            .font(.appFont(style: .b3Medium))
                            .foregroundColor(.primaryText)
                        
                        HStack {
                            Text(formatDate(selectedEndDate))
                                .font(.appFont(style: .b3Medium))
                                .foregroundColor(selectedEndDate == nil ? .tertiaryText : .primaryText)
                            
                            Spacer()
                            
                            Image(systemName: "calendar")
                                .font(.system(size: 16))
                                .foregroundColor(.tertiaryText)
                        }
                        .padding(16)
                        .background(Color.appWhite)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                        )
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 20)
                .background(Color.lightBackground)
                
                // Choose Date button
                Button(action: {
                    startDate = selectedStartDate
                    endDate = selectedEndDate
                    isPresented = false
                }) {
                    Text("Choose Date")
                        .font(.appFont(style: .b3SemiBold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.primaryBlue)
                        .cornerRadius(8)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
            .background(Color.lightBackground)
            .navigationBarHidden(true)
        }
        .onAppear {
            selectedStartDate = startDate
            selectedEndDate = endDate
        }
    }
    
    private func formatDate(_ date: Date?) -> String {
        guard let date = date else {
            return "Select Date"
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, MMM d"
        return formatter.string(from: date)
    }
}

struct CalendarMonthView: View {
    let month: Date
    @Binding var selectedStartDate: Date?
    @Binding var selectedEndDate: Date?
    
    private let calendar = Calendar.current
    private let weekdays = ["Mo", "Tu", "We", "Th", "Fr", "Sa", "Su"]
    
    private var monthYear: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: month)
    }
    
    private var daysInMonth: [Date?] {
        guard let range = calendar.range(of: .day, in: .month, for: month),
              let firstDay = calendar.date(from: calendar.dateComponents([.year, .month], from: month)) else {
            return []
        }
        
        let firstWeekday = calendar.component(.weekday, from: firstDay)
        let adjustedFirstWeekday = (firstWeekday + 5) % 7 // Convert to Monday = 0
        
        var days: [Date?] = []
        
        // Add previous month's days
        for _ in 0..<adjustedFirstWeekday {
            days.append(nil)
        }
        
        // Add current month's days
        for day in range {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: firstDay) {
                days.append(date)
            }
        }
        
        // Add next month's days to fill the grid
        let remaining = 42 - days.count
        for _ in 0..<remaining {
            days.append(nil)
        }
        
        return days
    }
    
    var body: some View {
        VStack(spacing: 16) {
            // Month header
            Text(monthYear)
                .font(.appFont(style: .b2SemiBold))
                .foregroundColor(.primaryText)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
            
            // Weekday headers
            HStack(spacing: 0) {
                ForEach(weekdays, id: \.self) { weekday in
                    Text(weekday)
                        .font(.appFont(style: .b4Medium))
                        .foregroundColor(.tertiaryText)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal, 20)
            
            // Calendar grid
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
                ForEach(0..<42, id: \.self) { index in
                    if let date = daysInMonth[index] {
                        let isSelected = date == selectedStartDate || date == selectedEndDate
                        let isInRange = isDateInRange(date)
                        let isToday = calendar.isDateInToday(date)
                        
                        Button(action: {
                            if selectedStartDate == nil {
                                // First selection - set as start date
                                selectedStartDate = date
                                selectedEndDate = nil
                            } else if let start = selectedStartDate, selectedEndDate == nil {
                                // Second selection - set as end date if after start, otherwise swap
                                if date >= start {
                                    selectedEndDate = date
                                } else {
                                    selectedEndDate = selectedStartDate
                                    selectedStartDate = date
                                }
                            } else {
                                // Reset and start new selection
                                selectedStartDate = date
                                selectedEndDate = nil
                            }
                        }) {
                            Text("\(calendar.component(.day, from: date))")
                                .font(.appFont(style: .b3Medium))
                                .foregroundColor(isSelected ? .white : (isInRange ? .primaryBlue : .primaryText))
                                .frame(width: 40, height: 40)
                                .background(
                                    isSelected ? Color.primaryBlue :
                                    (isInRange ? Color.primaryBlue.opacity(0.1) : Color.clear)
                                )
                                .cornerRadius(8)
                        }
                    } else {
                        // Previous/next month day
                        Text("")
                            .frame(width: 40, height: 40)
                    }
                }
            }
            .padding(.horizontal, 20)
        }
    }
    
    private func isDateInRange(_ date: Date) -> Bool {
        guard let start = selectedStartDate, let end = selectedEndDate else {
            return false
        }
        return date >= start && date <= end
    }
}

#Preview {
    DateRangePickerView(
        startDate: .constant(nil),
        endDate: .constant(nil),
        isPresented: .constant(true)
    )
}

