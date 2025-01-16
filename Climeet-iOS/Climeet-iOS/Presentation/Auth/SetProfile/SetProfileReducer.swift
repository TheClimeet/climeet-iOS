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
    
    @ObservableState
    struct State: Equatable {
        var signupExtra: SignupExtra
        var imageData: Data?
    }
    
    enum Action {
        case saveImageData(Data)
        case nextBtnTap
        case moveToCheckLevel(SignupExtra)
        case pop
    }
    
    private enum CancelID: Hashable { case fileUpload }
    
    init() {}
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .saveImageData(let data):
                state.imageData = data
                return .none
            case .nextBtnTap:
                guard let image = state.imageData else {
                    return .send(.moveToCheckLevel(state.signupExtra))
                }
                return .run { [signupExtra = state.signupExtra] send in
                    let response = try await s3client.file(.init(file: image))
                    await send(.moveToCheckLevel(.init(
                        accessToken: signupExtra.accessToken,
                        socialType: signupExtra.socialType,
                        nickName: signupExtra.nickName,
                        climbingLevel: signupExtra.climbingLevel,
                        discoveryChannel: signupExtra.discoveryChannel,
                        profileImgURL: response.imgUrl,
                        gymFollowList: signupExtra.gymFollowList
                    )))
                }
                .cancellable(id: CancelID.fileUpload)
            case .moveToCheckLevel(let signupExtra):
                state.signupExtra = signupExtra
                return .none
            case .pop:
                return .run { _ in
                    await self.dismiss()
                }
            }
        }
    }
}
