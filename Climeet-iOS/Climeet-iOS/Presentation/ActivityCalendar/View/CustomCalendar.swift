//
//  CustomCalendar.swift
//  Climeet-iOS
//
//  Created by KOVI on 6/16/24.
//

import SwiftUI
import DesignSystem

struct CustomCalendar: View {
    
    @Binding var selectedMonth: Int
    @Binding var tappedDate: CalendarDate
    var calendarTitleTappedAction: () -> Void
    
    @State private var selectedDate = Date()
    private let days = ["일", "월", "화", "수", "목", "금", "토"]
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    withAnimation {
                        selectedMonth -= 1
                    }
                } label: {
                    Image(uiImage: UIImage(named: "calendar_left") ?? UIImage())
                }
                
                Spacer()
                
                Button {
                    calendarTitleTappedAction()
                } label: {
                    Text("\(fetchYearAndMonth())")
                        .font(.climeetFontTitle3())
                        .foregroundColor(Color.levelWhite)
                }
                
                Spacer()
                
                Button {
                    withAnimation {
                        selectedMonth += 1
                    }
                } label: {
                    Image(uiImage: UIImage(named: "calendar_right") ?? UIImage())
                }
            }
            .padding(.top, 29)
            .padding(.horizontal, 27)
            
            HStack {
                ForEach(days, id: \.self) { day in
                    Text(day)
                        .font(.climeetFontParagraph1())
                        .foregroundColor(Color.levelWhite)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.top, 27)
            .padding()
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 10) {
                ForEach(fetchDates()) { value in
                    if value.day != -1 {
                        VStack {
                            Button(action: {
                                tappedDate = value
                            }, label: {
                                Rectangle()
                                    .frame(width: 36, height: 36)
                                    .cornerRadius(5)
                                    .foregroundColor(
                                        tappedDate.day == value.day ? .text05 : .text08
                                    )
                            })
                            
                            ZStack {
                                if value.date.string() == tappedDate.date.string() {
                                    Rectangle()
                                        .fill(Color.climeetMain)
                                        .frame(width: 29, height: 15)
                                        .cornerRadius(3)
                                    
                                    Text("\(value.day)")
                                        .font(.climeetFontParagraph4())
                                        .foregroundColor(Color.levelBlack)
                                } else {
                                    Text("\(value.day)")
                                        .font(.climeetFontParagraph6())
                                        .foregroundColor(
                                            value.date.string() == Date().string() ? .climeetMain : .text06
                                        )
                                }
                            }
                        }
                    } else {
                        Text("")
                    }
                }
            }
            .padding()
            
        }
        .onAppear {
            selectedDate = fetchSelectedMonth()
        }
        .onChange(of: selectedMonth, { _, _ in
            selectedDate = fetchSelectedMonth()
        })
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.text09)
    }
    
    // MARK: Private
    
    private func fetchDates() -> [CalendarDate] {
        let calendar = Calendar.current
        let currentMonth = fetchSelectedMonth()
        var dates = currentMonth.datesOfMonth().map {
            CalendarDate(day: calendar.component(.day, from: $0), date: $0)
        }
        
        let firstDayOfWeek = calendar.component(.weekday, from: dates.first?.date ?? Date())
        
        for _ in 0..<firstDayOfWeek - 1 {
            dates.insert(CalendarDate(day: -1, date: Date()), at: 0)
        }
        
        return dates
    }
    
    private func fetchSelectedMonth() -> Date {
        let calendar = Calendar.current
        guard let month = calendar.date(byAdding: .month, value: selectedMonth, to: Date()) else {
            Log.error("Calendar Error: Could not create date for month: \(selectedMonth)")
            return Date()
        }
        
        return month
    }
    
    private func fetchYearAndMonth() -> String {
        return DateFormatter.yearPointMonthFormatter.string(from: selectedDate)
    }
}
