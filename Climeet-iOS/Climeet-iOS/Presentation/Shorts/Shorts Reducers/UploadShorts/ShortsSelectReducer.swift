//
//  ShortsSelectReducer.swift
//  Climeet-iOS
//
//  Created by mac on 6/19/24.
//

import Foundation
import ComposableArchitecture
import UIKit.UIImage

@Reducer
struct ShortsSelectReducer {
    @ObservableState
    struct State: Equatable {
        //MARK: Control Sheet Height
        var screenSize = CGSize(width: 0, height: 0)
        var path = StackState<Path.State>()
        var shortsThumbnail: UIImage?
        var shortsURL: URL?
    }
    
    @Reducer(state: .equatable)
    enum Path {
        case videoTagView(AddVideoTagReducer)
        case uploadView(ShortsPostingReducer)
    }
    
    enum Action {
        case readViewSize(CGSize)
        case path(StackActionOf<Path>)
        case tapNextButton(UIImage?, URL?)
        case showErrorSheet
        case delegate(Delegation)
        enum Delegation {
            case goToVideoTagView(UIImage?, URL?)
        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .readViewSize(let size):
                state.screenSize = size
                return .none
                
            case .tapNextButton(let image, let url):
                guard let image = image, let url = url else {
                    //TODO: 에러 시트 보이게 하기
                    return .send(.showErrorSheet)
                }
                
                state.path.append(
                    .videoTagView(AddVideoTagReducer.State(selectedVideoThumbnail: image, selectedVideoURL: url))
                )
                
                return .none

            case .path(.element(id: _, action: .videoTagView(.startUploading))):
                return .none
                
            case .path(.element(id: _, action: .videoTagView(.delegate(.shortsData(let shorts))))):
                state.path.append(.uploadView(ShortsPostingReducer.State(shorts: shorts)))
                return .none
                
            default:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
}
