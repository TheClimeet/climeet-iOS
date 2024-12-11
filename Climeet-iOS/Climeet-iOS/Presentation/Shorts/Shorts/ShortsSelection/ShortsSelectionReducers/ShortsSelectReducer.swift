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
        var shortsVideoData: Data?
        var shortsThumbnail: UIImage?
        var customGallerySelectedAsset: PHAsset?
        
        var gallery = CustomGalleryReducer.State()
        var path = StackState<Path.State>()
        static func == (lhs: ShortsSelectReducer.State, rhs: ShortsSelectReducer.State) -> Bool {
            lhs.shortsVideoData == rhs.shortsVideoData
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
        
        case convertSelectedVideoToData
        case assignShortsVideoData(Data)
        //        case assignThumbnailImageData(Data)
        case assignThumbnailImage(UIImage?)
        case navigateToNextView
        
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
                //MARK: On Appear
            case .readViewSize(let size):
                state.screenSize = size
                return .none
                
                //MARK: Go to Next View
            case .tapNextButton:
                return .run { send in
                    await send(.convertSelectedVideoToData)
                }
                
            case .convertSelectedVideoToData:
                return .run { [asset = state.customGallerySelectedAsset] send in
                    guard let asset = asset else {
                        return
                    }
                    
                    guard let videoData = await photoService.fetchVideoData(from: asset) else {
                        return
                    }
                    
                    await send(.assignShortsVideoData(videoData))
                    await send(.navigateToNextView)
                }
                
            case .navigateToNextView:
                guard let data = state.shortsVideoData,
                      let image = state.shortsThumbnail else {
                    return .none
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
                
            case let .assignShortsVideoData(data):
                state.shortsVideoData = data
                return .none
                
            case .assignThumbnailImage(let image):
                state.shortsThumbnail = image
                return .none
                
                //MARK: Custom Gallery
            case .gallery(.highQualityThumbnailLoaded(let thumbnail)):
                state.shortsThumbnail = thumbnail
                return .none
                
            case let .gallery(.saveSelectedVideoInfo(asset)):
                state.customGallerySelectedAsset = asset
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

