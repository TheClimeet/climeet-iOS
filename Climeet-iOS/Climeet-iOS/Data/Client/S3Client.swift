//
//  S3Client.swift
//  Climeet-iOS
//
//  Created by 권승용 on 10/16/24.
//

import NetworkKit
import Dependencies

struct S3Client {
    var retoolFile: @Sendable (S3DTO.Retool.Request) async throws -> S3DTO.Retool.Response
    var file: @Sendable (S3DTO.File.Request) async throws -> S3DTO.File.Response
}

extension S3Client: DependencyKey {
    static var liveValue: S3Client = .init(
        retoolFile: { param in
            let endpoint = S3EndPoint.retoolUpload(data: param.file)
            return try await APIClient.shared.upload(endpoint, decode: S3DTO.Retool.Response.self)
        },
        file: { param in
            let endpoint = S3EndPoint.upload(data: param.file)
            return try await APIClient.shared.upload(endpoint, decode: S3DTO.File.Response.self)
        }
    )
}

extension DependencyValues {
    var s3Client: S3Client {
        get { self[S3Client.self] }
        set { self[S3Client.self] = newValue }
    }
}
