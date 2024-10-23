//
//  Climeet_iOSApp.swift
//  Climeet-iOS
//
//  Created by Hisop on 2024/04/18.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem
import KakaoSDKCommon
import KakaoSDKAuth
import NaverThirdPartyLogin

@main
struct ClimeetiOSApp: App {
    
    init() {
        applyGlobalNavigationTitleAttributes()
        KakaoSDK.initSDK(appKey: Env.KAKAO_APP_KEY)
        initNaver()
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
    
    private func initNaver() {
        let instance = NaverThirdPartyLoginConnection.getSharedInstance()
        // 네이버 앱으로 로그인 허용
        instance?.isNaverAppOauthEnable = true
        // 브라우저 로그인 허용
        instance?.isInAppOauthEnable = true
        
        // 네이버 로그인 세로모드 고정
        instance?.setOnlyPortraitSupportInIphone(true)
        
        // NaverThirdPartyConstantsForApp.h에 선언한 상수 등록
        instance?.serviceUrlScheme = "Swift.Climeet.Climeet-iOS"
        instance?.consumerKey = Env.NAVER_CLIENT_ID
        instance?.consumerSecret = Env.NAVER_CLIENT_SECRET
        instance?.appName = "Climeet"
    }
}
