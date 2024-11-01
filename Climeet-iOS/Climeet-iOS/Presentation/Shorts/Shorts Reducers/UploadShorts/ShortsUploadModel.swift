//
//  ShortsUploadModel.swift
//  Climeet-iOS
//
//  Created by mac on 7/20/24.
//

import Foundation

//TODO: 타입 선언 수정  
protocol MultipartFormable { }

struct Shorts: Encodable, Equatable, MultipartFormable {
    let video: Data
    let createShortsRequest: ShortsRequest
    
    static func == (lhs: Shorts, rhs: Shorts) -> Bool {
        return lhs.video == rhs.video && lhs.createShortsRequest == rhs.createShortsRequest
    }
}

struct ShortsRequest: Encodable, Equatable {
    let climbingGymId: Int
    let routeId: Int
    let sectorId: Int
    let thumbnailImageUrl: String
    let description: String
    let shortsVisibility: String
    let soundEnabled: Bool
}
     
//MARK: S3에 이미지, 동영상 등의 파일 올려서 URL링크 get하기 위한 모델
struct S3FileModel: MultipartFormable {
    let file: Data
}
