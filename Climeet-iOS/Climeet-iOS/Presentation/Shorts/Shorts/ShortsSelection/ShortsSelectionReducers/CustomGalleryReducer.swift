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
        
        var prevIndex: Int?
        var isThumbnailRequestInFlight: Bool = false
        var selectedAsset: PHAsset?
        
        let cellImageSize: CGSize = {
            let screenWidth = UIScreen.main.bounds.width
            let screenHeight = UIScreen.main.bounds.height
            let width = screenWidth / 2
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
        case saveSelectedVideoInfo(PHAsset)
        case unselectCell
        
        //대표이미지 로드 및 비디오 데이터 저장
        case highQualityThumbnailLoaded(UIImage)
        case loadCellImage(indexPath: IndexPath, item: PhotoCellInfo)
        case cellImageLoaded(IndexPath, UIImage)
        case cancelThumbnailLoad
        case startThumbnailLoad
        
        //화면 전환 시 기본값 설정
        case setDefaults
    }
    
    private enum CancelID {
        case thumbnailRequest
    }
    
    @Dependency(\.photoService) var photoService
    @Dependency(\.albumService) var albumService
    @Dependency(\.photoAuthService) var photoAuthService

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
                        }
                        
                        await send(.finishSelection)
                    }.cancellable(id: CancelID.thumbnailRequest),
                    
                    Effect.run { send in
                        await send(.updateSelectionState(indexPath, cellInfo))
                    }
                )
                
            case .startThumbnailLoad:
                state.isThumbnailRequestInFlight = true
                return .none
                
            case .finishSelection:
                state.isThumbnailRequestInFlight = false
                return .none
                
            case let .updateSelectionState(indexPath, info):
                return .run { send in
                    await send(.updateCell(indexPath, info.selectedOrder))
                }
                
            case let .updateCell(indexPath, selectedOrder):
                switch selectedOrder {
                case .selected:
                    guard indexPath.item < state.dataSource.count else {
                        return .none
                    }
                    
                    var item = state.dataSource[indexPath.item]
                    item.selectedOrder = .none
                    state.dataSource[indexPath.item] = item
                    
                    return .run { send in
                        await send(.unselectCell)
                    }
                    
                case .none:
                    if let prevIndex = state.prevIndex {
                        guard prevIndex < state.dataSource.count else {
                            return .none
                        }
                        
                        var item = state.dataSource[prevIndex]
                        item.selectedOrder = .none
                        state.dataSource[prevIndex] = item
                    }
                    
                    
                    let selectedIndex = indexPath.item
                    
                    guard indexPath.item < state.dataSource.count else {
                        return .none
                    }
                    
                    var item = state.dataSource[indexPath.item]
                    item.selectedOrder = .selected
                    state.dataSource[indexPath.item] = item
                    state.prevIndex = selectedIndex
                    return .none
                }
                
            case .unselectCell:
                return .none
                
                //MARK: Thumbnail Image
            case .cancelThumbnailLoad:
                state.isThumbnailRequestInFlight = false
                return .cancel(id: CancelID.thumbnailRequest)
                
            case let .highQualityThumbnailLoaded(thumbnail):
                state.selectedVideoThumbnail = thumbnail
                return .none
                
            case let .saveSelectedVideoInfo(phAsset):
                state.selectedAsset = phAsset
                return .none
                
            case let .loadCellImage(indexPath, item):
                return .run { [size = state.cellImageSize] send in
                    if let cellImage = await photoService.fetchVideo(
                        phAsset: item.phAsset,
                        size: size,
                        contentMode: .aspectFit,
                        deliveryMode: .mediumQualityFormat
                    ) {
                        await send(.cellImageLoaded(indexPath, cellImage))
                    }
                }
                
            case let .cellImageLoaded(indexPath, cellImage):
                guard indexPath.item < state.dataSource.count else { return .none }
                
                var updatedItem = state.dataSource[indexPath.item]
                updatedItem.videoThumbnail = cellImage
                state.dataSource[indexPath.item] = updatedItem
                
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
