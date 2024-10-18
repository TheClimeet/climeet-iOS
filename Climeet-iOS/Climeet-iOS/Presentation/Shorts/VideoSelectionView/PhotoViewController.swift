//
//  PhotoViewController.swift
//
//
//  Created by mac on 6/18/24.
//

import UIKit
import Photos

protocol ShortsCustomGalleryDelegate {
    func informAlbumsDownload()
}

final class PhotoViewController: UIViewController, ShortsCustomGalleryDelegate {
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
    private var selectedIndexArray = [Int]() // Index: count
    private var selectedIndex = Int() // Index: count
    private var prevIndex: Int? = Int() // Index: count
    
   // private var albums = [PHFetchResult<PHAsset>]()
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
        
    override func viewDidDisappear(_ animated: Bool) {
        guard let viewModel = self.viewModel else {
            return
        }
        
        if viewModel.dataSource.count != .zero {
            removeUserSelection(viewModel)
        }
    }
    
    //MARK: Private Methods
    private func removeUserSelection(_ viewModel: CustomGalleryViewModel) {
        let prevIndexPath: IndexPath
        
        if let prevIndex = prevIndex {
            let prevInfo = viewModel.dataSource[prevIndex]
            viewModel.dataSource[prevIndex] = .init(phAsset: prevInfo.phAsset,
                                                    videoThumbnail: prevInfo.videoThumbnail,
                                                    selectedOrder: .none,
                                                    localIdentifier: prevInfo.localIdentifier)
            prevIndexPath = IndexPath(row: selectedIndex, section: 0)
            update(indexPaths: prevIndexPath)
        }
    }
    
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
                                                            for: indexPath) as? PhotoCell else { return UICollectionViewCell() }
        
        guard let viewModel = self.viewModel else {
            return UICollectionViewCell()
        }
        
        let imageInfo = viewModel.dataSource[indexPath.item]
        let phAsset = imageInfo.phAsset
        let imageSize = CGSize(width: Const.cellSize.width * Const.scale,
                               height: Const.cellSize.height * Const.scale)
        //TODO: Prioirity Inversion 해결하기 
        let group = DispatchGroup()
        
        group.enter()
        photoService.fetchVideo(phAsset: phAsset,
                                size: imageSize,
                                contentMode: .aspectFit) { [weak cell] image in
            cell?.prepare(info: .init(phAsset: phAsset,
                                      videoThumbnail: image,
                                      selectedOrder: imageInfo.selectedOrder,
                                      localIdentifier: phAsset.localIdentifier))
            imageInfo.videoThumbnail = image
        }
        group.leave()
        
        cell.prepare(info: viewModel.dataSource[indexPath.item])
        
        return cell
    }
}

extension PhotoViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        guard let viewModel = self.viewModel else {
            return
        }
        
        let info = viewModel.dataSource[indexPath.item]
        let updatingIndexPath: IndexPath
        
        //이미 선택된 사진인경우
        if case .selected = info.selectedOrder {
            viewModel.dataSource[indexPath.item] = .init(phAsset: info.phAsset,
                                                         videoThumbnail: info.videoThumbnail,
                                                         selectedOrder: .none,
                                                         localIdentifier: info.localIdentifier)
            selectedIndex = indexPath.item
            updatingIndexPath = IndexPath(row: selectedIndex, section: 0)
            update(indexPaths: updatingIndexPath)
        } else {
            //이미 다른 선택 사진이 있는 경우 이전 선택 cell 초기화
            if prevIndex != nil {
                removeUserSelection(viewModel)
            }
            
            //선택된 사진 없는 경우
            selectedIndex = indexPath.item
            let current = viewModel.dataSource[selectedIndex]
            
            viewModel.dataSource[selectedIndex] = .init(phAsset: current.phAsset,
                                                        videoThumbnail: current.videoThumbnail,
                                                        selectedOrder: .selected(selectedIndex),
                                                        localIdentifier: current.localIdentifier)
            
            let updatingIndexPath = IndexPath(row: selectedIndex, section: 0)
            update(indexPaths: updatingIndexPath)
            prevIndex = selectedIndex
            
            //뷰모델에 선택한 사진 전달.
            deliverSelectedInfo(current)
            
            //뷰모델에 선택한 사진의 url 전달하기
            deliverSelectedVideoURL(current)
        }
    }
    
    private func deliverSelectedVideoURL(_ cellInfo: PhotoCellInfo) {
        let options = PHVideoRequestOptions()
        options.isNetworkAccessAllowed = false
        
        PHImageManager.default().requestAVAsset(forVideo: cellInfo.phAsset, options: options) { [weak self] (avAsset, _, _) in
            if let urlAsset = avAsset as? AVURLAsset {
                self?.viewModel?.setSelectedVideoURL(urlAsset.url)
            }
        }
    }
    
    private func deliverSelectedInfo(_ selectedCellInfo: PhotoCellInfo) {
        self.viewModel?.selectedVideoThumbnail = selectedCellInfo.videoThumbnail
        self.viewModel?.selectedVideoIdentifier = selectedCellInfo.localIdentifier
    }
    
    private func update(indexPaths: IndexPath) {
        DispatchQueue.main.async { [weak collectionView] in
            collectionView?.performBatchUpdates {
                collectionView?.reloadItems(at: [indexPaths])
            }
        }
    }
}
