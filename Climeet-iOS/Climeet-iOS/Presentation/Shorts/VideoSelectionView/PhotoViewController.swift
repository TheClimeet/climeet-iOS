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
    func updateScrollState(isEnabled: Bool)
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

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupUI()
        setupViewModel()
    }

    //MARK: Private Methods
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    //MARK: Private Methods
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(collectionView)
        view.addSubview(loadingIndicator)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        indicator.color = .white
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private func setupViewModel() {
        self.viewModel?.delegate = self
    }
}

extension PhotoViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        let count = viewModel?.bringVisibleCellCount()
        return count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.id,
                                                             for: indexPath) as? PhotoCell else {
               return UICollectionViewCell()
           }
           
           guard let viewModel = self.viewModel,
                 indexPath.item < viewModel.bringVisibleCellCount() else {
               return cell
           }
           
           let imageInfo = viewModel.dataSource[indexPath.item]
           let phAsset = imageInfo.phAsset
           let imageSize = CGSize(width: Const.cellSize.width * Const.scale,
                                height: Const.cellSize.height * Const.scale)
           
           cell.configure(info: imageInfo)
           cell.currentTask?.cancel()
           
           cell.currentTask = Task { @MainActor in
               if let thumbnail = await photoService.fetchVideo(
                   phAsset: phAsset,
                   size: imageSize,
                   contentMode: .aspectFit,
                   deliveryMode: .fastFormat
               ) {
                   guard let cell = collectionView.cellForItem(at: indexPath) as? PhotoCell,
                         indexPath == collectionView.indexPath(for: cell) else {
                       viewModel.imageLoadingCompleted()
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
                   
                   viewModel.imageLoadingCompleted()
               } else {
                   viewModel.imageLoadingCompleted()
               }
           }
           
           return cell
       }
}

extension PhotoViewController: ShortsCustomGalleryDelegate {
    func updateCells(at indexPaths: [IndexPath]) {
        collectionView.performBatchUpdates {
            collectionView.reloadItems(at: indexPaths)
        }
    }
    
    func informAlbumsDownload() {
        collectionView.reloadData()
    }
    
    func updateScrollState(isEnabled: Bool) {
        collectionView.isScrollEnabled = isEnabled
        if isEnabled {
            loadingIndicator.stopAnimating()
        } else {
            loadingIndicator.startAnimating()
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let screenHeight = scrollView.frame.size.height
        
        if offsetY > contentHeight - (screenHeight * 1.2) {
            viewModel?.loadNextBatch()
        }
    }
}
