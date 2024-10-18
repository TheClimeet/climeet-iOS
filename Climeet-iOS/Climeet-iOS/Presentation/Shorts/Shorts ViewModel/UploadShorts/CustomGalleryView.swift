//
//  CustomGalleryView.swift
//  Climeet-iOS
//
//  Created by mac on 9/13/24.
//

import Foundation
import SwiftUI

struct CustomGallery: UIViewControllerRepresentable {
    let viewModel: CustomGalleryViewModel
    
    init(_ viewModel: CustomGalleryViewModel) {
        self.viewModel = viewModel
    }
    
    func makeUIViewController(context: Context) -> PhotoViewController {
        let vc = PhotoViewController()
        vc.injectViewModel(viewModel)
        viewModel.loadAlbums()
        
        return vc
    }
    
    func updateUIViewController(_ uiViewController: PhotoViewController, context: Context) {
        // Implement any updates if needed
    }
}
