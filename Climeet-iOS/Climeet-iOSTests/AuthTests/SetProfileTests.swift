//
//  SetProfileTests.swift
//  Climeet-iOSTests
//
//  Created by 송형욱 on 1/16/25.
//

import Testing
import ComposableArchitecture
import Foundation

@testable import Climeet_iOS


@MainActor
struct SetProfileTests {
    
    @Test
    func saveImageData() async {
        let signupExtra = SignupExtra(accessToken: "123", nickName: "테스트")
        let data = "123".data(using: .utf8)!
        let store = TestStore(
            initialState: SetProfileReducer.State(signupExtra: signupExtra)
        ) {
            SetProfileReducer()
        }
        
        await store.send(.saveImageData(data)) {
            $0.imageData = "123".data(using: .utf8)
        }
    }
    
    @Test
    func nextBtnDidTap() async throws {
        let signupExtra = SignupExtra(accessToken: "123", nickName: "테스트")
        let data = "123".data(using: .utf8)!
        let imgURL = "url"
        
        let store = TestStore(
            initialState: SetProfileReducer.State(
                signupExtra: signupExtra,
                imageData: data
            )
        ) {
            SetProfileReducer()
        } withDependencies: {
            $0.s3Client.file = { @Sendable _ in .init(imgUrl: imgURL) }
        }
        
        await store.send(.nextBtnTap)
        await store.receive(\.moveToCheckLevel) {
            $0.signupExtra = .init(
                accessToken: signupExtra.accessToken,
                nickName: signupExtra.nickName,
                profileImgURL: imgURL
            )
        }
    }
}
