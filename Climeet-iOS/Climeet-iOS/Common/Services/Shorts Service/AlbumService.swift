//
//  AlbumService.swift
//
//
//  Created by mac on 6/18/24.
//

import Foundation
import Photos
import UIKit

protocol AlbumService {
    func getAlbums(mediaType: MediaType, completion: @escaping ([AlbumInfo]) -> Void)
}

//TODO: 추후 Repository패턴 등 이용하여 앱 시작 시 사용자 앨범 비동기적으로 가져오는 작업 필요
final class MyAlbumService: AlbumService {
    func getAlbums(mediaType: MediaType, completion: @escaping ([AlbumInfo]) -> Void) {
        DispatchQueue.global().async { [weak self] in
            // 0. albums 변수 선언
            var albums = [AlbumInfo]()
            defer { completion(albums) }
            
            // 1. query 설정
            let fetchOptions = PHFetchOptions()
            fetchOptions.predicate = self?.getPredicate(mediaType: mediaType)
            fetchOptions.sortDescriptors = self?.getSortDescriptors
            
            // 2. standard 앨범을 query로 이미지 가져오기
            let standardFetchResult = PHAsset.fetchAssets(with: fetchOptions)
            albums.append(.init(fetchResult: standardFetchResult, albumName: mediaType.title))
            
            // 3. smart 앨범을 query로 이미지 가져오기
//            let smartAlbums = PHAssetCollection.fetchAssetCollections(
//                with: .smartAlbum,
//                subtype: .any,
//                options: PHFetchOptions()
//            )
//
//            smartAlbums.enumerateObjects { [weak self] phAssetCollection, index, pointer in
//                guard let self, index <= smartAlbums.count - 1 else {
//                    pointer.pointee = true
//                    return
//                }
//
//                // 값을 빠르게 받아오지 못하는 경우
//                if phAssetCollection.estimatedAssetCount == NSNotFound {
//                    // 쿼리를 날려서 가져오기
//                    let fetchOptions = PHFetchOptions()
//                    fetchOptions.predicate = self.getPredicate(mediaType: mediaType)
//                    fetchOptions.sortDescriptors = self.getSortDescriptors
//
//                    DispatchQueue.global(qos: .userInitiated).async {
//                        let fetchResult = PHAsset.fetchAssets(in: phAssetCollection, options: fetchOptions)
//                        albums.append(.init(fetchResult: fetchResult, albumName: mediaType.title))
//                    }
//                }
//            }
        }
    }
    
    private func getPredicate(mediaType: MediaType) -> NSPredicate {
        let format = "mediaType == %d"
        switch mediaType {
        case .all:
            return NSPredicate(
                format: format + " || " + format,
                PHAssetMediaType.image.rawValue,
                PHAssetMediaType.video.rawValue
            )
        case .image:
            return NSPredicate(
                format: format,
                PHAssetMediaType.image.rawValue
            )
        case .video:
            return NSPredicate(
                format: format,
                PHAssetMediaType.video.rawValue
            )
        }
    }
    
    private let getSortDescriptors = [
        NSSortDescriptor(key: "creationDate", ascending: false),
        NSSortDescriptor(key: "modificationDate", ascending: false)
    ]
}

enum MediaType {
    case all
    case image
    case video
    
    var title: String {
        switch self {
        case .all:
            return "이미지와 비디오"
        case .image:
            return "이미지"
        case .video:
            return "비디오"
        }
    }
}
