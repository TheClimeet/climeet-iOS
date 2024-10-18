//
//  ShortsDeckReducer.swift
//  Climeet-iOS
//
//  Created by mac on 8/29/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct ShortsDeckReducer {
    @Reducer(state: .equatable)
    enum Path {
        case shortsDeckItemScrollView(ShortsDeckItemReducer)
    }
    
    @Reducer
    enum Destination {
        case searchGym(SearchReducer)
        //TODO: Route 리듀서 연결
        //case addRoute(//RouteReducer)
    }
    
    enum FetchingStatus {
        case isLoading
        case loaded
        case loadedAll
    }
    
    @ObservableState
    struct State: Equatable {
        @Presents var destination: Destination.State?
        var screenSize: CGSize?
        var fetchingStatus: FetchingStatus = .isLoading
        var shortsDeckItems: [ShortsDeckItem] = []
        var shortsSortingRule: Rule = .recent
        var path = StackState<Path.State>()
        
        @ObservationStateIgnored var page: Int = 0
        @ObservationStateIgnored var hasNextPage: Bool = true
        
        static func == (lhs: ShortsDeckReducer.State, 
                        rhs: ShortsDeckReducer.State) -> Bool {
            return lhs.shortsDeckItems == rhs.shortsDeckItems &&
            lhs.shortsSortingRule == rhs.shortsSortingRule &&
            lhs.hasNextPage == rhs.hasNextPage
        }
    }
    
    enum Action: BindableAction {
        case tapShortsItem
        case fetchShortsItem
        case fetchResult(ShortsDeck)
        case addShortsDeckFilter
        case readSize(CGSize)
        case updateRequestedPage(Int, Bool)
        case startFetching
        
        case path(StackActionOf<Path>)
        case destination(PresentationAction<Destination.Action>)
        case binding(BindingAction<State>)
        case delegate(Delegation)
        
        enum Delegation {
            //Put data you want to give as case
        }
    }
    
    enum Rule {
        case recent
        case popular
    }
    
    //MARK: - Intenal
    private let size: Int = 20

    @Dependency(\.shortsClient) var shortsClient

    var body: some ReducerOf<Self> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .readSize(let size):
                state.screenSize = size
                return .none
                
            case .startFetching:
                print("start fetching")
                
                if state.hasNextPage {
                    state.fetchingStatus = .isLoading
                    
                    return .run { send in
                        await send(.fetchShortsItem)
                    }
                    
                } else {
                    state.fetchingStatus = .loadedAll
                    return .none
                }
                
            case .fetchShortsItem:
                print("in loading")
                return .run { [page = state.page] send in
                    do {
                        let response = try await shortsClient.popularShorts(.init(page: page, size: self.size))
                        let shortsDeckItems = response.result.compactMap {
                            $0.toEntity()
                        }
                        let result = ShortsDeck(page: response.page, hasNext: response.hasNext, result: shortsDeckItems)
                        
                        await send(.fetchResult(result))
                    } catch let error {
                        Log.error("fetchShortsItem에서 에러 발생", "error: \(error)")
                    }
                }
                
            case let .fetchResult(item):
                print("fetching done successfully")

                state.fetchingStatus = .loaded
                state.shortsDeckItems.append(contentsOf: item.result)
                state.page = item.page
                state.hasNextPage = item.hasNext
                
                return .none
                
            case .updateRequestedPage(let page, 
                                      let hasNext):
                state.page = page
                state.hasNextPage = hasNext
                
                return .none
                
            case .tapShortsItem:
                state.path.append(
                    .shortsDeckItemScrollView(ShortsDeckItemReducer.State())
                )
            
                return .none
                
            case .addShortsDeckFilter:
                
                return .none
                
            case .binding(_):
                return .none
                
            case .destination(_):
                return .none
                
            default:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
        .ifLet(\.$destination, action: \.destination)
    }
}

private func makeDummy() -> [ShortsDeckItem] {
    var temp = [ShortsDeckItem]()
    for i in 0...20 {
        let dummy = ShortsDeckItem(shortsId: 0, thumbnailImageUrl: "https://picsum.photos/200/300", gymName: "테스트클라이밍", gymDifficultyName: "v1", gymDifficultyColor: "#FFFFF", isManager: false, shortsDetailInfo: ShortsDetailInfo(userShortsSimpleInfo: UserShortsSimpleInfo(userId: 0, profileImgUrl: "https://dummyimage.com/300x200/000/fff", profileName: "테스트"), shortsId: i, gymName: "테스트클라이밍", sectorName: "테스트클라이밍", gymId: 0, sectorId: 0, videoUrl: "https://dummyimage.com/300x200/000/fff", likeCount: 1, commentCount: 1, bookmarkCount: 1, shareCount: 1, isLiked: false, isBookmarked: false, description: "asdf", routeImageUrl: "https://dummyimage.com/300x200/000/fff", gymDifficultyName: "v1", gymDifficultyColor: "#FFFFF", isSoundEnabled: false))
        
        temp.append(dummy)
    }
    
    return temp
}
