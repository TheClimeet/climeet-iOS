import Foundation
import NetworkKit
import Alamofire

enum FollowEndPoint {
    case unFollow(userID: Int)
    case gymUnFollow(gymID: Int)
    case follow(userID: Int)
    case gymFollow(gymID: Int)
}

extension FollowEndPoint: Endpoint {
    var baseURL: String { Env.BASE_URL }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .unFollow, .gymUnFollow: .delete
        case .follow, .gymFollow: .post
        }
    }
    
    var path: String {
        switch self {
        case .unFollow: "/follow-relationship"
        case .gymUnFollow: "/follow-relationship/gym"
        case .follow: "/follow-relationship"
        case .gymFollow: "/follow-relationship/gym"
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .unFollow(let userID): [.init(name: "followingUserId", value: String(userID))]
        case .gymUnFollow(let gymID): [.init(name: "gymId", value: String(gymID))]
        case .follow(let userID): [.init(name: "followingUserId", value: String(userID))]
        case .gymFollow(let gymID): [.init(name: "gymId", value: String(gymID))]
        }
    }
    
    var headers: Alamofire.HTTPHeaders? {
        guard let token else { return nil }
        return [.authorization(bearerToken: token)]
    }
    
    var body: Alamofire.Parameters? {
        switch self {
        case .unFollow, .gymUnFollow, .follow, .gymFollow: nil
        }
    }
    
    var token: String? { KeyChain.shared.refreshToken }
}
