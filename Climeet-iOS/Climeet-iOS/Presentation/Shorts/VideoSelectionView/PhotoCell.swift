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
    let duration: String?
    let selectedOrder: SelectionOrder
    let localIdentifier: String
    
    init(phAsset: PHAsset, videoThumbnail: UIImage? = nil,
         duration: String?, selectedOrder: SelectionOrder,
         localIdentifier: String) {
        self.phAsset = phAsset
        self.videoThumbnail = videoThumbnail
        self.duration = duration
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
        view.layer.borderWidth = 1.0
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
    
    private let durationLabel: UILabel = {
           let label = UILabel()
           label.textColor = .white
           label.font = .systemFont(ofSize: 12, weight: .medium)
           label.translatesAutoresizingMaskIntoConstraints = false
           label.backgroundColor = .black.withAlphaComponent(0.6)
           label.textAlignment = .center
           label.layer.cornerRadius = 4
           label.clipsToBounds = true
           return label
       }()
    
    // MARK: Initializer
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("\(#function) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.masksToBounds = true
        contentView.addSubview(imageView)
        imageView.addSubview(highlightedView)
        imageView.addSubview(durationLabel)

        NSLayoutConstraint.activate([
                   imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
                   imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                   imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                   imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                   
                   highlightedView.topAnchor.constraint(equalTo: imageView.topAnchor),
                   highlightedView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
                   highlightedView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
                   highlightedView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
                   
                   durationLabel.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -2),
                   durationLabel.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -2),
                   durationLabel.heightAnchor.constraint(equalToConstant: 20),
                   durationLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 40)
               ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        prepare(info: nil)
    }
    
    func prepare(info: PhotoCellInfo?) {
           imageView.image = info?.videoThumbnail
           
           if let duration = info?.duration {
               durationLabel.text = duration
               durationLabel.isHidden = false
           } else {
               durationLabel.isHidden = true
           }
           
           if case .selected(_) = info?.selectedOrder {
               highlightedView.isHidden = false
           } else {
               highlightedView.isHidden = true
           }
       }
       
       private func resetCellContents() {
           self.imageView.image = nil
           highlightedView.isHidden = true
           durationLabel.isHidden = true
       }
}
