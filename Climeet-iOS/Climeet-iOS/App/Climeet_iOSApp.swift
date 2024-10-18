//
//  Climeet_iOSApp.swift
//  Climeet-iOS
//
//  Created by Hisop on 2024/04/18.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem

@main
struct ClimeetiOSApp: App {
    
    init() {
        applyGlobalNavigationTitleAttributes()
    }
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
    }
    
    func applyGlobalNavigationTitleAttributes() {
        UINavigationBar.appearance().titleTextAttributes = [
            .foregroundColor: UIColor(.levelWhite),
//            .font: UIFont(name: "Pretendard-Bold", size: 18)!
            // Font.climeetFontTitle4 해당함
        ]
    }
}
