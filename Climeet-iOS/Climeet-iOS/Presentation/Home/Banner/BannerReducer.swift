//
//  BannerFeature.swift
//  Climeet-iOS
//
//  Created by 권승용 on 10/28/24.
//

import Foundation
import ComposableArchitecture

struct BannerInfo: Hashable, Identifiable, Equatable {
    let id: Int
    let bannerImageURL: String
    let title: String
    let bannerTargetURL: String
    let bannerStartDate: String
    let bannerEndDate: String
    let isPopup: Bool
    
    init(from dto: BannerDTO.ResponseElement) throws {
        guard let id = dto.id,
              let bannerImageURL = dto.bannerImageURL,
              let title = dto.title,
              let bannerTargetURL = dto.bannerTargetURL,
              let bannerStartDate = dto.bannerStartDate,
              let bannerEndDate = dto.bannerEndDate,
              let isPopup = dto.isPopup else {
            throw AppError.dataParsingError("DTO 디코딩 실패")
        }
        
        self.id = id
        self.bannerImageURL = bannerImageURL
        self.title = title
        self.bannerTargetURL = bannerTargetURL
        self.bannerStartDate = bannerStartDate
        self.bannerEndDate = bannerEndDate
        self.isPopup = isPopup
    }
}

@Reducer
struct BannerReducer {
    
    @ObservableState
    struct State: Equatable {
        var bannerInfos: [BannerInfo] = []
    }
    
    enum Action {
        case onFirstAppear
        case bannerResponse([BannerInfo])
    }
    
    @Dependency(\.bannerClient) var bannerClient
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onFirstAppear:
                return .run { send in
                    do {
                        let response = try await bannerClient.banners()
                        let result = try response.map {
                            try BannerInfo(from: $0)
                        }
                        await send(.bannerResponse(result))
                    } catch let error {
                        Log.error("Error on onFirstAppear", "error: \(error)")
                    }
                }
                
            case let .bannerResponse(bannerInfos):
                state.bannerInfos = bannerInfos
                return .none
            }
        }
    }
}
