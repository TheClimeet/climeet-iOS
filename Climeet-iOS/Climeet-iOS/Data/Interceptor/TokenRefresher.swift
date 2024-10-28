//
//  TokenProvider.swift
//  Climeet-iOS
//
//  Created by KOVI on 10/28/24.
//

import NetworkKit
import Foundation

struct TokenRefresher: TokenRefreshable {
    
    func refreshToken() async -> Bool {
        // TODO: RefreshToken API 호출
        let endpoint = UserEndPoint.refreshToken
        let result = try? await APIClient(tokenRefresher: nil)
            .request(endpoint, decode: UserDTO.RefreshToken.Response.self)
        
        // TODO: Save RefreshToken to (UserDefaults)
        if let refreshToken = result?.refreshToken {
            UserDefaults.standard.set(refreshToken, forKey: "token")
            UserDefaults.standard.synchronize()
            return true
        }
        
        return false
    }
}
