import Foundation
import Alamofire

struct APILogger: EventMonitor {
    let queue = DispatchQueue(label: "apiLogger")
    
    func requestDidFinish(_ request: Request) {
        #if DEBUG
        print("🚀 NETWORK Request LOG")
        print(request.description)
        
        print(
            "URL:" + (request.request?.url?.absoluteString ?? "")  + "\n"
            + "Method:" + (request.request?.httpMethod ?? "") + "\n"
            + "Headers:" + "\(request.request?.allHTTPHeaderFields ?? [:])" + "\n"
        )
        print("Authorization:" + (request.request?.headers["Authorization"] ?? "nil"))
        print("Body:" + (request.request?.httpBody?.prettyJson ?? "nil"))
        #endif
    }
    
    func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
        #if DEBUG
        print("✅ NETWORK Response LOG")
        switch response.result {
        case let .success(data):
            print(
              "URL: " + (request.request?.url?.absoluteString ?? "nil") + "\n"
              + "Result: " + "\(data)" + "\n"
                + "StatusCode: " + "\(response.response?.statusCode ?? 0)"
            )
        case let .failure(error):
            print(
              "URL: " + (request.request?.url?.absoluteString ?? "nil") + "\n"
              + "Result: " + "\(error.localizedDescription)" + "\n"
                + "StatusCode: " + "\(response.response?.statusCode ?? 0)"
            )
        }
        #endif
    }
}

fileprivate extension Data {
    var prettyJson: String? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = String(data: data, encoding:.utf8) else { return nil }

        return prettyPrintedString
    }
}
