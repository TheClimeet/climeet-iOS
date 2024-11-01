//
//  ShortsUploadVideoTagReducer.swift
//  Climeet-iOS
//
//  Created by mac on 6/28/24.
//

import Foundation
import ComposableArchitecture
import UIKit
import Alamofire

@Reducer
struct AddVideoTagReducer {
    @ObservableState
    struct State: Equatable {
        @Presents var destination: Destination.State?
        
        var bottomSheetHeight: CGFloat = 0
        var selectedVideoThumbnail: UIImage
        var selectedVideoURL: URL
        var discription: String = ""
        var isMuted: Bool = true
        var acessState: RevealState = .world
        
        //MARK: For Search Climbing Gym (gymName property because SwiftUI Compiler error)
        var gym: Gym?
        var gymName: String = ""
        
        //TODO: Routes 목록 가지는 프로퍼티 생성 필요
        
        //TODO: Route 리듀서 및 뷰 완성되면 추후 수정 필요
        var climbingRoute = ""
        
        static func == (lhs: State, rhs: State) -> Bool {
            return lhs.isMuted == rhs.isMuted &&
            lhs.acessState == rhs.acessState &&
            lhs.climbingRoute == rhs.climbingRoute &&
            lhs.discription == rhs.discription
        }
    }
    
    @Reducer
    enum Destination {
        case changeAccessState(AccessStateReducer)
        case searchGym(SearchReducer)
        //TODO: Route 리듀서 연결
        //case addRoute(//RouteReducer)
    }
    
    enum Action: BindableAction {
        case userAddedDiscriptions(String)
        case soundMuteButtonTapped
        case acessStateChangedButtonTapped
        case addClimbingGym
        
        //TODO: addRoute View 연결하기
        case addRoute
        case generateShortsModel(String)
        case startUploading
        
        case showErrorSheet
        
        case binding(BindingAction<State>)
        case destination(PresentationAction<Destination.Action>)
        case delegate(Delegation)
        enum Delegation {
            case shortsData(Shorts)
        }
    }
    
    @Dependency(\.s3Client) var s3Client
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .userAddedDiscriptions(let texts):
                state.discription = texts
                return .none
                
            case .soundMuteButtonTapped:
                state.isMuted.toggle()
                return .none
                
            case .startUploading:
                return .run(operation: { [image = state.selectedVideoThumbnail] send in
                    do {
                        guard let imageData = image.jpegData(compressionQuality: 1.0) else {
                            throw AppError.imageConvertingError("Image JPEG 압축 중 에러 발생")
                        }
                        let response = try await s3Client.file(.init(file: imageData))
                        guard let url = response.imgURL else {
                            throw AppError.dataParsingError("imgURL 언래핑 중 에러 발생")
                        }
                        
                        await send(.generateShortsModel(url))
                    } catch let error {
                        Log.error("NetworkError", "in startUploading: \(error)")
                    }
                })
                
            case let .generateShortsModel(urlString):
                guard let shortsVideoData = convertVideoToData(videoURL: state.selectedVideoURL) else {
                    return .send(.showErrorSheet)
                }
                
                //TODO: Route 추가되면 수정
                let reqeust = ShortsRequest(climbingGymId: 0,
                                            routeId: 0, sectorId: 0,
                                            thumbnailImageUrl: urlString,
                                            description: state.discription,
                                            shortsVisibility: state.acessState.literalForServer,
                                            soundEnabled: state.isMuted)
                let shorts = Shorts(video: shortsVideoData, createShortsRequest: reqeust)
                return .send(.delegate(.shortsData(shorts)))
                
                //MARK: For Access State
            case .acessStateChangedButtonTapped:
                let index = convertIndex(from: state.acessState)
                let reducer = AccessStateReducer.State(accessState: state.acessState, selectedToggleIndex: index)
                state.destination = .changeAccessState(reducer)
                return .none
                
            case let .destination(
                .presented(
                    .changeAccessState(
                        .delegate(
                            .selectAccessState(access)
                        )
                    )
                )
            ):
                state.acessState = access
                return .none
                
                //MARK: For Search Gym
            case .addClimbingGym:
                let reducer = SearchReducer.State()
                state.destination = .searchGym(reducer)
                return .none
                
            case let .destination(
                .presented(
                    .searchGym(
                        .delegate(
                            .selectGym(gym)
                        )
                    )
                )
            ):
                state.gym = gym
                state.gymName = gym.name
                return .none
                
                //TODO: GymID 이용해서 route 받아오기
            case .binding(_):
                return .none
                
            case .destination(_):
                return .none
                
            default:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
    
    private func convertIndex(from state: RevealState) -> Int {
        var index = 0
        if state == .world {
            index = 0
        } else if state == .followers {
            index = 1
        } else {
            index = 2
        }
        return index
    }
}

extension AddVideoTagReducer {
    private func convertVideoToData(videoURL: URL) -> Data? {
        do {
            let videoData = try Data(contentsOf: videoURL)
            return videoData
        } catch {
            print("Error loading video data: \(error)")
            return nil
        }
    }
}

enum RevealState: String {
    case world = "전체 공개"
    case followers = "팔로워만 공개"
    case onlyMe = "나만 보기"
    
    var literal: String {
        return self.rawValue
    }
    
    var literalForServer: String {
        switch self {
        case .world:
            return "PUBLIC"
        case .followers:
            return "FOLLOWERS_ONLY"
        case .onlyMe:
            return "PRIVATE"
        }
    }
}
