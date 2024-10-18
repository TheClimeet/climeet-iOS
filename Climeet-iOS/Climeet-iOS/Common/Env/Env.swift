//
//  Env.swift
//  Climeet-iOS
//
//  Created by 송형욱 on 9/15/24.
//

import Foundation

public enum Env {
    // MARK: - Keys
    enum Keys {
        enum Plist {
            static let KAKAO_APP_KEY = "KAKAO_APP_KEY"
            static let BASE_URL = "BASE_URL"
            static let NAVER_CLIENT_ID = "NAVER_CLIENT_ID"
            static let NAVER_CLIENT_SECRET = "NAVER_CLIENT_SECRET"
            static let CLIMBER_TOKEN = "CLIMBER_TOKEN"
            static let MASTER_TOKEN = "MASTER_TOKEN"
        }
    }

    // MARK: - Plist
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("Plist file not found")
        }
        return dict
    }()
}

extension Env {
    
    // MARK: - Plist values
    
    public static let KAKAO_APP_KEY: String = {
        guard let kakaoAppKey = Env.infoDictionary[Keys.Plist.KAKAO_APP_KEY] as? String else {
            fatalError("KAKAO APP KEY not set in plist for this environment")
        }
        return kakaoAppKey
    }()
    
    public static let BASE_URL: String = {
        guard let baseURL = Env.infoDictionary[Keys.Plist.BASE_URL] as? String else {
            fatalError("BASE URL not set in plist for this environment")
        }
        return baseURL
    }()
    
    public static let NAVER_CLIENT_ID: String = {
        guard let clientID = Env.infoDictionary[Keys.Plist.NAVER_CLIENT_ID] as? String else {
            fatalError("CLIENT ID not set in plist for this environment")
        }
        return clientID
    }()
    
    public static let NAVER_CLIENT_SECRET: String = {
        guard let clientSecret = Env.infoDictionary[Keys.Plist.NAVER_CLIENT_SECRET] as? String else {
            fatalError("CLIENT_SECRET not set in plist for this environment")
        }
        return clientSecret
    }()
    
    public static let CLIMBER_TOKEN: String = {
        guard let token = Env.infoDictionary[Keys.Plist.CLIMBER_TOKEN] as? String else {
            fatalError("CLIMBER_TOKEN not set in plist for this environment")
        }
        return token
    }()
    
    public static let MASTER_TOKEN: String = {
        guard let token = Env.infoDictionary[Keys.Plist.MASTER_TOKEN] as? String else {
            fatalError("MASTER_TOKEN not set in plist for this environment")
        }
        return token
    }()
}
