//
//  Climeet_iOSTests.swift
//  Climeet-iOSTests
//
//  Created by mac on 7/8/24.
//

import XCTest
@testable import Climeet_iOS

final class Climeet_iOSTests: XCTestCase {
    
    var shortsUploadUsecase: ShortsUploadUsecase!
    
    override func setUp() {
        super.setUp()
        shortsUploadUsecase = ShortsUploadUsecase()
    }
    
    override func tearDown() {
        shortsUploadUsecase = nil
        super.tearDown()
    }
    
    func testUploadThumbnail() async throws {
        //given
        let uiImage = UIImage(named: "shortsVideoPlaceHolder")!
        
        //when
        let result = await shortsUploadUsecase.generateShortsThumbnailURL(uiImage)
        
        //then
        switch result {
        case .success(let message):
            XCTAssert(message.contains("https"))
        case .failure(let error):
            XCTFail("Upload failed: \(error)")
        }
    }
    
    func testUploadShorts() async throws {
        //given
        let videoData = Data([0x00, 0x01, 0x02, 0x03])
        let request = ShortsRequest(climbingGymId: 1,
                                    routeId: 1,
                                    sectorId: 1,
                                    thumbnailImageUrl: "https://example.com/thumbnail.jpg",
                                    description: "Test description",
                                    shortsVisibility: "PUBLIC",
                                    soundEnabled: true)
        let shorts = Shorts(video: videoData, createShortsRequest: request)
        //when
        let result = await shortsUploadUsecase.uploadShorts(shorts)
        
        //then
        switch result {
        case .success(let success):
            print(success)
            XCTAssert(success == "업로드 성공")
        case .failure(let failure):
            XCTFail("Upload failed: \(failure)")
        }
    }
}
