//
//  SheetType.swift
//  Climeet-iOS
//
//  Created by KOVI on 6/12/24.
//

import Foundation

enum SheetType {
    case datePicker
    case timePicker
    case search
    
    var displaySizeRatio: CGFloat {
        switch self {
        case .datePicker:
            return 0.60
        case .timePicker:
            return 0.65
        case .search:
            return 0.71
        }
    }
}
