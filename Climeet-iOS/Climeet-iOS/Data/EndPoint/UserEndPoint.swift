import Foundation
import NetworkKit
import Alamofire

enum UserEndPoint {
    case usersNotification(UserDTO.UsersNotification.Request?)
    case usersAccounts
    case profile(userID: Int?)
    case homeGyms(userID: Int?)
    case gymFollowing
    case followers(UserDTO.Followers.Request)
    case climberFollowing
    case profileName(name: String)
    case profileImage(imageURL: String)
    case usersFCMToken(token: String)
    case refreshToken
}

extension UserEndPoint: Endpoint {
    var baseURL: String { Env.BASE_URL }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .usersNotification(let param): param == nil ? .get : .patch
        case .usersAccounts, .profile, .homeGyms, .gymFollowing, .followers, .climberFollowing: .get
        case .profileName, .profileImage, .usersFCMToken: .patch
        case .refreshToken: .post
        }
    }
    
    var path: String {
        switch self {
        case .usersNotification: 
            return "/api/users/notifications"
        case .usersAccounts: 
            return "/api/users/accounts"
        case .profile(let userID):
            guard let userID else { return "/api/profile" }
            return "/api/profile/\(userID)"
        case .homeGyms(let userID):
            guard let userID else { return "/api/home/homegyms" }
            return "/api/home/homegyms/\(userID)"
        case .gymFollowing:
            return "/api/gym-following"
        case .followers:
            return "/api/followers"
        case .climberFollowing:
            return "/api/climber-following"
        case .profileName:
            return "/api/profile-name"
        case .profileImage:
            return "/api/profile-image"
        case .usersFCMToken:
            return "/api/users/fcmToken"
        case .refreshToken:
            return "/api/refresh-token"
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .followers(let param):
            guard let userID = param.userID else {
                return [.init(name: "userCategory", value: param.userCategory)]
            }
            return [
                .init(name: "userId", value: String(userID)),
                .init(name: "userCategory", value: param.userCategory)
            ]
        case .profileName(let name):
            return [
                .init(name: "name", value: name)
            ]
        case .refreshToken:
            return [
                .init(name: "refreshToken", value: UserDefaults.standard.string(forKey: "token"))
            ]
        default:
            return nil
        }
    }
    
    var headers: Alamofire.HTTPHeaders? {
        guard let token else { return nil }
        return [.authorization(bearerToken: token)]
    }
    
    var body: Alamofire.Parameters? {
        switch self {
        case .usersNotification(let param):
            guard let param else { return nil }
            return [
                "isAllowFollowNotification": param.isAllowFollowNotification,
                "isAllowLikeNotification": param.isAllowLikeNotification,
                "isAllowCommentNotification": param.isAllowCommentNotification,
                "isAllowAdNotification": param.isAllowAdNotification
            ]
        case .profileImage(let imageURL):
            return ["image": imageURL]
        case .usersFCMToken(let token):
            return ["fcmToken": token]
        default: return nil
        }
    }
    
    var token: String? { UserDefaults.standard.value(forKey: "token") as? String }
    
    var multipart: Alamofire.MultipartFormData? { nil }
    
    func asURLRequest() throws -> URLRequest {
        guard let url = URL(string: baseURL + path) else {
            throw AppError.urlConvertingError("URL Component 조합 실패")
        }
        var request = URLRequest(url: url)
        request.headers = headers ?? .default
        request.method = method
        
        return request
    }
}
