//
//  SetProfileReducer.swift
//  Climeet-iOS
//
//  Created by 송형욱 on 12/23/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct SetProfileReducer {
    @Dependency(\.dismiss) var dismiss
    @Dependency(\.s3Client) var s3client
    
    @Reducer(state: .equatable)
    enum Path {
        case checkLevel(CheckLevelReducer)
    }

    @ObservableState
    struct State: Equatable {
        var accessToken: String
        var nickname: String
        var image: Data?
        var path = StackState<Path.State>()
    }
    
    enum Action {
        case nextBtnTap
        case moveToCheckLevel(imageURL: String?)
        case path(StackActionOf<Path>)
        case pop
    }
    
    init() {}
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .nextBtnTap:
                guard let image = state.image else {
                    return .send(.moveToCheckLevel(imageURL: nil))
                }
                return .run { send in
                    let response = try await s3client.file(.init(file: image))
                    await send(.moveToCheckLevel(imageURL: response.imgUrl))
                }
            case .moveToCheckLevel(let imageURL):
                state.path.append(.checkLevel(.init(
                    accessToken: state.accessToken,
                    nickname: state.nickname,
                    imageURL: imageURL
                )))
                return .none
            case .path:
                return .none
            case .pop:
                return .run { _ in
                    await self.dismiss()
                }
            }
        }
        .forEach(\.path, action: \.path)
    }
}
