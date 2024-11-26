//
//  PhotoViewController.swift
//
//
//  Created by mac on 6/18/24.
//

import UIKit
import Photos

protocol ShortsCustomGalleryDelegate: AnyObject {
    func informAlbumsDownload()
    func updateCells(at indexPaths: [IndexPath])
}


final class PhotoViewController: UIViewController {
    private enum Const {
        static let numberOfColumns = 4.0
        static let cellSpace = 1.0
        static let length = (UIScreen.main.bounds.size.width - cellSpace * (numberOfColumns - 1)) / numberOfColumns
        static let cellSize = CGSize(width: length, height: length)
        static let scale = UIScreen.main.scale
    }
    
    // MARK: UI
    private let submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("완료", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.setTitleColor(.systemBlue, for: [.normal, .highlighted])
        return button
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 0
        layout.itemSize = Const.cellSize
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isScrollEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = true
        collectionView.contentInset = .zero
        collectionView.backgroundColor = UIColor(.climeetBackground)
        collectionView.clipsToBounds = true
        collectionView.register(PhotoCell.self,
                                forCellWithReuseIdentifier: PhotoCell.id)
        
        return collectionView
    }()
    
    // MARK: Property
    private let albumService: AlbumService = MyAlbumService()
    private let photoService: PhotoService = MyPhotoService()
    private var selectedIndexArray = [Int]()
    private var albums = [PHFetchResult<PHAsset>]()
    private var viewModel: CustomGalleryViewModel?
    
    func injectViewModel(_ vm: CustomGalleryViewModel) {
        self.viewModel = vm
    }
    
    func informAlbumsDownload() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        self.viewModel?.delegate = self
    }
    
    //MARK: Private Methods
    private func setupUI() {
        view.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension PhotoViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        viewModel?.dataSource.count ?? .zero
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.id,
                                                            for: indexPath) as? PhotoCell else {
            return UICollectionViewCell()
        }
        
        guard let viewModel = self.viewModel else {
            return cell
        }
        
        let imageInfo = viewModel.dataSource[indexPath.item]
        let phAsset = imageInfo.phAsset
        print(phAsset.localIdentifier, "phAsset------------------")
        let imageSize = CGSize(width: Const.cellSize.width * Const.scale,
                               height: Const.cellSize.height * Const.scale)
        
        cell.configure(info: imageInfo)
        
        cell.currentTask?.cancel()
        
        cell.currentTask = Task { @MainActor in
            let currentIndexPath = indexPath
            print(phAsset.localIdentifier, "collectionView-------phAsset------------------")
            
            if let thumbnail = await photoService.fetchVideo(
                phAsset: phAsset,
                size: imageSize,
                contentMode: .aspectFit
            ) {
                guard let cell = collectionView.cellForItem(at: currentIndexPath) as? PhotoCell,
                      currentIndexPath == collectionView.indexPath(for: cell) else {
                    return
                }
                
                imageInfo.videoThumbnail = thumbnail
                
                cell.configure(info: .init(
                    phAsset: phAsset,
                    videoThumbnail: thumbnail,
                    duration: imageInfo.duration,
                    selectedOrder: imageInfo.selectedOrder,
                    localIdentifier: phAsset.localIdentifier
                ))
            }
        }
        
        return cell
    }
    
    private func convertTimeIntervalToString(_ timeInterval: TimeInterval) -> String? {
        let formatter: DateComponentsFormatter = .init()
        formatter.allowedUnits = [.minute, .second]
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: timeInterval)
    }
}

extension PhotoViewController: ShortsCustomGalleryDelegate {
    func updateCells(at indexPaths: [IndexPath]) {
        collectionView.performBatchUpdates {
            collectionView.reloadItems(at: indexPaths)
        }
    }
}

extension PhotoViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        Task {
            viewModel?.handleCellSelection(at: indexPath)
        }
    }
}
