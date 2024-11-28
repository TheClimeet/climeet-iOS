//
//  CustomGallery.swift
//
//
//  Created by mac on 6/19/24.
//

import Foundation
import SwiftUI
import Photos

final class CustomGalleryViewModel: ObservableObject {
    var delegate: ShortsCustomGalleryDelegate?
    
    @Published private(set) var selectedVideoThumbnail: UIImage?
    @Published private(set) var selectedVideoIdentifier: String?
    @Published private(set) var selectedVideoURL: URL?
    
    //MARK: Batches
    private let batchSize = 24
    private var currentPage = 0
    private var hasMoreItems: Bool = false
    private var currentPHAssets: [PHAsset] = []
    private var currentLoadedImageCount = 0
    
    private(set) var dataSource = [PhotoCellInfo]()
    private var selectedIndex: Int?
    private var prevIndex: Int?
    
    //MARK: Load User Photos Property
    private let photoService: PhotoService = MyPhotoService()
    private let albumService: AlbumService = MyAlbumService()
    private let photoAuthService: PhotoAuthService = MyPhotoAuthService()

    private var albums = [PHFetchResult<PHAsset>]()
    private var currentAlbumIndex = 0 {
        didSet { assignAlbums() }
    }
    
    init() {
        loadAlbums()
        photoAuthService.didChangeSelectedPhotos {
            self.loadAlbums()
        }
    }
    
    func requestPhotoAuthrization() {
        //TODO: 내부 구현
        photoAuthService.requestAuthorization {
            
        }
    }
    
    func bringVisibleCellCount() -> Int {
        return dataSource.count
    }
    
    private func loadAlbums() {
        albumService.getAlbums(mediaType: .video) { [weak self] albumInfos in
            self?.albums = albumInfos.map({ $0.album })
            self?.assignAlbums()
        }
    }
    
    private func assignAlbums() {
        guard currentAlbumIndex < albums.count else { return }
        self.photoService.convertAlbumToPHAssets(album: albums[currentAlbumIndex]) { [weak self] phAssets in
            guard let self = self else { return }
            self.currentPHAssets = phAssets
            self.loadInitialBatch()
        }
    }
    
    private func loadInitialBatch() {
        self.currentPage = 0
        dataSource.removeAll()
        self.hasMoreItems = true
        loadNextBatch()
    }
    
    func loadNextBatch() {
        guard currentLoadedImageCount == 0,
              hasMoreItems,
              !currentPHAssets.isEmpty else {
            print("모든 에셋이 다 로드 되었음 - 더 이상 불러올 이미지가 없음")
            return
        }
        
        let startIndex = currentPage * batchSize
        let endIndex = min(startIndex + batchSize, currentPHAssets.count)
        
        guard startIndex < currentPHAssets.count else {
            hasMoreItems = false
            print("startInde가 현재 에셋의 인덱스보다 큼")
            return
        }
        
        currentLoadedImageCount = endIndex - startIndex
        
        let batchAssets = Array(currentPHAssets[startIndex..<endIndex])
        let newItems: [PhotoCellInfo] = batchAssets.map { asset in
                .init(phAsset: asset,
                      duration: convertTimeIntervalToString(asset.duration),
                      selectedOrder: .none,
                      localIdentifier: asset.localIdentifier)
        }
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.dataSource.append(contentsOf: newItems)
            self.currentPage += 1
            self.delegate?.updateItems(self.dataSource)
        }
    }
    
    private func convertTimeIntervalToString(_ timeInterval: TimeInterval) -> String? {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: timeInterval)
    }
    
    func imageLoadingCompleted() {
        currentLoadedImageCount -= 1
        print("Image loaded, remaining: \(currentLoadedImageCount)")
        
        if currentLoadedImageCount <= 0 {
            currentLoadedImageCount = 0
            delegate?.updateScrollState(isEnabled: true)
            print("All images loaded, scroll enabled")
        }
    }
    
    @MainActor
    func handleCellSelection(at indexPath: IndexPath) {
        guard indexPath.item < dataSource.count else { return }
        
        let info = dataSource[indexPath.item]
        var updatingIndexPaths: [IndexPath] = []
        
        switch info.selectedOrder {
        case .selected:
            // 이미 선택된 셀을 다시 선택한 경우 -> 선택 해제
            updateCell(at: indexPath.item, withOrder: .none)
            selectedIndex = indexPath.item
            updatingIndexPaths.append(indexPath)
            
        case .none:
            // 새로운 셀 선택
            if let prevIndex = prevIndex {
                // 이전 선택된 셀이 있으면 해제
                updateCell(at: prevIndex, withOrder: .none)
                updatingIndexPaths.append(IndexPath(item: prevIndex, section: 0))
            }
            
            // 새로운 셀 선택 상태로 업데이트
            selectedIndex = indexPath.item
            updateCell(at: indexPath.item, withOrder: .selected(indexPath.item))
            updatingIndexPaths.append(indexPath)
            
            // 선택된 비디오 정보 업데이트
            Task {
                await setSelectedVideoInfo(info)
                requestVideoURL(for: info)
            }
            
            prevIndex = selectedIndex
        }

        // UI 업데이트 알림
        notifyUIUpdate(for: updatingIndexPaths)
    }
    
    private func notifyUIUpdate(for indexPaths: [IndexPath]) {
        delegate?.updateCells(at: indexPaths)
    }
    
    private func updateCell(at index: Int, withOrder order: SelectionOrder) {
        guard index < dataSource.count else { return }
        let current = dataSource[index]
        
        dataSource[index] = PhotoCellInfo(
            phAsset: current.phAsset,
            videoThumbnail: current.videoThumbnail,
            duration: current.duration,
            selectedOrder: order,
            localIdentifier: current.localIdentifier
        )
    }
    
    private let selectedImageSize: CGSize = {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        let width = screenWidth * (189.0 / 375.0)  // thumbnailWidthProportion
        let height = screenHeight * (416.0 / 894.0) // thumbnailHeightProportion
        return CGSize(width: width * 3, height: height * 3)
    }()
    
    private func setSelectedVideoInfo(_ info: PhotoCellInfo) async {
        if let highQualityThumbnail = await photoService.fetchHighQualityImage(
            phAsset: info.phAsset,
            size: selectedImageSize,
            contentMode: .aspectFit,
            deliveryMode: .highQualityFormat
        ) {
            Task { @MainActor in
                selectedVideoThumbnail = highQualityThumbnail
                selectedVideoIdentifier = info.localIdentifier
            }
        }
    }
    
    private func requestVideoURL(for info: PhotoCellInfo) {
        let options = PHVideoRequestOptions()
        options.isNetworkAccessAllowed = true
        
        PHImageManager.default().requestAVAsset(forVideo: info.phAsset,
                                                options: options) { [weak self] (avAsset, _, _) in
            if let urlAsset = avAsset as? AVURLAsset {
                DispatchQueue.main.async {
                    self?.selectedVideoURL = urlAsset.url
                }
            }
        }
    }
}
