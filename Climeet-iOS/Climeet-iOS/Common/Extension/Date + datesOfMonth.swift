//
//  Date + datesOfMonth.swift
//  Climeet-iOS
//
//  Created by KOVI on 6/17/24.
//

import Foundation

extension Date {
    func datesOfMonth() -> [Date] {
        let calendar = Calendar.current
        let currentMonth = calendar.component(.month, from: self)
        let currentYear = calendar.component(.year, from: self)
        
        var startDateComponents = DateComponents()
        startDateComponents.year = currentYear
        startDateComponents.month = currentMonth
        startDateComponents.day = 1
        
        guard let startDate = calendar.date(from: startDateComponents) else {
            Log.error("Calendar Error:", "date(from:) failed")
            return []
        }
        
        var endDateComponents = DateComponents()
        endDateComponents.month = 1
        endDateComponents.day = -1
        
        guard let endDate = calendar.date(byAdding: endDateComponents, to: startDate) else {
            Log.error("Calendar Error:", "date(byAdding:, to:) failed")
            return []
        }
        
        var dates: [Date] = []
        var currentDate = startDate
        
        while currentDate <= endDate {
            dates.append(currentDate)
            guard let nextDate = calendar.date(byAdding: .day, value: 1, to: currentDate) else {
                Log.error("Calendar Error:", "date(byAdding:, value:, to:) failed")
                break
            }
            currentDate = nextDate
        }
        
        return dates
    }
    
    func string() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        
        return formatter.string(from: self)
    }
}
