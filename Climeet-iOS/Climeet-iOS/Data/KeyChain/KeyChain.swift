//
//  KeyChain.swift
//  Climeet-iOS
//
//  Created by KOVI on 10/29/24.
//

import Foundation

class KeyChain {
    
    static let shared = KeyChain()
    
    private init() { }
    
    // MARK: - Keys
    enum Keys: String {
        case REFRESH_TOKEN = "REFRESH_TOKEN"
    }
    
    // MARK: - Value
    var refreshToken: String? {
        get { read(key: .REFRESH_TOKEN) }
        set {
            guard let token = newValue else { return }
            create(key: .REFRESH_TOKEN, token: token)
        }
    }
}

extension KeyChain {
    // MARK: - private
    private func create(key: KeyChain.Keys, token: String) {
        let query: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key.rawValue,   // 저장할 Account
            kSecValueData: token.data(using: .utf8, allowLossyConversion: false) as Any
        ]
        // 기존저장내역제거
        SecItemDelete(query)
        
        let status = SecItemAdd(query, nil)
        assert(status == noErr, "토큰저장실패 with status code \(status)")
    }
    
    private func read(key: KeyChain.Keys) -> String? {
        let query: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key.rawValue,
            kSecReturnData: kCFBooleanTrue as Any,  // CFData 타입으로 불러오라는 의미
            kSecMatchLimit: kSecMatchLimitOne       // 중복되는 경우, 하나의 값만 불러오라는 의미
        ]
        
        // READ
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query, &dataTypeRef)
        
        if status == errSecSuccess {
            let retrievedData = dataTypeRef as! Data
            let value = String(data: retrievedData, encoding: String.Encoding.utf8)
            return value
        } else {
            print("토큰읽어오기실패, status code = \(status)")
            return nil
        }
    }
}

extension KeyChain {
    // MARK: Delete For Test
    func deleteRefreshToken() {
        let query: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: Keys.REFRESH_TOKEN.rawValue
        ]
        let status = SecItemDelete(query)
        assert(status == noErr, "failed to delete the value, status code = \(status)")
    }
}
