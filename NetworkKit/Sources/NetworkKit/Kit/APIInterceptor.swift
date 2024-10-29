import Foundation
import Alamofire
import NetworkKit

public protocol TokenRefreshable: Sendable {
    func readToken() -> String
    func refreshToken() async -> Bool
}

final class APIInterceptor: RequestInterceptor {
    
    private let tokenRefresher: TokenRefreshable
    
    init(tokenRefresher: TokenRefreshable) {
        self.tokenRefresher = tokenRefresher
    }
    
    func adapt(_ urlRequest: URLRequest, for session: Alamofire.Session, completion: @escaping (Result<URLRequest, any Error>) -> Void) {
        var request = urlRequest
        let token = tokenRefresher.readToken()
        
        guard !token.isEmpty else {
            completion(.failure(APIError(errorCode: "401 Token Error", message: "Token Missing")))
            return
        }
        
        request.headers.add(.authorization(bearerToken: token))
        
        if let tokenHeader = request.headers.first(where: { $0 == .authorization(bearerToken: token) }) {
            print("\nadapted; token added to the header field is: \(tokenHeader)\n")
        }
        
        completion(.success(request))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: any Error, completion: @escaping @Sendable (RetryResult) -> Void) {
        
        let retryLimit = 3
        guard request.retryCount < retryLimit else {
            completion(.doNotRetry)
            return
        }
        
        print("\nretried; retry count: \(request.retryCount)\n")
        
        Task {
            let isSuccessRefresh = await self.tokenRefresher.refreshToken()
            isSuccessRefresh ? completion(.doNotRetry) : completion(.retry)
        }
    }
}
