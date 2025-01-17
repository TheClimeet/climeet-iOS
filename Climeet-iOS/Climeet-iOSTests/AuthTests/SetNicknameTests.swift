//
//  SetNicknameTests.swift
//  Climeet-iOSTests
//
//  Created by 송형욱 on 1/15/25.
//

import Testing
import ComposableArchitecture

@testable import Climeet_iOS

@MainActor
struct SetNicknameTests {
    
    @Test
    func updateNickname() async {
        let store = TestStore(
            initialState: SetNicknameReducer.State(signupExtra: .init(accessToken: "123"))
        ) {
            SetNicknameReducer()
        }
        
        await store.send(.updateNickname("123")) {
            $0.isValidNickname = true
            $0.signupExtra.nickName = "123"
            $0.warningText = .none
        }
    }
    
    @Test
    func duplicateBtnTapFail() async throws {
        let store = TestStore(
            initialState: SetNicknameReducer.State(
                signupExtra: .init(
                    accessToken: "123",
                    nickName: nil
                )
            )
        ) {
            SetNicknameReducer()
        }
        
        await store.send(.duplicateBtnTap) {
            $0.isValidNickname = false
            $0.warningText = .invalid
        }
    }
    
    @Test
    func duplicatedNickname() async throws {
        let store = TestStore(
            initialState: SetNicknameReducer.State(
                signupExtra: .init(
                    accessToken: "123",
                    nickName: "한국어"
                )
            )
        ) {
            SetNicknameReducer()
        } withDependencies: {
            $0.climberClient.checkNickname = { @Sendable _ in false }
            $0.validateService = .testValue
        }
        
        await store.send(.duplicateBtnTap)
        await store.receive(\.checkNicknameResponse) {
            $0.warningText = .duplicate
        }
    }
    
    @Test
    func enabledNickname() async throws {
        let store = TestStore(
            initialState: SetNicknameReducer.State(
                signupExtra: .init(
                    accessToken: "123",
                    nickName: "한국어"
                )
            )
        ) {
            SetNicknameReducer()
        } withDependencies: {
            $0.climberClient.checkNickname = { @Sendable _ in true }
            $0.validateService = .testValue
        }
        
        await store.send(.duplicateBtnTap)
        await store.receive(\.checkNicknameResponse) {
            $0.warningText = .enable
        }
    }
}
