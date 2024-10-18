import Foundation

public protocol APIProtocol {
    func request<T: Decodable>(_ endpoint: Endpoint, decode: T.Type) async throws -> T
    func upload<T: Decodable>(_ endpoint: Endpoint, decode: T.Type) async throws -> T
}
