//
//  PhotoCell.swift
//  
//
//  Created by mac on 6/18/24.
//

import Foundation
import UIKit
import Photos

enum SelectionOrder: Equatable {
    case none
    case selected(Int)
}

class PhotoCellInfo {
    let phAsset: PHAsset
    var videoThumbnail: UIImage?
    let selectedOrder: SelectionOrder
    let localIdentifier: String
    
    init(phAsset: PHAsset, videoThumbnail: UIImage? = nil, 
         selectedOrder: SelectionOrder, localIdentifier: String) {
        self.phAsset = phAsset
        self.videoThumbnail = videoThumbnail
        self.selectedOrder = selectedOrder
        self.localIdentifier = localIdentifier
    }
}

final class PhotoCell: UICollectionViewCell {
    static let id = "PhotoCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = false
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let highlightedView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.borderWidth = 2.0
        view.backgroundColor = .black.withAlphaComponent(0.5)
        view.layer.borderColor = UIColor.systemBlue.cgColor
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let orderLabel: UILabel = {
        let label = UILabel()
        label.textColor = .green
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: Initializer
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("\(#function) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.masksToBounds = true // 주의: 이 값을 안 주면 이미지가 셀의 다른 영역을 침범하는 영향을 주는 것
        contentView.addSubview(imageView)
        imageView.addSubview(highlightedView)
//        highlightedView.addSubview(orderLabel)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            highlightedView.topAnchor.constraint(equalTo: imageView.topAnchor),
            highlightedView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            highlightedView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            highlightedView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
            
//            orderLabel.leadingAnchor.constraint(equalTo: highlightedView.leadingAnchor, constant: 4),
//            orderLabel.topAnchor.constraint(equalTo: highlightedView.topAnchor, constant: 4)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        prepare(info: nil)
    }
    
    func prepare(info: PhotoCellInfo?) {
        imageView.image = info?.videoThumbnail
        
        if case .selected(_) = info?.selectedOrder {
            highlightedView.isHidden = false
//            orderLabel.text = String(order)
        } else {
            highlightedView.isHidden = true
        }
    }
}
