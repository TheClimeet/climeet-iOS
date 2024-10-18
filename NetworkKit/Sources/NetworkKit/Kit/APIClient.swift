import Foundation
import Alamofire

public final class APIClient: APIProtocol, @unchecked Sendable {
    public static let shared: APIClient = .init()
    public init() {}
    
    private var session: Session = {
        let configuration = URLSessionConfiguration.af.default
        configuration.waitsForConnectivity = true
        configuration.timeoutIntervalForRequest = 60 // seconds that a task will wait for data to arrive
        configuration.timeoutIntervalForResource = 300 // seconds for whole resource request to complete ,.
        return Session(configuration: configuration, eventMonitors: [APILogger()])
    }()
    
    public func request<T: Decodable>(_ endpoint: Endpoint, decode: T.Type) async throws -> T {
        do {
            let result = try await self.session.request(endpoint.asURLRequest()).serializingData().response
            return try self.manageResponse(data: result.data, response: result.response)
        } catch let error as APIError {
            throw error
        } catch {
            throw APIError(
                errorCode: "ERROR",
                message: "Unknown API error \(error.localizedDescription)"
            )
        }
    }
    
    public func upload<T>(_ endpoint: any Endpoint, decode: T.Type) async throws -> T where T : Decodable {
        do {
            let result = try await self.session.upload(multipartFormData: { multipartFormData in
                if let data = endpoint.body?["data"] as? Data {
                    multipartFormData.append(data, withName: "image")
                }
            }, with: endpoint.asURLRequest()).serializingData(automaticallyCancelling: true).response
            return try self.manageResponse(data: result.data, response: result.response)
        } catch let error as APIError {
            throw error
        } catch {
            throw APIError(
                errorCode: "ERROR",
                message: "Unknown API error \(error.localizedDescription)"
            )
        }
    }
}

extension APIClient {
    // MARK: Private
    
    private func manageResponse<T: Decodable>(data: Data?, response: HTTPURLResponse?) throws -> T {
        guard let response else {
            throw APIError(
                errorCode: "ERROR",
                message: "Invalid HTTP response"
            )
        }
        guard let data else {
            throw APIError(
                errorCode: "ERROR",
                message: "Unknown Data Response"
            )
        }
        switch response.statusCode {
        case 200...299:
            do {
                return try JSONDecoder().decode(T.self, from: data)
            } catch {
                debugPrint("‼️", error)
                throw APIError(
                    errorCode: "Decoding Data Error Code",
                    message: "Error decoding data"
                )
            }
        default:
            guard let decodedError = try? JSONDecoder().decode(APIError.self, from: data) else {
                throw APIError(
                    statusCode: response.statusCode,
                    errorCode: "ERROR",
                    message: "Unknown backend error"
                )
            }
            
            throw APIError(
                statusCode: response.statusCode,
                errorCode: decodedError.errorCode,
                message: decodedError.message
            )
        }
    }
}
