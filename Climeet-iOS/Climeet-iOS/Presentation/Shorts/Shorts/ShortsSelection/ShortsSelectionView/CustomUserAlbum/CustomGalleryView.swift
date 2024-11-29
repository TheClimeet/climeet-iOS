//
//  CustomGalleryView.swift
//  Climeet-iOS
//
//  Created by mac on 9/13/24.
//

import Foundation
import SwiftUI
import ComposableArchitecture

struct CustomGallery: UIViewControllerRepresentable {
    let store: StoreOf<CustomGalleryReducer>
    
    init(_ store: StoreOf<CustomGalleryReducer>) {
        self.store = store
    }
    
    func makeUIViewController(context: Context) -> PhotoViewController {
        return PhotoViewController(store: store)
    }
    
    func updateUIViewController(_ uiViewController: PhotoViewController, context: Context) {}
}
