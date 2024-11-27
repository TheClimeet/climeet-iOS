////
////  CustomAlbumReducer.swift
////  Climeet-iOS
////
////  Created by mac on 11/27/24.
////
//
//import Foundation
//import ComposableArchitecture
//import Photos
///*
// 
// viewmodel 의 역할
// 
// - state
// 
// 외부 전달
// 선택한 썸네일, 선택한 비디오 아이디, 선택한 비디오 url
// 
// 내부에서 사용하는 것
// -  qocl
// - 앨범 로드하는 것
// 
// 
// - action
// 
// 현재 뷰모델이 위치한 곳
// -> shortsSelectionReducer 내부에
// -> 어떻게 위치시킬 것인가???
// 
// */
//
//@Reducer
//final class CustomAlbumReducer {
//    @ObservableState
//    struct State {
//        var currentAlbumIndex: Int = 0
//        var dataSource = [PhotoCellInfo]()
//        var currentLoadedImageCount: Int = 0
//    }
//    
//    private var currentPHAssets: [PHAsset] = []
////    private(set) var dataSource = [PhotoCellInfo]()
//    private var hasMoreItems: Bool = false
////    private var currentLoadedImageCount = 0
//    private let batchSize = 16
//    private var currentAlbumIndex = 0
//    
//    //    {
//    //        didSet { assignAlbums() }
//    //    }
//    
//    private var currentPage = 0
//    
//    enum Action {
//        case refreshAlbums
//        case loadAlbums
//        case assignAlbums
//        case loadInitialBatch
//        case loadNextBatch
//        case addDataSource([PhotoCellInfo])
//        case imageLoadingCompleted
//        
//    }
//    private let photoService: PhotoService = MyPhotoService()
//    
//    private let albumService: AlbumService = MyAlbumService()
//    private var albums = [PHFetchResult<PHAsset>]()
//    
//    var body: some ReducerOf<Self>  {
//        Reduce { state, action in
//            switch action {
//            case .loadAlbums:
//                return .run { [weak self] send in
//                    let albumsInfo = await self?.albumService.getAlbums_New(mediaType: .video)
//                    self?.albums = albumsInfo?.compactMap({ info in
//                        info.album
//                    }) ?? []
//                    await send(.assignAlbums)
//                }
//                
//            case .assignAlbums:
//                guard self.currentAlbumIndex < self.albums.count else {
//                    return .none
//                }
//                
//                return .run { send in
//                    let phAssets = self.photoService.convertAlbumToPHAssets_new(album: self.albums[self.currentAlbumIndex])
//                    self.currentPHAssets = phAssets
//                    
//                    await send(.loadInitialBatch)
//                }
//                
//            case .loadInitialBatch:
//                self.currentPage = 0
//                dataSource.removeAll()
//                self.hasMoreItems = true
//                
//                return .run { send in
//                    await send(.loadNextBatch)
//                }
//                
//            case .loadNextBatch:
//                guard state.currentLoadedImageCount == 0,
//                      hasMoreItems,
//                      !currentPHAssets.isEmpty else {
//                    print("모든 에셋이 다 로드 되었음 - 더 이상 불러올 이미지가 없음")
//                    return .none
//                }
//                
//                let startIndex = currentPage * batchSize
//                let endIndex = min(startIndex + batchSize, currentPHAssets.count)
//                
//                guard startIndex < currentPHAssets.count else {
//                    hasMoreItems = false
//                    print("startInde가 현재 에셋의 인덱스보다 큼")
//                    return .none
//                }
//                
//                state.currentLoadedImageCount = endIndex - startIndex
//                
//                let batchAssets = Array(self.currentPHAssets[startIndex..<endIndex])
//                let newItems: [PhotoCellInfo] = batchAssets.map { asset in
//                        .init(phAsset: asset,
//                              duration: self.convertTimeIntervalToString(asset.duration),
//                              selectedOrder: .none,
//                              localIdentifier: asset.localIdentifier)
//                }
//                return .run{ send in
//                   await send(.addDataSource(newItems))
//                }
//                
//            case .addDataSource(let newCellInfos):
//                state.dataSource.append(contentsOf: newCellInfos)
//                self.currentPage += 1
//                
//                return .none
//                
//            case .refreshAlbums:
//                return .none
//                
//                
//            case .imageLoadingCompleted:
//                self.currentLoadedImageCount -= 1
//                print("Image loaded, remaining: \(self.currentLoadedImageCount)")
//                
//                if self.currentLoadedImageCount <= 0 {
//                    self.currentLoadedImageCount = 0
////                    delegate?.updateScrollState(isEnabled: true)
////                    print("All images loaded, scroll enabled")
//                }
//            default:
//                return .none
//            }
//        }
//    }
//    
//    private func convertTimeIntervalToString(_ timeInterval: TimeInterval) -> String? {
//        let formatter = DateComponentsFormatter()
//        formatter.allowedUnits = [.minute, .second]
//        formatter.zeroFormattingBehavior = .pad
//        return formatter.string(from: timeInterval)
//    }
//}
