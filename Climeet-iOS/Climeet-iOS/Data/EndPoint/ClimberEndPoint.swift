import Foundation
import NetworkKit
import Alamofire

enum ClimberEndPoint {
    case deactivate
    case search(ClimberDTO.Search.Request)
    case privacySetting(climberID: Int)
    case checkNickname(nickname: String)
    case shortsPrivacySetting
    case homegymPrivacySetting
    case averageCompletionRatePrivacySetting
    case averageCompletionLevelPrivacySetting
    case signupExtra(ClimberDTO.SignupExtra.Request)
    case login(ClimberDTO.Login.Request)
}

extension ClimberEndPoint: Endpoint {
    var baseURL: String { Env.BASE_URL }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .deactivate: .delete
        case .search: .get
        case .privacySetting: .get
        case .checkNickname: .get
        case .shortsPrivacySetting: .patch
        case .homegymPrivacySetting: .patch
        case .averageCompletionRatePrivacySetting: .patch
        case .averageCompletionLevelPrivacySetting: .patch
        case .signupExtra: .post
        case .login: .post
        }
    }
    
    var path: String {
        switch self {
        case .deactivate: "/api/climber/deactivate"
        case .search: "/api/climber/search"
        case .privacySetting: "/api/climber/privacy-setting"
        case .checkNickname(let nickname): "/api/climber/check-nickname/\(nickname)"
        case .shortsPrivacySetting: "/api/climber/shorts-privacy-setting"
        case .homegymPrivacySetting: "/api/climber/homegym-privacy-setting"
        case .averageCompletionRatePrivacySetting: "/api/climber/averageCompletionRate-privacy-setting"
        case .averageCompletionLevelPrivacySetting: "/api/climber/averageCompletionLevel-privacy-setting"
        case .signupExtra: "/api/climber/signup/extra"
        case .login: "/api/climber/login"
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .deactivate, .checkNickname, .shortsPrivacySetting, .homegymPrivacySetting:
            return nil
        case .search(let param):
            return [
                .init(name: "page", value: String(param.page)),
                .init(name: "size", value: String(param.size)),
                .init(name: "climberName", value: param.climberName)
            ]
        case .privacySetting(let climberID):
            return [.init(name: "climberId", value: String(climberID))]
        case .averageCompletionRatePrivacySetting, .averageCompletionLevelPrivacySetting:
            return nil
        case .signupExtra:
            return nil
        case .login(let param):
            return [.init(name: "provider", value: param.provider.rawValue)]
        }
    }
    
    var headers: Alamofire.HTTPHeaders? {
        guard let token else { return nil }
        return [.authorization(bearerToken: token)]
    }
    
    var body: Alamofire.Parameters? {
        switch self {
        case .deactivate: ["refreshToken": token ?? ""]
        case .search, .privacySetting, .checkNickname:
            nil
        case .shortsPrivacySetting, .homegymPrivacySetting:
            nil
        case .averageCompletionRatePrivacySetting, .averageCompletionLevelPrivacySetting:
            nil
        case .signupExtra(let param): [
            "token": param.token,
            "socialType": param.socialType.rawValue,
            "nickName": param.nickName,
            "climbingLevel": param.climbingLevel,
            "discoveryChannel": param.discoveryChannel,
            "profileImgUrl": param.profileImgURL,
            "gymFollowList": param.gymFollowList,
            "isAllowFollowNotification": param.isAllowFollowNotification,
            "isAllowLikeNotification": param.isAllowLikeNotification,
            "isAllowCommentNotification": param.isAllowCommentNotification,
            "isAllowAdNotification": param.isAllowAdNotification
        ]
        case .login(let param): [
            "accessToken": param.accessToken
        ]
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
