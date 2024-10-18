//
//  DateFormatter + .swift
//  Climeet-iOS
//
//  Created by KOVI on 6/12/24.
//

import Foundation

extension DateFormatter {
    
    // MARK: 오후 1:12
    static let koreanHourMinuteFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "a h:mm"
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter
    }()
    
    // MARK: 2023년 12월 12일 (화)
    static let koreanFullDateWithDayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일 (E)"
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter
    }()
    
    // MARK: AM 9:00
    static let amTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "a h:mm"
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        formatter.locale = Locale(identifier: "en_US_POSIX")  // AM/PM 표기를 위해 영어 로케일 사용
        return formatter
    }()
    
    // MARK: 2023.12
    static let yearPointMonthFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM"
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter
    }()
}
