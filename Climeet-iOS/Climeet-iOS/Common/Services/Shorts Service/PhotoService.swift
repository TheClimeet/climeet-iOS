//
//  PhotoService.swift
//
//
//  Created by mac on 6/18/24.
//

import UIKit
import Photos
import _PhotosUI_SwiftUI

protocol PhotoService {
    func convertAlbumToPHAssets(album: PHFetchResult<PHAsset>,
                                completion: @escaping ([PHAsset]) -> Void)
    
    func convertAlbumToPHAssets_new(album: PHFetchResult<PHAsset>) async -> [PHAsset]
    
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
    
    func fetchVideoData(from asset: PHAsset) async -> Data?
    
    func loadImage(from item: PhotosPickerItem) async -> UIImage?
    
    func loadVideoData(from item: PhotosPickerItem) async -> Data?
}

final class MyPhotoService: NSObject, PhotoService {
    func convertAlbumToPHAssets_new(album: PHFetchResult<PHAsset>) async -> [PHAsset] {
        return await withCheckedContinuation { continuation in
            DispatchQueue.global().async {
                var phAssets = [PHAsset]()
                
                // PHAsset을 순회하며 배열에 추가
                album.enumerateObjects { asset, _, _ in
                    phAssets.append(asset)
                }
                
                // 메인 스레드에서 completion 호출
                DispatchQueue.main.async {
                    continuation.resume(returning: phAssets)
                }
            }
        }
    }
    
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
            
            album.enumerateObjects { asset, _, _ in
                phAssets.append(asset)
            }
            
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
            imageManager.requestAVAsset(forVideo: phAsset,
                                        options: options) { [weak self] asset, _, info in
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
    
    private func generateVideoRequestOptions(_ deliveryMode: PHVideoRequestOptionsDeliveryMode,
                                             _ isiColudAllowed: Bool) -> PHVideoRequestOptions {
        let options = PHVideoRequestOptions()
        options.isNetworkAccessAllowed = isiColudAllowed
        options.deliveryMode = deliveryMode
        options.version = .current
        return options
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
    
    func fetchVideoData(from asset: PHAsset) async -> Data? {
        return await withCheckedContinuation { continuation in
            let resources = PHAssetResource.assetResources(for: asset)
            guard let videoResource = resources.first(where: { $0.type == .video }) else {
                continuation.resume(returning: nil)
                return
            }
            
            let options = PHAssetResourceRequestOptions()
            options.isNetworkAccessAllowed = true
            
            let data = NSMutableData()
            
            PHAssetResourceManager.default().requestData(
                for: videoResource,
                options: options,
                dataReceivedHandler: { (newData) in
                    data.append(newData)
                },
                completionHandler: { (error) in
                    if let error = error {
                        continuation.resume(returning: nil)
                    } else {
                        continuation.resume(returning: data as Data)
                    }
                }
            )
        }
    }
    
    //MARK: For PhotoPicker
    func loadImage(from item: PhotosPickerItem) async -> UIImage? {
        let data = await translateToData(from: item)
        
        let temporaryFileURL = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
            .appendingPathExtension("mov")
        
        try? data?.write(to: temporaryFileURL)
        
        let asset = AVAsset(url: temporaryFileURL)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        
        let time = CMTime(seconds: 0, preferredTimescale: 600)
        guard let cgImage = try? generator.copyCGImage(at: time, actualTime: nil) else{
            return nil
        }
        
        let thumbnail = UIImage(cgImage: cgImage)
        
        try? FileManager.default.removeItem(at: temporaryFileURL)
        return thumbnail
    }
    
    private func translateToData(from videoItem: PhotosPickerItem) async -> Data? {
        guard videoItem.supportedContentTypes.contains(where: { $0.conforms(to: .movie) }) else {
            return nil
        }
        
        guard let videoData = try? await videoItem.loadTransferable(type: Data.self) else {
            return nil
        }
        
        return videoData
    }
    
    func loadVideoData(from item: PhotosPickerItem) async -> Data? {
        return try? await item.loadTransferable(type: Data.self)
    }
    
}

extension MyPhotoService: PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        delegate?.photoLibraryDidChange(changeInstance)
    }
}
