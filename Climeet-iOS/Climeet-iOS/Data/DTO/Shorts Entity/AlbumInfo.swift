//
//  AlbumInfo.swift
//  
//
//  Created by mac on 6/18/24.
//

import Foundation
import Photos

struct AlbumInfo: Identifiable {
    let id: String?
    let name: String
    let album: PHFetchResult<PHAsset>
    
    init(fetchResult: PHFetchResult<PHAsset>, albumName: String) {
        id = nil
        name = albumName
        album = fetchResult
    }
}
