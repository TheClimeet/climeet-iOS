//
//  CheckLevelReducer.swift
//  Climeet-iOS
//
//  Created by 송형욱 on 12/29/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct CheckLevelReducer {
    @Dependency(\.dismiss) var dismiss
    
    @ObservableState
    struct State: Equatable {
        var signupExtra: SignupExtra
        
        var rows: [CheckLevel] = ClimbingLevel.allCases.map { CheckLevel(level: $0) }
    }
    
    enum Action {
        case nextBtnTap
        case rowTap(CheckLevelReducer.State.CheckLevel)
        case pop
    }
    
    private enum CancelID { case checkNickname }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .nextBtnTap:
                return .none
            case .rowTap(let element):
                if let index = state.rows.firstIndex(where: { $0.id == element.id }) {
                    state.rows.indices.forEach { state.rows[$0].isSelected = false }
                    state.rows[index].isSelected.toggle()
                    state.signupExtra.climbingLevel = element.level
                }
                return .none
            case .pop:
                return .run { _ in
                    await self.dismiss()
                }
            }
        }
    }
}

extension CheckLevelReducer.State {
    struct CheckLevel: Hashable, Identifiable {
        let id = UUID()
        var level: ClimbingLevel
        var isSelected: Bool = false
        
        var text: String {
            switch level {
            case .BEGINNER: "입문"
            case .NOVICE: "초급"
            case .INTERMEDIATE: "중급"
            case .ADVANCED: "고급"
            case .EXPERT: "전문가"
            }
        }
        var content: String {
            switch level {
            case .BEGINNER: "클라이밍이 처음이에요."
            case .NOVICE: "클라이밍을 몇번 해봤어요."
            case .INTERMEDIATE: "V3 이상의 루트를 주로 타요."
            case .ADVANCED: "V5 이상의 루트를 주로 타요."
            case .EXPERT: "V8 이상의 루트를 완등할 수 있어요. "
            }
        }
    }
}
