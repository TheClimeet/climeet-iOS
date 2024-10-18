//
//  CalendarDate.swift
//  Climeet-iOS
//
//  Created by KOVI on 6/16/24.
//

import Foundation

struct CalendarDate: Identifiable {
    let id = UUID()
    var day: Int
    var date: Date
    
    init(
        day: Int = .zero,
        date: Date = Date()
    ) {
        self.day = day
        self.date = date
    }
}
