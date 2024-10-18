import Foundation
import NetworkKit
import Alamofire

enum ShortsCommentEndPoint {
    case comments(ShortsCommentDTO.Comments.Request)
    case childComments(ShortsCommentDTO.ChildComments.Request)
    case myComments(page: Int, size: Int)
    case commentState(ShortsCommentDTO.CommentState.Request)
    case report(commentID: Int, reason: String)
    case Write(ShortsCommentDTO.Write.Request)
}

extension ShortsCommentEndPoint: Endpoint {
    var baseURL: String { Env.BASE_URL }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .comments, .childComments, .myComments: .get
        case .commentState: .patch
        case .report, .Write: .post
        }
    }
    
    var path: String {
        switch self {
        case .comments(let param): "/api/shorts/\(param.shortsID)/shortsComments"
        case .childComments(let param): "/api/shorts/\(param.shortsID)/\(param.parentCommentID)"
        case .myComments: "/api/shorts/user/comments"
        case .commentState(let param): "/api/shortsComments/\(param.shortsCommentID)"
        case .report(let commentID, _): "/api/shortsComments/\(commentID)/report"
        case .Write(let param): "/api/shorts/\(param.shortsID)/shortsComments"
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .comments(let param):
            return [
                .init(name: "size", value: String(param.size)),
                .init(name: "page", value: String(param.page))
            ]
        case .childComments(let param):
            return [
                .init(name: "size", value: String(param.size)),
                .init(name: "page", value: String(param.page))
            ]
        case .myComments(let page, let size):
            return [
                .init(name: "size", value: String(size)),
                .init(name: "page", value: String(page))
            ]
        case .commentState(let param):
            return [
                .init(name: "isLike", value: String(param.isLike)),
                .init(name: "isDislike", value: String(param.isDislike))
            ]
        case .report(_, let reason):
            return [.init(name: "reason", value: reason)]
        case .Write(let param):
            if let parentCommentID = param.parentCommentID {
                return [.init(name: "parentCommentId", value: String(parentCommentID))]
            }
            return nil
        }
    }
    
    var headers: Alamofire.HTTPHeaders? {
        guard let token else { return nil }
        return [.authorization(bearerToken: token)]
    }
    
    var body: Alamofire.Parameters? {
        switch self {
        case .comments, .childComments, .myComments, .commentState, .report: nil
        case .Write(let param): ["content": param.content]
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
