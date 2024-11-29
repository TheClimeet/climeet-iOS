//
//  PhotoClient.swift
//  Climeet-iOS
//
//  Created by mac on 11/29/24.
//

import Foundation
import Dependencies

struct PhotoServiceKey: DependencyKey {
    static let liveValue: PhotoService = MyPhotoService()
}

struct AlbumServiceKey: DependencyKey {
    static let liveValue: AlbumService = MyAlbumService()
}

struct PhotoAuthServiceKey: DependencyKey {
    static let liveValue: PhotoAuthService = MyPhotoAuthService()
}

extension DependencyValues {
    var photoService: PhotoService {
        get { self[PhotoServiceKey.self] }
        set { self[PhotoServiceKey.self] = newValue }
    }
    
    var albumService: AlbumService {
        get { self[AlbumServiceKey.self] }
        set { self[AlbumServiceKey.self] = newValue }
    }
    
    var photoAuthService: PhotoAuthService {
        get { self[PhotoAuthServiceKey.self] }
        set { self[PhotoAuthServiceKey.self] = newValue }
    }
}
