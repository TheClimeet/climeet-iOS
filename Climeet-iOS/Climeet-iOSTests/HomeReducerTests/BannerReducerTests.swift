//
//  BannerReducerTests.swift
//  Climeet-iOS
//
//  Created by 권승용 on 10/28/24.
//

import ComposableArchitecture
import XCTest

@testable import Climeet_iOS

@MainActor
class BannerReducerTest: XCTestCase {
    
    func testbannerRequest() async throws {
        let store = TestStore(initialState: BannerReducer.State()) {
            BannerReducer()
        }
        
        await store.send(.onFirstAppear)
        
        await store.receive(\.bannerResponse) {
            $0.bannerInfos = try [
                BannerDTO.ResponseElement(
                    id: 1,
                    bannerImageURL: "https://climeet-production-bucket.s3.ap-northeast-2.amazonaws.com/1615cdad-d781-4bf6-a4de-57a136eb0089.jpg",
                    bannerTargetURL: "https://www.naver.com/",
                    title: "배너테스트1",
                    bannerStartDate: "2024-10-03",
                    bannerEndDate: "2024-10-31",
                    isPopup: false,
                    linkURL: nil
                ),
                BannerDTO.ResponseElement(
                    id: 2,
                    bannerImageURL: "https://climeet-production-bucket.s3.ap-northeast-2.amazonaws.com/1615cdad-d781-4bf6-a4de-57a136eb0089.jpg",
                    bannerTargetURL: "https://www.naver.com/",
                    title: "배너테스트2",
                    bannerStartDate: "2024-10-03",
                    bannerEndDate: "2024-10-31",
                    isPopup: false,
                    linkURL: nil
                )
            ].map {
                try BannerInfo(from: $0)
            }
        }
    }
}
