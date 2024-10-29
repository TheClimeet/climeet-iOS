//
//  TokenProvider.swift
//  Climeet-iOS
//
//  Created by KOVI on 10/28/24.
//

import NetworkKit
import Foundation

struct TokenRefresher: TokenRefreshable {
    func readToken() -> String {
        guard let readToken = KeyChain.shared.refreshToken else {
            tokenNotFoundAction()
            return ""
        }
        
        return readToken
    }
    
    func refreshToken() async -> Bool {
        // TODO: RefreshToken API 호출
        let endpoint = UserEndPoint.refreshToken
        let result = try? await APIClient(tokenRefresher: nil)
            .request(endpoint, decode: UserDTO.RefreshToken.Response.self)
        
        // TODO: Save RefreshToken to (KeyChain)
        if let refreshToken = result?.refreshToken {
            KeyChain.shared.refreshToken = refreshToken
            return true
        }
        
        return false
    }
    
    // MARK: Private
    private func tokenNotFoundAction() {
        // TODO: 토큰이 존재하지않을 때, 로그인화면 이동 처리
    }
}
