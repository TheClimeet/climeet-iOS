//
//  PhotoService.swift
//
//
//  Created by mac on 6/18/24.
//

import UIKit
import Photos

protocol PhotoService {
    func convertAlbumToPHAssets(album: PHFetchResult<PHAsset>,
                                completion: @escaping ([PHAsset]) -> Void)
    func fetchVideo(
        phAsset: PHAsset,
        size: CGSize,
        contentMode: PHImageContentMode
    ) async -> UIImage?
}

final class MyPhotoService: NSObject, PhotoService {
    private let imageManager = PHCachingImageManager()
   // private let cacher = NSCache<NSString, UIImage>()
    private let cacher = VideoThumbnailCacher.shared
    
    weak var delegate: PHPhotoLibraryChangeObserver?
    
    override init() {
        super.init()
        PHPhotoLibrary.shared().register(self)
    }
    
    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
    
    func convertAlbumToPHAssets(album: PHFetchResult<PHAsset>,
                                completion: @escaping ([PHAsset]) -> Void) {
        DispatchQueue.global().async {
            var phAssets = [PHAsset]()
            
            // PHAsset을 순회하며 배열에 추가
            album.enumerateObjects { asset, _, _ in
                phAssets.append(asset)
            }
            
            // 메인 스레드에서 completion 호출
            DispatchQueue.main.async {
                completion(phAssets)
            }
        }
    }
    
    func fetchVideo(
        phAsset: PHAsset,
        size: CGSize,
        contentMode: PHImageContentMode
    ) async -> UIImage? {
        let cacheKey = phAsset.localIdentifier
        
        if let cachedThumbnail = await VideoThumbnailCacher.shared.loadImage(forKey: cacheKey) {
            return cachedThumbnail
        }
        
        return await withCheckedContinuation { continuation in
            let options = PHVideoRequestOptions()
            options.isNetworkAccessAllowed = false
            options.deliveryMode = .fastFormat
            
            imageManager.requestAVAsset(forVideo: phAsset,
                                      options: options) { asset, _, _ in
                guard let avAsset = asset else {
                    continuation.resume(returning: nil)
                    return
                }
                
                let assetImageGenerator = AVAssetImageGenerator(asset: avAsset)
                assetImageGenerator.appliesPreferredTrackTransform = true
                
                do {
                    let cgImage = try assetImageGenerator.copyCGImage(at: .zero, actualTime: nil)
                    let thumbnailImage = UIImage(cgImage: cgImage)
                    
                    // actor의 메서드를 Task 내에서 호출
                    Task {
                        await VideoThumbnailCacher.shared.setImage(thumbnailImage, forKey: cacheKey)
                    }
                    
                    continuation.resume(returning: thumbnailImage)
                } catch {
                    continuation.resume(returning: nil)
                }
            }
        }
    }
}

extension MyPhotoService: PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        delegate?.photoLibraryDidChange(changeInstance)
    }
}
