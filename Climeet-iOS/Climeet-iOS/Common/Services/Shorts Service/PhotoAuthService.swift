//
//  PhotoAuthService.swift
//
//
//  Created by mac on 6/18/24.
//

import Foundation
import Photos
import UIKit
import SwiftUICore

protocol PhotoAuthService {
    var authorizationStatus: PHAuthorizationStatus { get }
    var isAuthorizationLimited: Bool { get }
    
    func requestAuthorization(completion: @escaping () -> Void)
    func didChangeSelectedPhotos(completion: @escaping () -> Void) 
}

extension PhotoAuthService {
    var isAuthorizationLimited: Bool {
        authorizationStatus == .limited
    }
    
    private func goToSetting() {
        guard let url = URL(string: UIApplication.openSettingsURLString),
              UIApplication.shared.canOpenURL(url)
        else { return }
        
        UIApplication.shared.open(url, completionHandler: nil)
    }
}

final class MyPhotoAuthService: NSObject, PhotoAuthService {
    var authorizationStatus: PHAuthorizationStatus {
        PHPhotoLibrary.authorizationStatus(for: .readWrite)
    }
    
    private var changeHandler: (() -> Void)?
    
    override init() {
        super.init()
        PHPhotoLibrary.shared().register(self)
    }
    
    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
    
    func didChangeSelectedPhotos(completion: @escaping () -> Void) {
        changeHandler = completion
    }
    
    func requestAuthorization() {
        
    }
    
    func requestAuthorization(completion: @escaping () -> Void) {
        //TODO: 권한처리세분화
        guard authorizationStatus != .denied else {
            
            //TODO: 사용자에게 선택 권한 제공 필요
            //self.goToSetting()
            completion()
            return
        }
        
        guard authorizationStatus != .notDetermined else {
            completion()
            return
        }
        
        guard authorizationStatus != .limited else {
            completion()
            return
        }
        
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
            DispatchQueue.main.async {
                completion()
            }
        }
    }
}

extension MyPhotoAuthService: PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.changeHandler?()
        }
    }
}
