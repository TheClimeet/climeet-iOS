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
        contentMode: PHImageContentMode,
        deliveryMode: PHVideoRequestOptionsDeliveryMode
    ) async -> UIImage?
    
    func fetchHighQualityImage(
        phAsset: PHAsset,
        size: CGSize,
        contentMode: PHImageContentMode,
        deliveryMode: PHVideoRequestOptionsDeliveryMode 
    ) async -> UIImage?
}

final class MyPhotoService: NSObject, PhotoService {
    private let imageManager = PHCachingImageManager()
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
    
    func fetchHighQualityImage(
        phAsset: PHAsset,
        size: CGSize,
        contentMode: PHImageContentMode,
        deliveryMode: PHVideoRequestOptionsDeliveryMode = .highQualityFormat
    ) async -> UIImage? {
        return await withCheckedContinuation { continuation in
            let options = generateVideoRequestOptions(deliveryMode, true)
            imageManager.requestAVAsset(forVideo: phAsset, options: options) { [weak self] asset, _, info in
                guard let avAsset = asset else {
                    Log.error("No asset returned for identifier: \(phAsset.localIdentifier)")
                    continuation.resume(returning: UIImage())
                    return
                }
                
                self?.convertAVAssetToUIImage(avAsset: avAsset, convertSize: size,
                                              cacheKey: nil, continuation)
            }
        }
    }
    
    private func generateVideoRequestOptions(_ deliveryMode: PHVideoRequestOptionsDeliveryMode,
                                             _ isiColudAllowed: Bool) -> PHVideoRequestOptions {
        let options = PHVideoRequestOptions()
        options.isNetworkAccessAllowed = isiColudAllowed
        options.deliveryMode = deliveryMode
        options.version = .current
        return options
    }
    
    func fetchVideo(
        phAsset: PHAsset,
        size: CGSize,
        contentMode: PHImageContentMode,
        deliveryMode: PHVideoRequestOptionsDeliveryMode
    ) async -> UIImage? {
        let cacheKey = phAsset.localIdentifier
        
        if let cachedThumbnail = await cacher.loadImage(forKey: cacheKey) {
            return cachedThumbnail
        }
        
        return await withCheckedContinuation { continuation in
            let options = generateVideoRequestOptions(deliveryMode, true)
                imageManager.requestAVAsset(forVideo: phAsset, options: options) { [weak self] asset, _, info in
                    guard let avAsset = asset else {
                        Log.error("No asset returned for identifier: \(phAsset.localIdentifier)")
                        continuation.resume(returning: UIImage())
                        return
                    }
                    
                    self?.convertAVAssetToUIImage(avAsset: avAsset, convertSize: size,
                                                  cacheKey: cacheKey, continuation)
                }
            }
    }

    
    private func convertAVAssetToUIImage(avAsset: AVAsset, convertSize: CGSize, cacheKey: String?,
                                         _ continuation: (CheckedContinuation<UIImage?, Never>)) {
        let assetImageGenerator = AVAssetImageGenerator(asset: avAsset)
        assetImageGenerator.appliesPreferredTrackTransform = true
        assetImageGenerator.maximumSize = convertSize
        
        do {
            let cgImage = try assetImageGenerator.copyCGImage(at: .zero, actualTime: nil)
            let thumbnailImage = UIImage(cgImage: cgImage)
            cacheImage(cacheKey, thumbnailImage)
            continuation.resume(returning: thumbnailImage)
        } catch {
            Log.error("Thumbnail generation error: \(error)")

            continuation.resume(returning: nil)
        }
    }
    
    private func cacheImage(_ cacheKey: String?, _ thumbnailImage: UIImage) {
        if let cacheKey = cacheKey {
            Task { [weak self] in
                await self?.cacher.setImage(thumbnailImage, forKey: cacheKey)
            }
        }
    }
}

extension MyPhotoService: PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        delegate?.photoLibraryDidChange(changeInstance)
    }
}
