//
//  BannerInfo.swift
//  Climeet-iOS
//
//  Created by 권승용 on 10/30/24.
//

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
