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
    private(set) var dataSource = [PhotoCellInfo]()
    var delegate: ShortsCustomGalleryDelegate?

    @Published private(set) var selectedVideoThumbnail: UIImage?
    @Published private(set) var selectedVideoIdentifier: String?
    @Published private(set) var selectedVideoURL: URL?
    
    private var selectedIndex: Int?
    private var prevIndex: Int?
    
    private let photoService: PhotoService = MyPhotoService()
    private var selectedVideoFileURL: URL?
    private let albumService: AlbumService = MyAlbumService()
    private var albums = [PHFetchResult<PHAsset>]()
    private var currentAlbumIndex = 0 {
        didSet { assignAlbums() }
    }

    func loadAlbums() {
        albumService.getAlbums(mediaType: .video) { [weak self] albumInfos in
            self?.albums = albumInfos.map({ info in
                info.album
            })
            
            self?.assignAlbums()
        }
    }
    
    func refreshAlbums() {
        self.loadAlbums()
        self.delegate?.informAlbumsDownload()
    }
    
    private func assignAlbums() {
        guard currentAlbumIndex < albums.count else { return }
        let album = albums[currentAlbumIndex]
        
        self.photoService.convertAlbumToPHAssets(album: album) { [weak self] phAssets in
            self?.dataSource = phAssets.map { .init(phAsset: $0,
                                                    videoThumbnail: nil,
                                                    duration: self?.convertTimeIntervalToString($0.duration),
                                                    selectedOrder: .none,
                                                    localIdentifier: $0.localIdentifier) }
            
            self?.delegate?.informAlbumsDownload()
        }
    }
    
    private func convertTimeIntervalToString(_ timeInterval: TimeInterval) -> String? {
        let formatter: DateComponentsFormatter = .init()
        formatter.allowedUnits = [.minute, .second]
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: timeInterval)
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
            setSelectedVideoInfo(info)
            requestVideoURL(for: info)
            
            prevIndex = selectedIndex
        }
        
        // UI 업데이트 알림
        notifyUIUpdate(for: updatingIndexPaths)
    }
    
    // 개별 셀 상태 업데이트
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
    
    // 선택된 비디오 정보 설정
    private func setSelectedVideoInfo(_ info: PhotoCellInfo) {
        selectedVideoThumbnail = info.videoThumbnail
        selectedVideoIdentifier = info.localIdentifier
    }
    
    // 비디오 URL 요청
    private func requestVideoURL(for info: PhotoCellInfo) {
        let options = PHVideoRequestOptions()
        options.isNetworkAccessAllowed = false
        
        PHImageManager.default().requestAVAsset(forVideo: info.phAsset,
                                                options: options) { [weak self] (avAsset, _, _) in
            if let urlAsset = avAsset as? AVURLAsset {
                DispatchQueue.main.async {
                    self?.selectedVideoURL = urlAsset.url
                }
            }
        }
    }
    
    // UI 업데이트 통지
    private func notifyUIUpdate(for indexPaths: [IndexPath]) {
        delegate?.updateCells(at: indexPaths)
    }
    
    // 모든 선택 해제
    func clearSelection() {
        guard let prevIndex = prevIndex,
              prevIndex < dataSource.count else { return }
        
        updateCell(at: prevIndex, withOrder: .none)
        self.prevIndex = nil
        self.selectedIndex = nil
        
        notifyUIUpdate(for: [IndexPath(item: prevIndex, section: 0)])
    }
}
