//
//  CustomGallery.swift
//
//
//  Created by mac on 6/19/24.
//

import Foundation
import SwiftUI
import Photos

protocol ShortsCustomGalleryDelegate: AnyObject {
    func updateItems(_ items: [PhotoCellInfo])
    func updateCells(at indexPaths: [IndexPath])
}

final class CustomGalleryViewModel: ObservableObject {
    var delegate: ShortsCustomGalleryDelegate?
    
    @Published private(set) var selectedVideoThumbnail: UIImage?
    @Published private(set) var selectedVideoIdentifier: String?
    @Published private(set) var selectedVideoURL: URL?
    
    //MARK: Batches
    private let batchSize = 20
    private var currentPage = 0
    private var hasMoreItems: Bool = false
    private var currentPHAssets: [PHAsset] = []
    private var currentThumbnailTask: Task<Void, Error>?
    
    private var activeLoadingTasks: Set<UUID> = []
    private var isProcessingSelection: Bool = false
    
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
        guard activeLoadingTasks.isEmpty,
              !isProcessingSelection,
              hasMoreItems,
              !currentPHAssets.isEmpty else {
            return
        }
        
        let startIndex = currentPage * batchSize
        let endIndex = min(startIndex + batchSize, currentPHAssets.count)
        
        guard startIndex < currentPHAssets.count else {
            hasMoreItems = false
            return
        }
        
        let loadingTaskId = startImageLoading()
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
            self.finishImageLoading(loadingTaskId)
        }
    }
    
    @MainActor
    func handleCellSelection(at indexPath: IndexPath) {
        guard indexPath.item < dataSource.count,
              activeLoadingTasks.isEmpty,
              !isProcessingSelection else {
            return
        }
        
        let info = dataSource[indexPath.item]
        currentThumbnailTask?.cancel()
        
        isProcessingSelection = true
        let taskId = startImageLoading()
        
        currentThumbnailTask = Task {
            defer {
                finishImageLoading(taskId)
                isProcessingSelection = false
            }
            
            if let highQualityThumbnail = await photoService.fetchHighQualityImage(
                phAsset: info.phAsset,
                size: selectedImageSize,
                contentMode: .aspectFit,
                deliveryMode: .highQualityFormat
            ) {
                if !Task.isCancelled {
                    selectedVideoThumbnail = highQualityThumbnail
                    selectedVideoIdentifier = info.localIdentifier
                    requestVideoURL(for: info)
                }
            }
            
            if !Task.isCancelled {
                await updateSelectionState(for: indexPath, with: info)
            }
        }
    }
    
    private func startImageLoading() -> UUID {
        let taskId = UUID()
        activeLoadingTasks.insert(taskId)
        return taskId
    }
    
    private func finishImageLoading(_ taskId: UUID) {
        activeLoadingTasks.remove(taskId)
    }
    
    private func convertTimeIntervalToString(_ timeInterval: TimeInterval) -> String? {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: timeInterval)
    }
    
    private func updateSelectionState(for indexPath: IndexPath, with info: PhotoCellInfo) async {
        var updatingIndexPaths: [IndexPath] = []
        switch info.selectedOrder {
        case .selected:
            updateCell(at: indexPath.item, withOrder: .none)
            selectedIndex = indexPath.item
            updatingIndexPaths.append(indexPath)
            
        case .none:
            if let prevIndex = prevIndex {
                updateCell(at: prevIndex, withOrder: .none)
                updatingIndexPaths.append(IndexPath(item: prevIndex, section: 0))
            }
            
            selectedIndex = indexPath.item
            updateCell(at: indexPath.item, withOrder: .selected)
            updatingIndexPaths.append(indexPath)
            prevIndex = selectedIndex
        }
        
        await MainActor.run {
            notifyUIUpdate(for: updatingIndexPaths)
        }
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
    
    private func notifyUIUpdate(for indexPaths: [IndexPath]) {
        delegate?.updateCells(at: indexPaths)
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
