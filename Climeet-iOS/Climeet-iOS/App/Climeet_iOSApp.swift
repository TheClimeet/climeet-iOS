//
//  Climeet_iOSApp.swift
//  Climeet-iOS
//
//  Created by Hisop on 2024/04/18.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem
import NetworkKit

@main
struct ClimeetiOSApp: App {
    
    init() {
        KeyChain.shared.refreshToken = Env.MASTER_TOKEN // 테스트 값 설정
//        print(KeyChain.shared.refreshToken) // 값 읽어오기
//        KeyChain.shared.deleteRefreshToken() // 리프레시 토큰 초기화(테스트메서드)
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
