//
//  ShortsSelectReducer.swift
//  Climeet-iOS
//
//  Created by mac on 6/19/24.
//

import Foundation
import ComposableArchitecture
import UIKit
import SwiftUI
import _PhotosUI_SwiftUI

@Reducer
struct ShortsSelectReducer {
    @ObservableState
    struct State: Equatable {
        var screenSize = CGSize(width: 0, height: 0)
        var shortsThumbnailData: Data?
        var shortsData: Data?
        var shortsThumbnail: UIImage?
        
        var gallery = CustomGalleryReducer.State()
        var path = StackState<Path.State>()
        static func == (lhs: ShortsSelectReducer.State, rhs: ShortsSelectReducer.State) -> Bool {
            lhs.shortsData == rhs.shortsData
        }
    }
    
    @Reducer(state: .equatable)
    enum Path {
        case videoTagView(ShortsTagAddReducer)
        case uploadView(ShortsPostingReducer)
    }
    
    enum Action {
        case readViewSize(CGSize)
        case tapNextButton
        case showErrorSheet
        case showPhotoPicker
        
        case changedPhotoPickerItem(PhotosPickerItem?)
        case convertShortsToData(PhotosPickerItem)
        
        case assignShortsVideoData(Data)
        case assignThumbnailImageData(Data)
        case assignThumbnailImage(UIImage?)
        
        case delegate(Delegation)
        case path(StackActionOf<Path>)
        case gallery(CustomGalleryReducer.Action)
        
        enum Delegation {
            case goToVideoTagView(UIImage?, URL?)
        }
    }
    
    @Dependency(\.photoService) var photoService
    var body: some ReducerOf<Self> {
        Scope(state: \.gallery, action: \.gallery) {
            CustomGalleryReducer()
        }
        
        Reduce { state, action in
            switch action {
            case .readViewSize(let size):
                state.screenSize = size
                return .none
                
            case .tapNextButton:
                guard let image = state.shortsThumbnail,
                      let data = state.shortsData else {
                    return .send(.showErrorSheet)
                }
                
                state.path.append(
                    .videoTagView(ShortsTagAddReducer.State(
                        selectedVideoThumbnail: image,
                        selectedVideoData: data
                    ))
                )
                return .none
                
                //MARK: PhotoPicker Sheet
            case .changedPhotoPickerItem(let photoItem):
                guard let photoItem = photoItem else {
                    return .none
                }
                
                return .run { send in
                    async let imageTask = photoService.loadImage(from: photoItem)
                    async let videoTask = photoService.loadVideoData(from: photoItem)

                    if let image = await imageTask,
                       let videoData = await videoTask {
                        await send(.assignThumbnailImage(image))
                        await send(.assignShortsVideoData(videoData))
                    }
                }
                
            case .assignShortsVideoData(let data):
                state.shortsData = data
                return .none
            case .assignThumbnailImage(let image):
                state.shortsThumbnail = image
                return .none
                
            case .assignThumbnailImageData(let data):
                state.shortsThumbnailData = data
                return .none
                
                //MARK: Custom Gallery
            case .gallery(.highQualityThumbnailLoaded(let thumbnail)):
                state.shortsThumbnail = thumbnail
                return .none
                
            case .gallery(.assignVideoData(let data)):
                state.shortsData = data
                return .none
                
            case .path(.element(id: _, action: .videoTagView(.startUploading))):
                return .none
                
            case .path(.element(id: _, action: .videoTagView(.delegate(.shortsData(let shorts))))):
                state.path.append(.uploadView(ShortsPostingReducer.State(shorts: shorts)))
                return .none
                
            default:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
}

