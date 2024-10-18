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
    func fetchVideo(phAsset: PHAsset, size: CGSize,
                    contentMode: PHImageContentMode,
                    completion: @escaping (UIImage) -> Void
    )
}

final class MyPhotoService: NSObject, PhotoService {
    private let imageManager = PHCachingImageManager()
    private let cacher = NSCache<NSString, UIImage>()
    
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
        contentMode: PHImageContentMode,
        completion: @escaping (UIImage) -> Void
    ) {
        let cacheKey = NSString(string: phAsset.localIdentifier)
        if let cachedThumbnail = cacher.object(forKey: cacheKey) {
            completion(cachedThumbnail)
        }
        
        let options = PHVideoRequestOptions()
        options.isNetworkAccessAllowed = false
        options.deliveryMode = .fastFormat
        
        imageManager.requestAVAsset(forVideo: phAsset,
                                    options: options) { asset, _, _ in
            guard let avAsset = asset else {
                return
            }
            
            let assetImageGenerator = AVAssetImageGenerator(asset: avAsset)
            assetImageGenerator.appliesPreferredTrackTransform = true
            
            do {
                let cgImage = try assetImageGenerator.copyCGImage(at: .zero, actualTime: nil)
                let thumbnailImage = UIImage(cgImage: cgImage)
                
                completion(thumbnailImage)
                self.cacher.setObject(thumbnailImage, forKey: cacheKey)
            } catch(let error) {
                print(error)
            }
            
        }
    }
}

extension MyPhotoService: PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        delegate?.photoLibraryDidChange(changeInstance)
    }
}
