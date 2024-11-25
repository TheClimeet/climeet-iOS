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
    var dataSource = [PhotoCellInfo]()
    
    @Published var selectedVideoThumbnail: UIImage?
    @Published var selectedVideoIdentifier: String?
    
    var delegate: ShortsCustomGalleryDelegate?
    
    private let albumService: AlbumService = MyAlbumService()
    private var albums = [PHFetchResult<PHAsset>]()
    private var currentAlbumIndex = 0 {
        didSet { assignAlbums() }
    }
    
    private let photoService: PhotoService = MyPhotoService()
    private var selectedVideoFileURL: URL?
    
    func setSelectedVideoURL(_ url: URL) {
        self.selectedVideoFileURL = url
    }
    
    func bringSelectedVideoURL() -> URL? {
        return self.selectedVideoFileURL
    }
    
    func loadAlbums() {
        albumService.getAlbums(mediaType: .video) { [weak self] albumInfos in
            self?.albums = albumInfos.map({ info in
                info.album
            })
            
            self?.assignAlbums()
        }
    }
    
    private func assignAlbums() {
        guard currentAlbumIndex < albums.count else { return }
        let album = albums[currentAlbumIndex]
        
        self.photoService.convertAlbumToPHAssets(album: album) { [weak self] phAssets in
            self?.dataSource = phAssets.map { .init(phAsset: $0,
                                                    videoThumbnail: nil,
                                                    selectedOrder: .none,
                                                    localIdentifier: $0.localIdentifier) }
            //TODO: 여기서 이미지변환 같이 하기 시도 -> 실패 여전히 priority inversion
            self?.delegate?.informAlbumsDownload()
        }
    }
}
