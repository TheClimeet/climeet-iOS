import Foundation
import NetworkKit
import Alamofire

enum ShortsEndPoint {
    case shorts(shortsID: Int)
    case likedShorts(page: Int, size: Int)
    case bookmarkedShorts(page: Int, size: Int)
    case uploaderShorts(ShortsDTO.Uploader.Request)
    case profile
    case popularShorts(ShortsDTO.List.Request)
    case myShorts(ShortsDTO.MyShorts.Request)
    case LatestShorts(ShortsDTO.List.Request)
    case addViewCount(shortsID: Int)
    case report(shortsID: Int, reason: String)
    case isRead(userID: Int)
    case upload(ShortsDTO.Upload.Request)
}

extension ShortsEndPoint: Endpoint {
    var baseURL: String { Env.BASE_URL }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .shorts, .likedShorts, .bookmarkedShorts, .uploaderShorts, .profile, .popularShorts: .get
        case .myShorts, .LatestShorts: .get
        case .addViewCount, .report, .isRead: .patch
        case .upload: .post
        }
    }
    
    var path: String {
        switch self {
        case .shorts(let shortsID): "/api/shorts/\(shortsID)"
        case .likedShorts: "/api/shorts/user/liked"
        case .bookmarkedShorts: "/api/shorts/user/bookmarked"
        case .uploaderShorts(let param): "/api/shorts/uploader/\(param.uploaderID)"
        case .profile: "/api/shorts/profile"
        case .popularShorts: "/api/shorts/popular"
        case .myShorts: "/api/shorts/my-shorts"
        case .LatestShorts: "/api/shorts/latest"
        case .addViewCount(let shortsID): "/api/shorts/\(shortsID)/viewCount"
        case .report(let shortsID, _): "/api/shorts/\(shortsID)/report"
        case .isRead: "/api/shorts/isRead"
        case .upload: "/api/shorts"
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .shorts:
            return nil
        case .likedShorts(let page, let size), .bookmarkedShorts(let page, let size):
            return [
                .init(name: "page", value: String(page)),
                .init(name: "size", value: String(size))
            ]
        case .uploaderShorts(let param):
            return [
                .init(name: "page", value: String(param.page)),
                .init(name: "size", value: String(param.size)),
                .init(name: "sortType", value: param.sortType.rawValue)
            ]
        case .profile:
            return nil
        case .popularShorts(let param), .LatestShorts(let param):
            var queryItems: [URLQueryItem] = [
                .init(name: "page", value: String(param.page)),
                .init(name: "size", value: String(param.size))
            ]
            
            if let gymID = param.gymID {
                queryItems.append(.init(name: "gymId", value: String(gymID)))
            }
            if let sectorID = param.sectorID {
                queryItems.append(.init(name: "sectorId", value: String(sectorID)))
            }
            if let routeID = param.routeID {
                queryItems.append(.init(name: "routeId", value: String(routeID)))
            }
            return queryItems
        case .myShorts(let param):
            return [
                .init(name: "shortsVisibility", value: param.shortsVisibility.rawValue),
                .init(name: "page", value: String(param.page)),
                .init(name: "size", value: String(param.size))
            ]
        case .addViewCount:
            return nil
        case .report(_, let reason):
            return [.init(name: "reason", value: reason)]
        case .isRead(let userID):
            return [.init(name: "followingUserId", value: String(userID))]
        case .upload:
            return nil
        }
    }
    
    var headers: Alamofire.HTTPHeaders? {
        guard let token else { return nil }
        switch self {
        case .upload:
            return [.authorization(bearerToken: token), .contentType("multipart/form-data")]
        default:
            return [.authorization(bearerToken: token)]
        }
    }
    
    var body: Alamofire.Parameters? {
        switch self {
        case .shorts, .likedShorts, .bookmarkedShorts, .uploaderShorts: return nil
        case .profile, .popularShorts, .myShorts, .LatestShorts: return nil
        case .addViewCount, .report, .isRead: return nil
        case .upload(let param):
            return [
                "video": param.video,
                "createShortsRequest": param.createShortsRequest
            ]
        }
    }
    
    var token: String? { UserDefaults.standard.value(forKey: "token") as? String }
    
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
