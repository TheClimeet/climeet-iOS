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
    
    static var testValue: BannerClient = .init(
        banners: {
            return [
                BannerDTO.ResponseElement(
                    id: 1,
                    bannerImageURL: "https://climeet-production-bucket.s3.ap-northeast-2.amazonaws.com/1615cdad-d781-4bf6-a4de-57a136eb0089.jpg",
                    bannerTargetURL: "https://www.naver.com/",
                    title: "배너테스트1",
                    bannerStartDate: "2024-10-03",
                    bannerEndDate: "2024-10-31",
                    isPopup: false
                ),
                BannerDTO.ResponseElement(
                    id: 2,
                    bannerImageURL: "https://climeet-production-bucket.s3.ap-northeast-2.amazonaws.com/1615cdad-d781-4bf6-a4de-57a136eb0089.jpg",
                    bannerTargetURL: "https://www.naver.com/",
                    title: "배너테스트2",
                    bannerStartDate: "2024-10-03",
                    bannerEndDate: "2024-10-31",
                    isPopup: false
                )
            ]
        }
    )
    
    static var previewValue: BannerClient = .init(
        banners: {
            return [
                BannerDTO.ResponseElement(
                    id: 1,
                    bannerImageURL: "https://climeet-production-bucket.s3.ap-northeast-2.amazonaws.com/1615cdad-d781-4bf6-a4de-57a136eb0089.jpg",
                    bannerTargetURL: "https://www.naver.com/",
                    title: "배너테스트1",
                    bannerStartDate: "2024-10-03",
                    bannerEndDate: "2024-10-31",
                    isPopup: false
                ),
                BannerDTO.ResponseElement(
                    id: 2,
                    bannerImageURL: "https://climeet-production-bucket.s3.ap-northeast-2.amazonaws.com/1615cdad-d781-4bf6-a4de-57a136eb0089.jpg",
                    bannerTargetURL: "https://www.naver.com/",
                    title: "배너테스트2",
                    bannerStartDate: "2024-10-03",
                    bannerEndDate: "2024-10-31",
                    isPopup: false
                )
            ]
        }
    )
}

extension DependencyValues {
    var bannerClient: BannerClient {
        get { self[BannerClient.self] }
        set { self[BannerClient.self] = newValue }
    }
}
