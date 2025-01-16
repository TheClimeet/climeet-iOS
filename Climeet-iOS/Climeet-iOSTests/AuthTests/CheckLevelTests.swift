//
//  CheckLevelTests.swift
//  Climeet-iOSTests
//
//  Created by 송형욱 on 1/16/25.
//

import Testing
import ComposableArchitecture

@testable import Climeet_iOS


@MainActor
struct CheckLevelTests {
    
    @Test
    func rowTap() async {
        let signupExtra = SignupExtra(accessToken: "123", nickName: "테스트")
        let rows = ClimbingLevel.allCases.map { CheckLevelReducer.State.CheckLevel(level: $0) }
        let row = rows.first(where: { $0.level == .BEGINNER })!
        
        let store = TestStore(
            initialState: CheckLevelReducer.State(
                signupExtra: signupExtra,
                rows: rows
            )
        ) {
            CheckLevelReducer()
        }
        
        await store.send(.rowTap(row)) {
            if let index = $0.rows.firstIndex(where: { $0.id == row.id }) {
                $0.rows[index].isSelected = !row.isSelected
                $0.rows[index].level = row.level
            }
            $0.signupExtra = .init(
                accessToken: signupExtra.accessToken,
                nickName: signupExtra.nickName,
                climbingLevel: row.level
            )
        }
    }
    
}
