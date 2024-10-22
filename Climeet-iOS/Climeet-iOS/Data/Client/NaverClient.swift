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

protocol NaverDelegate {
    func naverUserInfo(_ response: Result<NaverDTO.Response, AppError>)
}

final class NaverRepository: NSObject {
    var instance: NaverThirdPartyLoginConnection?
    
    var delegate: NaverDelegate?
    
    var userInfoTask: Task<Void, Error>?
    
    init(instance: NaverThirdPartyLoginConnection? = NaverThirdPartyLoginConnection.getSharedInstance()) {
        self.instance = instance
    }
    
    func login() {
        self.instance?.delegate = self
        self.instance?.resetToken()
        self.instance?.requestThirdPartyLogin()
    }
    
    func userInfo() async -> Result<NaverDTO.Response, AppError> {
        guard let accessToken = await self.instance?.accessToken,
              let tokenType = await self.instance?.tokenType else {
            return .failure(.unknownError("Naver Failure"))
        }
        
        let authrization = "\(tokenType) \(accessToken)"
        do {
            let endpoint = NaverEndPoint.login(authorization: authrization)
            let userInfo = try await APIClient.shared.request(endpoint, decode: NaverDTO.Response.self)
            return .success(userInfo)
        } catch {
            return .failure(.networkError("Naver UserInfo 실패"))
        }
    }
}

extension NaverRepository: NaverThirdPartyLoginConnectionDelegate {
    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        self.userInfoTask?.cancel()
        
        self.userInfoTask = Task { @MainActor in
            guard let isCancel = self.userInfoTask?.isCancelled,
                  !isCancel else { return }
            let user = await self.userInfo()
            self.delegate?.naverUserInfo(user)
        }
    }
    
    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
    
    }
    
    func oauth20ConnectionDidFinishDeleteToken() {
        
    }
    
    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: (any Error)!) {
        self.delegate?.naverUserInfo(.failure(.unknownError(error.localizedDescription)))
    }
}
