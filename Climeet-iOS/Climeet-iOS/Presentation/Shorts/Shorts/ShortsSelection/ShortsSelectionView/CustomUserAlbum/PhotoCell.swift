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
    case selected
}

enum PhotoSection {
    case main
}

class PhotoCellInfo: Hashable {
    let id: String
    
    let phAsset: PHAsset
    var videoThumbnail: UIImage?
    let duration: String?
    var selectedOrder: SelectionOrder
    let localIdentifier: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: PhotoCellInfo, rhs: PhotoCellInfo) -> Bool {
        return lhs.id == rhs.id
    }
    
    init(phAsset: PHAsset, videoThumbnail: UIImage? = nil,
         duration: String?, selectedOrder: SelectionOrder,
         localIdentifier: String) {
        self.id = phAsset.localIdentifier
        self.phAsset = phAsset
        self.videoThumbnail = videoThumbnail
        self.duration = duration
        self.selectedOrder = selectedOrder
        self.localIdentifier = localIdentifier
    }
}

final class PhotoCell: UICollectionViewCell {
    static let id = "PhotoCell"
    var currentTask: Task<Void, Never>?
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = false
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let highlightedView: UIView = {
        let view = UIView()
        view.backgroundColor = .yellow
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
            
            highlightedView.topAnchor.constraint(equalTo: contentView.topAnchor),
            highlightedView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            highlightedView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            highlightedView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            durationLabel.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -2),
            durationLabel.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -2),
            durationLabel.heightAnchor.constraint(equalToConstant: 20),
            durationLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 40)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        resetCellContents()
    }
    
    func configure(info: PhotoCellInfo?) {
        print("Configure cell with selection state: \(String(describing: info?.selectedOrder))")
        
        imageView.image = info?.videoThumbnail
        
        if let duration = info?.duration {
            durationLabel.text = duration
            durationLabel.isHidden = false
        } else {
            durationLabel.isHidden = true
        }
        
        if info?.selectedOrder == .selected {
            print("Cell should be highlighted")
            highlightedView.isHidden = false
            highlightedView.backgroundColor = UIColor.blue.withAlphaComponent(0.3)
        } else {
            print("Cell should not be highlighted")
            highlightedView.isHidden = true
        }
    }
    
    private func resetCellContents() {
        currentTask?.cancel()
        currentTask = nil
        
        imageView.image = nil
        highlightedView.isHidden = true
        durationLabel.isHidden = true
    }
}
