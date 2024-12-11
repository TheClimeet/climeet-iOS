//
//  CustomGalleryReducer.swift
//  Climeet-iOS
//
//  Created by mac on 11/28/24.
//

import Foundation
import ComposableArchitecture
import Photos
import UIKit

@Reducer
struct CustomGalleryReducer {
    @ObservableState
    struct State: Equatable {
        var selectedVideoThumbnail: UIImage?
        var selectedVideoData: Data?
        
        var dataSource: [PhotoCellInfo] = []
        var currentPage: Int = 0
        var hasMoreItems: Bool = false
        var currentPHAssets: [PHAsset] = []
        var loadedIndexPath: IndexPath?
        
        var selectedIndex: Int?
        var prevIndex: Int?
        var updatingIndexPaths: [IndexPath] = []
        var isThumbnailRequestInFlight: Bool = false
        var selectedAsset: PHAsset?
        
        let cellImageSize: CGSize = {
            let screenWidth = UIScreen.main.bounds.width
            let screenHeight = UIScreen.main.bounds.height
            let width = screenWidth / 4
            return CGSize(width: width, height: width)
        }()
        
        let thumbnailImageSize: CGSize = {
            let screenWidth = UIScreen.main.bounds.width
            let screenHeight = UIScreen.main.bounds.height
            let width = screenWidth * (189.0 / 375.0)
            let height = screenHeight * (416.0 / 894.0)
            return CGSize(width: width * 2, height: height * 2)
        }()
    }
    
    //MARK: Internal
    private var batchSize = 20
    
    enum Action: Equatable {
        // 초기화 및 권한 관련
        case requestPhotoAuthorization
        case photoAuthorizationResponse(Bool)
        case loadAlbums
        case albumsLoaded([PHFetchResult<PHAsset>])
        
        // 배치 로딩 관련
        case loadNextBatch
        case batchLoaded([PhotoCellInfo])
        case assignPHAssets([PHAsset])
        
        // 셀 선택 관련
        case cellSelected(IndexPath)
        case updateCell(IndexPath, SelectionOrder)
        case updateSelectionState(IndexPath, PhotoCellInfo)
        case finishSelection
        case clearUpdatingIndexPaths
        case saveSelectedVideoInfo(PHAsset)

        //대표이미지 로드 및 비디오 데이터 저장
        case highQualityThumbnailLoaded(UIImage)
        case videoURLLoaded(PhotoCellInfo)
        case loadCellImage(indexPath: IndexPath, item: PhotoCellInfo)
        case thumbnailLoaded(IndexPath, UIImage)
        case assignVideoData(Data?)
        case cancelThumbnailLoad
        case startThumbnailLoad
        
        //화면 전환 시 기본값 설정
        case setDefaults
    }

    @Dependency(\.photoService) var photoService
    @Dependency(\.albumService) var albumService
    @Dependency(\.photoAuthService) var photoAuthService
        
    private enum CancelID {
        case thumbnailRequest
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .requestPhotoAuthorization:
                return .run { send in
                    let authorized = photoAuthService.requestAuthorization()
                    await send(.photoAuthorizationResponse(authorized))
                }
                
            case .photoAuthorizationResponse(let authorized):
                if authorized {
                    return .send(.loadAlbums)
                }
                
                return .none
                
            case .loadAlbums:
                return .run { send in
                    let albums = await albumService.getAlbums(mediaType: .video)
                    await send(.albumsLoaded(albums.map { $0.album }))
                }
                
            case .albumsLoaded(let albums):
                state.hasMoreItems = true
                state.currentPage = 0
                state.dataSource.removeAll()
                
                if let firstAlbum = albums.first {
                    return .run { send in
                        let assets = await photoService.convertAlbumToPHAssets(album: firstAlbum)
                        await send(.assignPHAssets(assets))
                    }
                }
                return .none
                
            case .assignPHAssets(let assets):
                state.currentPHAssets = assets
                return .run { send in
                    await send(.loadNextBatch)
                }
                
            case .loadNextBatch:
                guard !state.isThumbnailRequestInFlight,
                      state.hasMoreItems,
                      !state.currentPHAssets.isEmpty else {
                    return .none
                }
                
                let startIndex = state.currentPage * self.batchSize
                let endIndex = min(startIndex + self.batchSize, state.currentPHAssets.count)
                
                guard startIndex < state.currentPHAssets.count else {
                    state.hasMoreItems = false
                    return .none
                }
                
                let batchAssets = Array(state.currentPHAssets[startIndex..<endIndex])
                let newItems = batchAssets.map { asset in
                    PhotoCellInfo(
                        phAsset: asset,
                        duration: formatDuration(asset.duration),
                        selectedOrder: .none,
                        localIdentifier: asset.localIdentifier
                    )
                }
                
                return .run { send in
                    await send(.batchLoaded(newItems))
                }
                
            case .batchLoaded(let newItems):
                state.dataSource.append(contentsOf: newItems)
                state.currentPage += 1
                return .none
                
                //MARK: - Cell Selection
            case .cellSelected(let indexPath):
                guard indexPath.item < state.dataSource.count else {
                    return .none
                }

                let cellInfo = state.dataSource[indexPath.item]
                
                return .concatenate(
                    Effect.run { send in
                        await send(.updateSelectionState(indexPath, cellInfo))
                    },
                    
                    Effect.run { [processState = state.isThumbnailRequestInFlight] send in
                        if processState == true {
                            await send(.cancelThumbnailLoad)
                        }
                    },
                    
                    Effect.run { [size = state.thumbnailImageSize] send in
                        await send(.startThumbnailLoad)

                        if let thumbnail = await photoService.fetchHighQualityImage(
                            phAsset: cellInfo.phAsset,
                            size: size,
                            contentMode: .aspectFit,
                            deliveryMode: .highQualityFormat
                        ) {
                            await send(.highQualityThumbnailLoaded(thumbnail))
                            await send(.saveSelectedVideoInfo(cellInfo.phAsset))
                            //TODO: 최종 쇼츠 비디오 데이터만 변환 후 다음 화면으로 넘기기
                            //await send(.videoURLLoaded(cellInfo))
                        }
                        await send(.finishSelection)
                    }.cancellable(id: CancelID.thumbnailRequest)
                )
            
            case .startThumbnailLoad:
                state.isThumbnailRequestInFlight = true
                return .none
                
            case .finishSelection:
                 state.isThumbnailRequestInFlight = false
                return .none
                
                //MARK: Thumbnail Image
            case .cancelThumbnailLoad:
                print("cancleVideoLoadTask--------------------------------------")
                state.isThumbnailRequestInFlight = false
                return .cancel(id: CancelID.thumbnailRequest)
                
            case let .highQualityThumbnailLoaded(thumbnail):
                state.selectedVideoThumbnail = thumbnail
                return .none
                
            case let .saveSelectedVideoInfo(phAsset):
                state.selectedAsset = phAsset
                return .none
                
            case let .videoURLLoaded(info):
                return .run { send in
                    let videoData = await photoService.fetchVideoData(from: info.phAsset)
                  //  await send(.assignVideoData(videoData))
                }
                
            case .assignVideoData(let data):
                state.selectedVideoData = data
                return .none
                
            case let .updateSelectionState(indexPath, info):
                return .concatenate(
                    Effect.run { send in
                        await send(.updateCell(indexPath, info.selectedOrder))
                    },
                    
                    Effect.run(operation: { send in
                        await send(.clearUpdatingIndexPaths)
                    })
                )
                
            case let .updateCell(indexPath, selectedOrder):
                switch selectedOrder {
                case .selected:
                    //update cell
                    guard indexPath.item < state.dataSource.count else {
                        return .none
                    }
                    
                    let item = state.dataSource[indexPath.item]
                    item.selectedOrder = .none
                    state.dataSource[indexPath.item] = item
                    
                    //데이터 리프레싱을 위한 작업
                    state.selectedIndex = indexPath.item
                    state.updatingIndexPaths.append(indexPath)
                    
                case .none:
                    if let prevIndex = state.prevIndex {
                        guard prevIndex < state.dataSource.count else {
                            return .none
                        }
                        
                        let item = state.dataSource[prevIndex]
                        item.selectedOrder = .none
                        state.dataSource[prevIndex] = item
                        state.updatingIndexPaths.append(IndexPath(item: prevIndex, section: 0))
                    }
                    
                    state.selectedIndex = indexPath.item
                    
                    guard indexPath.item < state.dataSource.count else {
                        return .none
                    }
                    
                    let item = state.dataSource[indexPath.item]
                    item.selectedOrder = .selected
                    state.dataSource[indexPath.item] = item
                    state.prevIndex = state.selectedIndex
                }
                
                return .none
                
            case .clearUpdatingIndexPaths:
                state.updatingIndexPaths = []
                return .none
                
            case let .loadCellImage(indexPath, item):
                return .run { [size = state.cellImageSize] send in
                    if let thumbnail = await photoService.fetchVideo(
                        phAsset: item.phAsset,
                        size: size,
                        contentMode: .aspectFit,
                        deliveryMode: .automatic
                    ) {
                        await send(.thumbnailLoaded(indexPath, thumbnail))
                    }
                }
                
            case let .thumbnailLoaded(indexPath, thumbnail):
                guard indexPath.item < state.dataSource.count else { return .none }
                
                let updatedItem = state.dataSource[indexPath.item]
                updatedItem.videoThumbnail = thumbnail
                state.dataSource[indexPath.item] = updatedItem
                state.loadedIndexPath = indexPath
                
                return .none
                
            case .setDefaults:
                state.isThumbnailRequestInFlight = false
                return .none
                
            default:
                return .none
            }
        }
    }
    
    private func formatDuration(_ timeInterval: TimeInterval) -> String? {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: timeInterval)
    }
}
