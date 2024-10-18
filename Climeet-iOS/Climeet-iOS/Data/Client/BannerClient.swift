//
//  BannerClient.swift
//  Climeet-iOS
//
//  Created by 송형욱 on 10/6/24.
//

import NetworkKit
import Dependencies

struct BannerClient {
    var banners: @Sendable () async throws -> BannerDTO.Response
}

extension BannerClient: DependencyKey {
    static var liveValue: BannerClient = .init(
        banners: {
            let endPoint = BannerEndPoint.banners
            return try await APIClient.shared.request(endPoint, decode: BannerDTO.Response.self)
        }
    )
}

extension DependencyValues {
    var bannerClient: BannerClient {
        get { self[BannerClient.self] }
        set { self[BannerClient.self] = newValue }
    }
}
