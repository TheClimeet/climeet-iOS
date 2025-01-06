//
//  NaverClient.swift
//  Climeet-iOS
//
//  Created by 송형욱 on 10/22/24.
//

import Foundation
import NaverThirdPartyLogin
import NetworkKit
import Alamofire

final class NaverRepository: NSObject {
    var instance: NaverThirdPartyLoginConnection?
    var task: Task<Void, Error>?
    var accessToken: (@Sendable (String?) async -> Void)?
    
    init(instance: NaverThirdPartyLoginConnection? = NaverThirdPartyLoginConnection.getSharedInstance()) {
        self.instance = instance
    }
    
    func login() {
        self.instance?.delegate = self
        self.instance?.resetToken()
        self.instance?.requestThirdPartyLogin()
    }
}

extension NaverRepository: NaverThirdPartyLoginConnectionDelegate {
    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        self.task?.cancel()
        
        self.task = Task {
            guard let isCancel = self.task?.isCancelled, !isCancel else { return }
            await self.accessToken?(self.instance?.accessToken)
        }
    }
    
    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
        
    }
    
    func oauth20ConnectionDidFinishDeleteToken() {
        
    }
    
    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: (any Error)!) {
        self.task?.cancel()
        
        self.task = Task {
            guard let isCancel = self.task?.isCancelled, !isCancel else { return }
            await self.accessToken?(nil)
        }
    }
}
